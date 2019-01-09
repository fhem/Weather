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

package DarkSkyAPI::Weather;
use strict;
use warnings;

use POSIX;
use HttpUtils;

my $missingModul = '';
eval "use JSON;1"
  or $missingModul .=
  "JSON ";    # apt-get install libperl-JSON on Debian and derivatives
eval "use Encode qw(encode_utf8);1" or $missingModul .= "Encode ";

# use Data::Dumper;    # for Debug only
## API URL
use constant URL => 'https://api.darksky.net/forecast/';

my %codes = (
    'clear-day'           => 32,
    'clear-night'         => 31,
    'rain'                => 11,
    'snow'                => 16,
    'sleet'               => 18,
    'wind'                => 24,
    'fog'                 => 20,
    'cloudy'              => 26,
    'partly-cloudy-day'   => 30,
    'partly-cloudy-night' => 29,
    'hail'                => 17,
    'thunderstorm'        => 4,
    'tornado'             => 0,
);

sub new {
    ### geliefert wird ein Hash
    my ( $class, $argsRef ) = @_;

    my $self = {
        devName => $argsRef->{devName},
        key => ( defined( $argsRef->{apikey} ) ? $argsRef->{apikey} : 'none' ),
        cachemaxage => $argsRef->{cachemaxage},
        lang        => $argsRef->{language},
        lat         => ( split( ',', $argsRef->{location} ) )[0],
        long        => ( split( ',', $argsRef->{location} ) )[1],
        fetchTime   => 0,
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

    _RetrieveDataFromDarkSky($self);
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

sub _RetrieveDataFromDarkSky($) {
    my $self = shift;

    # retrieve data from cache
    if ( ( time() - $self->{fetchTime} ) < $self->{cachemaxage} ) {
        return _CallWeatherCallbackFn($self);
    }

    my $paramRef = {
        timeout  => 15,
        self     => $self,
        callback => \&_RetrieveDataFinished,
    };

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
          . $self->{key} . '/'
          . $self->{lat} . ','
          . $self->{long}
          . '?lang='
          . $self->{lang}
          . '&units=auto';

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

    if ( $self->{cached}->{status} eq 'ok' and defined($response) ) {
        my $data = eval { decode_json($response) };

        if ($@) {
            _ErrorHandling( $self, 'DarkSky Weather decode JSON err ' . $@ );
        }
        elsif ( defined( $data->{code} ) and defined( $data->{error} ) ) {
            _ErrorHandling( $self,
                'Code: ' . $data->{code} . ' Error: ' . $data->{error} );
        }
        else {
            #             print Dumper $data;       ## für Debugging

            $self->{cached}->{current_date_time} = strftime(
                "%a,%e %b %Y %H:%M %p",
                localtime( $self->{fetchTime} )
              );
            $self->{cached}->{timezone} = $data->{timezone};
            $self->{cached}->{license} = $data->{flags}->{'meteoalarm-license'};
            $self->{cached}->{current} = {
                'temperature' => int(
                    sprintf( "%.1f", $data->{currently}->{temperature} ) + 0.5
                ),
                'temp_c' => int(
                    sprintf( "%.1f", $data->{currently}->{temperature} ) + 0.5
                ),
                'dewPoint' => int(
                    sprintf( "%.1f", $data->{currently}->{dewPoint} ) + 0.5
                ),
                'humidity'   => $data->{currently}->{humidity} * 100,
                'condition'  => encode_utf8( $data->{currently}->{summary} ),
                'pressure'   => $data->{currently}->{pressure},
                'wind'       => $data->{currently}->{windSpeed},
                'wind_speed' => $data->{currently}->{windSpeed},
                'wind_direction' => $data->{currently}->{windBearing},
                'windGust'       => $data->{currently}->{windGust},
                'cloudCover'     => $data->{currently}->{cloudCover},
                'uvIndex'        => $data->{currently}->{uvIndex},
                'visibility'     => $data->{currently}->{visibility},
                'ozone'          => $data->{currently}->{ozone},
                'code'           => $codes{ $data->{currently}->{icon} },
                'iconAPI'        => $data->{currently}->{icon},
                'pubDate'        => strftime(
                    "%a,%e %b %Y %H:%M %p",
                    localtime( $data->{currently}->{'time'} )
                ),
                'precipProbability' => $data->{currently}->{precipProbability},
                'apparentTemperature' => int(
                    sprintf(
                        "%.1f", $data->{currently}->{apparentTemperature}
                    ) + 0.5
                ),
                'precipIntensity' => $data->{currently}->{precipIntensity},
            };

            if ( ref( $data->{daily}->{data} ) eq "ARRAY"
                and scalar( @{ $data->{daily}->{data} } ) > 0 )
            {
                my $i = 0;
                foreach ( @{ $data->{daily}->{data} } ) {
                    push(
                        @{ $self->{cached}->{forecast}->{daily} },
                        {
                            'date' => strftime(
                                "%a, %d.%m.%Y",
                                localtime( $data->{daily}->{data}[$i]{'time'} )
                            ),
                            'day_of_week' => strftime(
                                "%a",
                                localtime( $data->{daily}->{data}[$i]{'time'} )
                            ),
                            'low_c' => int(
                                sprintf( "%.1f",
                                    $data->{daily}->{data}[$i]{temperatureLow} )
                                  + 0.5
                            ),
                            'high_c' => int(
                                sprintf( "%.1f",
                                    $data->{daily}->{data}[$i]{temperatureHigh}
                                ) + 0.5
                            ),
                            'tempMin' => int(
                                sprintf( "%.1f",
                                    $data->{daily}->{data}[$i]{temperatureMin} )
                                  + 0.5
                            ),
                            'tempMinTime' => strftime(
                                "%a,%e %b %Y %H:%M %p",
                                localtime(
                                    $data->{daily}
                                      ->{data}[$i]{temperatureMinTime}
                                )
                            ),
                            'tempMax' => int(
                                sprintf( "%.1f",
                                    $data->{daily}->{data}[$i]{temperatureMax} )
                                  + 0.5
                            ),
                            'tempMaxTime' => strftime(
                                "%a,%e %b %Y %H:%M %p",
                                localtime(
                                    $data->{daily}
                                      ->{data}[$i]{temperatureMaxTime}
                                )
                            ),
                            'tempLow' => int(
                                sprintf( "%.1f",
                                    $data->{daily}->{data}[$i]{temperatureLow} )
                                  + 0.5
                            ),
                            'tempLowTime' => strftime(
                                "%a,%e %b %Y %H:%M %p",
                                localtime(
                                    $data->{daily}
                                      ->{data}[$i]{temperatureLowTime}
                                )
                            ),
                            'tempHigh' => int(
                                sprintf( "%.1f",
                                    $data->{daily}->{data}[$i]{temperatureHigh}
                                ) + 0.5
                            ),
                            'tempHighTime' => strftime(
                                "%a,%e %b %Y %H:%M %p",
                                localtime(
                                    $data->{daily}
                                      ->{data}[$i]{temperatureHighTime}
                                )
                            ),
                            'apparentTempLow' => int(
                                sprintf( "%.1f",
                                    $data->{daily}
                                      ->{data}[$i]{apparentTemperatureLow} ) +
                                  0.5
                            ),
                            'apparentTempLowTime' => strftime(
                                "%a,%e %b %Y %H:%M %p",
                                localtime(
                                    $data->{daily}
                                      ->{data}[$i]{apparentTemperatureLowTime}
                                )
                            ),
                            'apparentTempHigh' => int(
                                sprintf( "%.1f",
                                    $data->{daily}
                                      ->{data}[$i]{apparentTemperatureHigh} ) +
                                  0.5
                            ),
                            'apparentTempHighTime' => strftime(
                                "%a,%e %b %Y %H:%M %p",
                                localtime(
                                    $data->{daily}
                                      ->{data}[$i]{apparentTemperatureHighTime}
                                )
                            ),
                            'apparenttempMin' => int(
                                sprintf( "%.1f",
                                    $data->{daily}
                                      ->{data}[$i]{apparentTemperatureMin} ) +
                                  0.5
                            ),
                            'apparenttempMinTime' => strftime(
                                "%a,%e %b %Y %H:%M %p",
                                localtime(
                                    $data->{daily}
                                      ->{data}[$i]{apparentTemperatureMinTime}
                                )
                            ),
                            'apparenttempMax' => int(
                                sprintf( "%.1f",
                                    $data->{daily}
                                      ->{data}[$i]{apparentTemperatureMax} ) +
                                  0.5
                            ),
                            'apparenttempMaxTime' => strftime(
                                "%a,%e %b %Y %H:%M %p",
                                localtime(
                                    $data->{daily}
                                      ->{data}[$i]{apparentTemperatureMaxTime}
                                )
                            ),
                            'code' =>
                              $codes{ $data->{daily}->{data}[$i]{icon} },
                            'iconAPI'   => $data->{daily}->{data}[$i]{icon},
                            'condition' => encode_utf8(
                                $data->{daily}->{data}[$i]{summary}
                            ),
                            'ozone'   => $data->{daily}->{data}[$i]{ozone},
                            'uvIndex' => $data->{daily}->{data}[$i]{uvIndex},
                            'uvIndexTime' => strftime(
                                "%a,%e %b %Y %H:%M %p",
                                localtime(
                                    $data->{daily}->{data}[$i]{uvIndexTime}
                                )
                            ),
                            'precipIntensity' =>
                              $data->{daily}->{data}[$i]{precipIntensity},
                            'precipIntensityMax' =>
                              $data->{daily}->{data}[$i]{precipIntensityMax},
                            'precipIntensityMaxTime' => strftime(
                                "%a,%e %b %Y %H:%M %p",
                                localtime(
                                    $data->{daily}
                                      ->{data}[$i]{precipIntensityMaxTime}
                                )
                            ),
                            'dewPoint' => $data->{daily}->{data}[$i]{dewPoint},
                            'humidity' => $data->{daily}->{data}[$i]{humidity}
                              * 100,
                            'cloudCover' =>
                              $data->{daily}->{data}[$i]{cloudCover},
                            'precipType' =>
                              $data->{daily}->{data}[$i]{precipType},

                            'wind_direction' =>
                              $data->{daily}->{data}[$i]{windBearing},
                            'wind' => $data->{daily}->{data}[$i]{windSpeed},
                            'wind_speed' =>
                              $data->{daily}->{data}[$i]{windSpeed},
                            'windGust' => $data->{daily}->{data}[$i]{windGust},
                            'windGustTime' => strftime(
                                "%a,%e %b %Y %H:%M %p",
                                localtime(
                                    $data->{daily}->{data}[$i]{windGustTime}
                                )
                            ),
                            'moonPhase' =>
                              $data->{daily}->{data}[$i]{moonPhase},
                            'sunsetTime' => strftime(
                                "%a,%e %b %Y %H:%M %p",
                                localtime(
                                    $data->{daily}->{data}[$i]{sunsetTime}
                                )
                            ),
                            'sunriseTime' => strftime(
                                "%a,%e %b %Y %H:%M %p",
                                localtime(
                                    $data->{daily}->{data}[$i]{sunriseTime}
                                )
                            ),

                            'precipProbability' =>
                              $data->{daily}->{data}[$i]{precipProbability},
                            'pressure' => $data->{daily}->{data}[$i]{pressure},
                            'visibility' =>
                              $data->{daily}->{data}[$i]{visibility},
                        }
                    );
                    
                    $i++;
                }
            }
        }
    }

    ## Aufruf der callbackFn
    _CallWeatherCallbackFn($self);
}

sub _CallWeatherCallbackFn($) {
    my $self = shift;

    #     ## Aufruf der callbackFn
    main::Weather_RetrieveCallbackFn( $self->{devName} );
}

sub _ErrorHandling($$) {
    my ( $self, $err ) = @_;

    $self->{cached}->{current_date_time} =
    strftime( "%a,%e %b %Y %H:%M %p", localtime( $self->{fetchTime} ) ),
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
