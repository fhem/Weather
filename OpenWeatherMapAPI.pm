###############################################################################
#
# Developed with Kate
#
#  (c) 2019 Copyright: Marko Oldenburg (leongaultier at gmail dot com)
#  All rights reserved
#
#   Special thanks goes to:
#
#
#  This script is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License,or
#  any later version.
#
#  The GNU General Public License can be found at
#  http://www.gnu.org/copyleft/gpl.html.
#  A copy is found in the textfile GPL.txt and important notices to the license
#  from the author is found in LICENSE.txt distributed with these scripts.
#
#  This script is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#
# $Id$
#
###############################################################################

### Beispielaufruf
# https://api.openweathermap.org/data/2.5/weather?lat=[lat]&lon=[long]&APPID=[API]   Current
# https://api.openweathermap.org/data/2.5/forecast?lat=[lat]&lon=[long]&APPID=[API]   Forecast
# https://openweathermap.org/weather-conditions     Icons und Conditions ID's

package OpenWeatherMapAPI::Weather;
use strict;
use warnings;

use POSIX;
use HttpUtils;

my $missingModul = '';
eval "use JSON;1"
  or $missingModul .=
  "JSON ";    # apt-get install libperl-JSON on Debian and derivatives
eval "use Encode qw(encode_utf8);1" or $missingModul .= "Encode ";

use Data::Dumper;    # for Debug only
## API URL
use constant URL => 'https://api.openweathermap.org/data/2.5/';
## URL . 'weather?' for current data
## URL . 'forecast?' for forecast data

my %codes = (
    200 => 45,
    201 => 45,
    202 => 45,
    210 => 4,
    211 => 4,
    212 => 3,
    221 => 4,
    230 => 45,
    231 => 45,
    232 => 45,
    300 => 9,
    301 => 9,
    302 => 9,
    310 => 9,
    311 => 9,
    312 => 9,
    313 => 9,
    314 => 9,
    321 => 9,
    500 => 35,
    501 => 35,
    502 => 35,
    503 => 35,
    504 => 35,
    511 => 35,
    520 => 35,
    521 => 35,
    522 => 35,
    531 => 35,
    600 => 14,
    601 => 16,
    602 => 13,
    611 => 46,
    612 => 46,
    615 => 5,
    616 => 5,
    620 => 14,
    621 => 46,
    622 => 42,
    701 => 19,
    711 => 22,
    721 => 19,
    731 => 23,
    741 => 20,
    751 => 23,
    761 => 19,
    762 => 3200,
    771 => 1,
    781 => 0,
    800 => 32,
    801 => 30,
    802 => 26,
    803 => 26,
    804 => 28,
);

sub new {
    ### geliefert wird ein Hash
    my ( $class, $argsRef ) = @_;

    my $self = {
        devName => $argsRef->{devName},
        key     => (
            ( defined( $argsRef->{apikey} ) and $argsRef->{apikey} )
            ? $argsRef->{apikey}
            : 'none'
        ),
        cachemaxage => (
            ( defined( $argsRef->{apioptions} ) and $argsRef->{apioptions} )
            ? ( ( split( ':', $argsRef->{apioptions} ) )[0] eq 'cachemaxage'
                ? ( split( ':', $argsRef->{apioptions} ) )[1]
                : 900 )
            : 900
        ),
        lang      => $argsRef->{language},
        lat       => ( split( ',', $argsRef->{location} ) )[0],
        long      => ( split( ',', $argsRef->{location} ) )[1],
        fetchTime => 0,
        endpoint  => 'none',
    };

    $self->{cached} = _CreateForecastRef($self);

    bless $self, $class;
    return $self;
}

sub setFetchTime {
    my $self = shift;

    $self->{fetchTime} = time();
    return 0;
}

sub setRetrieveData {
    my $self = shift;

    _RetrieveDataFromOpenWeatherMap($self);
    return 0;
}

sub getFetchTime {
    my $self = shift;

    return $self->{fetchTime};
}

sub getWeather {
    my $self = shift;

    return $self->{cached};
}

sub _RetrieveDataFromOpenWeatherMap($) {
    my $self = shift;

    # retrieve data from cache
    if ( $self->{endpoint} eq 'none' ) {
        if ( ( time() - $self->{fetchTime} ) < $self->{cachemaxage} ) {
            return _CallWeatherCallbackFn($self);
        }
    }

    my $paramRef = {
        timeout  => 15,
        self     => $self,
        endpoint => ( $self->{endpoint} eq 'none' ? 'weather' : 'forecast' ),
        callback => \&_RetrieveDataFinished,
    };

    $self->{endpoint} = $paramRef->{endpoint};

    if (   $self->{lat} eq 'error'
        or $self->{long} eq 'error'
        or $self->{key} eq 'none'
        or $missingModul )
    {
        _RetrieveDataFinished(
            $paramRef,
'The given location is invalid. (wrong latitude or longitude?) put both as an attribute in the global device or set define option location=[LAT],[LONG]',
            undef
        ) if ( $self->{lat} eq 'error' or $self->{long} eq 'error' );

        _RetrieveDataFinished( $paramRef,
            'No given api key. (define  myWeather Weather apikey=[KEY])',
            undef )
          if ( $self->{key} eq 'none' );

        _RetrieveDataFinished( $paramRef,
            'Perl modul ' . $missingModul . ' is missing.', undef )
          if ($missingModul);
    }
    else {
        $paramRef->{url} =
            URL
          . $paramRef->{endpoint} . '?' . 'lat='
          . $self->{lat} . '&' . 'lon='
          . $self->{long} . '&'
          . 'APPID='
          . $self->{key} . '&' . 'lang='
          . $self->{lang};

        main::HttpUtils_NonblockingGet($paramRef);
    }
}

sub _RetrieveDataFinished($$$) {
    my ( $paramRef, $err, $response ) = @_;
    my $self = $paramRef->{self};

    if ( !$err ) {
        $self->{cached}->{status} = 'ok';
        $self->{cached}->{validity} = 'up-to-date', $self->{fetchTime} = time();
        _ProcessingRetrieveData( $self, $response );
    }
    else {
        $self->{fetchTime} = time() if ( not defined( $self->{fetchTime} ) );
        _ErrorHandling( $self, $err );
        _ProcessingRetrieveData( $self, $response );
    }
}

sub _ProcessingRetrieveData($$) {
    my ( $self, $response ) = @_;

    if (    $self->{cached}->{status} eq 'ok'
        and defined($response)
        and $response )
    {
        my $data = eval { decode_json($response) };

        if ($@) {
            _ErrorHandling( $self,
                'OpenWeatherMap Weather decode JSON err ' . $@ );
        }
        elsif ( defined( $data->{cod} )
            and $data->{cod}
            and $data->{cod} != 200
            and defined( $data->{message} )
            and $data->{message} )
        {
            _ErrorHandling( $self, $data->{cod} . ': ' . $data->{message} );
        }
        else {

            ###### Ab hier wird die ResponseHash Referenze für die Rückgabe zusammen gestellt
            $self->{cached}->{current_date_time} =
              strftime( "%a, %e %b %Y %H:%M %p",
                localtime( $self->{fetchTime} ) );

            if ( $self->{endpoint} eq 'weather' ) {
                $self->{cached}->{country}       = $data->{sys}->{country};
                $self->{cached}->{city}          = $data->{name};
                $self->{cached}->{license}{text} = 'none';
                $self->{cached}->{current}       = {
                    'temperature' => int(
                        sprintf( "%.1f", ( $data->{main}->{temp} - 273.15 ) ) +
                          0.5
                    ),
                    'temp_c' => int(
                        sprintf( "%.1f", ( $data->{main}->{temp} - 273.15 ) ) +
                          0.5
                    ),
                    'low_c' => int(
                        sprintf( "%.1f",
                            ( $data->{main}->{temp_min} - 273.15 ) ) + 0.5
                    ),
                    'high_c' => int(
                        sprintf( "%.1f",
                            ( $data->{main}->{temp_max} - 273.15 ) ) + 0.5
                    ),
                    'tempLow' => int(
                        sprintf( "%.1f",
                            ( $data->{main}->{temp_min} - 273.15 ) ) + 0.5
                    ),
                    'tempHigh' => int(
                        sprintf( "%.1f",
                            ( $data->{main}->{temp_max} - 273.15 ) ) + 0.5
                    ),
                    'humidity' => $data->{main}->{humidity},
                    'condition' =>
                      encode_utf8( $data->{weather}->[0]->{description} ),
                    'pressure' =>
                      int( sprintf( "%.1f", $data->{main}->{pressure} ) + 0.5 ),
                    'wind' =>
                      int( sprintf( "%.1f", $data->{wind}->{speed} ) + 0.5 ),
                    'wind_speed' =>
                      int( sprintf( "%.1f", $data->{wind}->{speed} ) + 0.5 ),
                    'wind_direction' => $data->{wind}->{deg},
                    'cloudCover'     => $data->{clouds}->{all},
                    'visibility' =>
                      int( sprintf( "%.1f", $data->{visibility} ) + 0.5 ),
                    'code'       => $codes{ $data->{weather}->[0]->{id} },
                    'iconAPI'    => $data->{weather}->[0]->{icon},
                    'sunsetTime' => strftime(
                        "%a, %e %b %Y %H:%M %p",
                        localtime( $data->{sys}->{sunset} )
                    ),
                    'sunriseTime' => strftime(
                        "%a, %e %b %Y %H:%M %p",
                        localtime( $data->{sys}->{sunrise} )
                    ),
                    'pubDate' => strftime(
                        "%a, %e %b %Y %H:%M %p",
                        localtime( $data->{dt} )
                    ),
                };
            }

            if ( $self->{endpoint} eq 'forecast' ) {
                if ( ref( $data->{list} ) eq "ARRAY"
                    and scalar( @{ $data->{list} } ) > 0 )
                {
                    ## löschen des alten Datensatzes
                    delete $self->{cached}->{forecast};

                    my $i = 0;
                    foreach ( @{ $data->{list} } ) {
                        push(
                            @{ $self->{cached}->{forecast}->{hourly} },
                            {
                                'pubDate' => strftime(
                                    "%a, %e %b %Y %H:%M %p",
                                    localtime(
                                        ( $data->{list}->[$i]->{dt} ) - 3600
                                    )
                                ),
                                'temperature' => int(
                                    sprintf(
                                        "%.1f",
                                        (
                                            $data->{list}->[$i]->{main}->{temp}
                                              - 273.15
                                        )
                                    ) + 0.5
                                ),
                                'temp_c' => int(
                                    sprintf(
                                        "%.1f",
                                        (
                                            $data->{list}->[$i]->{main}->{temp}
                                              - 273.15
                                        )
                                    ) + 0.5
                                ),
                                'low_c' => int(
                                    sprintf(
                                        "%.1f",
                                        (
                                            $data->{list}->[$i]->{main}
                                              ->{temp_min} - 273.15
                                        )
                                    ) + 0.5
                                ),
                                'high_c' => int(
                                    sprintf(
                                        "%.1f",
                                        (
                                            $data->{list}->[$i]->{main}
                                              ->{temp_max} - 273.15
                                        )
                                    ) + 0.5
                                ),
                                'tempLow' => int(
                                    sprintf(
                                        "%.1f",
                                        (
                                            $data->{list}->[$i]->{main}
                                              ->{temp_min} - 273.15
                                        )
                                    ) + 0.5
                                ),
                                'tempHigh' => int(
                                    sprintf(
                                        "%.1f",
                                        (
                                            $data->{list}->[$i]->{main}
                                              ->{temp_max} - 273.15
                                        )
                                    ) + 0.5
                                ),
                                'humidity' =>
                                  $data->{list}->[$i]->{main}->{humidity},
                                'condition' => encode_utf8(
                                    $data->{list}->[$i]->{weather}->[0]
                                      ->{description}
                                ),
                                'pressure' => int(
                                    sprintf( "%.1f",
                                        $data->{list}->[$i]->{main}->{pressure}
                                    ) + 0.5
                                ),
                                'wind' => int(
                                    sprintf( "%.1f",
                                        $data->{list}->[$i]->{wind}->{speed} )
                                      + 0.5
                                ),
                                'wind_speed' => int(
                                    sprintf( "%.1f",
                                        $data->{list}->[$i]->{wind}->{speed} )
                                      + 0.5
                                ),
                                'cloudCover' =>
                                  $data->{list}->[$i]->{clouds}->{all},
                                'code' =>
                                  $codes{ $data->{list}->[$i]->{weather}->[0]
                                      ->{id} },
                                'iconAPI' =>
                                  $data->{list}->[$i]->{weather}->[0]->{icon},
                            },
                        );

                        $i++;
                    }
                }
            }
        }
    }

    $self->{endpoint} = 'none' if ( $self->{endpoint} eq 'forecast' );

    _RetrieveDataFromOpenWeatherMap($self)
      if ( $self->{endpoint} eq 'weather' );

    _CallWeatherCallbackFn($self) if ( $self->{endpoint} eq 'none' );
}

sub _CallWeatherCallbackFn($) {
    my $self = shift;

    #     print 'Dumperausgabe: ' . Dumper $self;
    ### Aufruf der callbackFn
    main::Weather_RetrieveCallbackFn( $self->{devName} );
}

sub _ErrorHandling($$) {
    my ( $self, $err ) = @_;

    $self->{cached}->{current_date_time} =
      strftime( "%a, %e %b %Y %H:%M %p", localtime( $self->{fetchTime} ) ),
      $self->{cached}->{status} = $err;
    $self->{cached}->{validity} = 'stale';
}

sub _CreateForecastRef($) {
    my $self = shift;

    my $forecastRef = (
        {
            lat  => $self->{lat},
            long => $self->{long},
            apiMaintainer =>
'Leon Gaultier (<a href=https://forum.fhem.de/index.php?action=profile;u=13684>CoolTux</a>)',
        }
    );

    return $forecastRef;
}

##############################################################################

1;
