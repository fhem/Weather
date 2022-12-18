# $Id:  $
###############################################################################
#
# Developed with VSCodium and richterger perl plugin.
#
#  (c) 2019-2022 Copyright: Marko Oldenburg (fhemdevelopment at cooltux dot net)
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
###############################################################################

### Beispielaufruf
# https://api.openweathermap.org/data/2.5/weather?lat=[lat]&lon=[long]&APPID=[API]   Current
# https://api.openweathermap.org/data/2.5/forecast?lat=[lat]&lon=[long]&APPID=[API]   Forecast
# https://api.openweathermap.org/data/2.5/onecall?lat=[lat]&lon=[long]&APPID=[API]   Forecast
# https://openweathermap.org/weather-conditions     Icons und Conditions ID's

package OpenWeatherMapAPI;
use strict;
use warnings;
use FHEM::Meta;

FHEM::Meta::Load(__PACKAGE__);
use version 0.50; our $VERSION = $::packages{OpenWeatherMapAPI}{META}{version};

package OpenWeatherMapAPI::Weather;
use strict;
use warnings;

use POSIX;
use HttpUtils;
use experimental qw /switch/;

# use Data::Dumper;

# try to use JSON::MaybeXS wrapper
#   for chance of better performance + open code
eval {
    require JSON::MaybeXS;
    import JSON::MaybeXS qw( decode_json encode_json );
    1;
} or do {

    # try to use JSON wrapper
    #   for chance of better performance
    eval {
        # JSON preference order
        local $ENV{PERL_JSON_BACKEND} =
          'Cpanel::JSON::XS,JSON::XS,JSON::PP,JSON::backportPP'
          unless ( defined( $ENV{PERL_JSON_BACKEND} ) );

        require JSON;
        import JSON qw( decode_json encode_json );
        1;
    } or do {

        # In rare cases, Cpanel::JSON::XS may
        #   be installed but JSON|JSON::MaybeXS not ...
        eval {
            require Cpanel::JSON::XS;
            import Cpanel::JSON::XS qw(decode_json encode_json);
            1;
        } or do {

            # In rare cases, JSON::XS may
            #   be installed but JSON not ...
            eval {
                require JSON::XS;
                import JSON::XS qw(decode_json encode_json);
                1;
            } or do {

                # Fallback to built-in JSON which SHOULD
                #   be available since 5.014 ...
                eval {
                    require JSON::PP;
                    import JSON::PP qw(decode_json encode_json);
                    1;
                } or do {

                    # Fallback to JSON::backportPP in really rare cases
                    require JSON::backportPP;
                    import JSON::backportPP qw(decode_json encode_json);
                    1;
                };
            };
        };
    };
};

my $missingModul = '';
## no critic (Conditional "use" statement. Use "require" to conditionally include a module (Modules::ProhibitConditionalUseStatements))
eval { use Encode qw /encode_utf8/; 1 } or $missingModul .= 'Encode ';

# use Data::Dumper;    # for Debug only
## API URL
eval { use Readonly; 1 }
  or $missingModul .= 'Readonly ';    # apt install libreadonly-perl
## use critic

# Readonly my $URL => 'https://api.openweathermap.org/data/2.5/';
Readonly my $URL => 'https://api.openweathermap.org/data/';
## URL . 'weather?' for current data
## URL . 'onecall?' for forecast data

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
    my $apioptions = _parseApiOptions( $argsRef->{apioptions} );

    my $self = {
        devName => $argsRef->{devName},
        key     => (
            ( defined( $argsRef->{apikey} ) && $argsRef->{apikey} )
            ? $argsRef->{apikey}
            : 'none'
        ),
        lang      => $argsRef->{language},
        lat       => ( split( ',', $argsRef->{location} ) )[0],
        long      => ( split( ',', $argsRef->{location} ) )[1],
        fetchTime => 0,
        endpoint  => 'none',
        forecast  => '',
        alerts    => 0,
    };

    $self->{cachemaxage} = (
        defined( $apioptions->{cachemaxage} )
        ? $apioptions->{cachemaxage}
        : 900
    );

    $self->{apiversion} =
      ( $apioptions->{version} ? $apioptions->{version} : '2.5' );

    $self->{cached} = _CreateForecastRef($self);

    bless $self, $class;
    return $self;
}

sub _parseApiOptions {
    my $apioptions = shift;

    my @params;
    my %h;

    @params = split( ',', $apioptions );
    while (@params) {
        my $param = shift(@params);
        next if ( $param eq '' );
        my ( $key, $value ) = split( ':', $param, 2 );
        $h{$key} = $value;
    }

    return \%h;
}

sub setAlerts {
    my $self   = shift;
    my $alerts = shift // 0;

    $self->{alerts} = $alerts;
    return;
}

sub setForecast {
    my $self     = shift;
    my $forecast = shift // '';

    $self->{forecast} = $forecast;
    return;
}

sub setFetchTime {
    my $self = shift;

    $self->{fetchTime} = time();
    return;
}

sub setRetrieveData {
    my $self = shift;

    _RetrieveDataFromOpenWeatherMap($self);
    return;
}

sub setLocation {
    my $self = shift;
    my $lat  = shift;
    my $long = shift;

    $self->{lat}  = $lat;
    $self->{long} = $long;

    return;
}

sub getFetchTime {
    my $self = shift;

    return $self->{fetchTime};
}

sub getWeather {
    my $self = shift;

    return $self->{cached};
}

sub _RetrieveDataFromOpenWeatherMap {
    my $self = shift;

    # retrieve data from cache
    if (   ( time() - $self->{fetchTime} ) < $self->{cachemaxage}
        && $self->{cached}->{lat} == $self->{lat}
        && $self->{cached}->{long} == $self->{long}
        && $self->{endpoint} eq 'none' )
    {
        return _CallWeatherCallbackFn($self);
    }

    $self->{cached}->{lat} = $self->{lat}
      unless ( $self->{cached}->{lat} == $self->{lat} );
    $self->{cached}->{long} = $self->{long}
      unless ( $self->{cached}->{long} == $self->{long} );

    my $paramRef = {
        timeout  => 15,
        self     => $self,
        endpoint => $self->{endpoint} eq 'none' ? 'weather'
        : $self->{endpoint} eq 'weather' ? 'onecall'
        : 'weather',
        callback => \&_RetrieveDataFinished,
    };

    $self->{endpoint} = $paramRef->{endpoint};

    if (   $self->{lat} eq 'error'
        || $self->{long} eq 'error'
        || $self->{key} eq 'none'
        || $missingModul )
    {
        _RetrieveDataFinished(
            $paramRef,
'The given location is invalid. (wrong latitude or longitude?) put both as an attribute in the global device or set define option location=[LAT],[LONG]',
            undef
        ) if ( $self->{lat} eq 'error' || $self->{long} eq 'error' );

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
            $URL
          . $self->{apiversion} . '/'
          . $paramRef->{endpoint} . '?' . 'lat='
          . $self->{lat} . '&' . 'lon='
          . $self->{long} . '&'
          . 'APPID='
          . $self->{key} . '&'
          . 'units='
          . 'metric' . '&' . 'lang='
          . $self->{lang} . '&'
          . 'exclude='
          . _CreateExcludeString( $self->{forecast}, $self->{alerts} );

        ::HttpUtils_NonblockingGet($paramRef);
    }

    return;
}

sub _CreateExcludeString {
    my $forecast = shift;
    my $alerts   = shift;

    my @exclude  = qw/alerts minutely hourly daily/;
    my @forecast = split( ',', $forecast );
    my @alerts   = ( $alerts ? ',alerts' : '' );

    my %in_forecast = map  { $_ => 1 } @forecast, @alerts;
    my @diff        = grep { not $in_forecast{$_} } @exclude;

    return join( ',', @diff );
}

sub _RetrieveDataFinished {
    my $paramRef = shift;
    my $err      = shift;
    my $response = shift;
    my $self     = $paramRef->{self};

    if ( !$err ) {
        $self->{cached}->{status}   = 'ok';
        $self->{cached}->{validity} = 'up-to-date';
        $self->{fetchTime}          = time();
        _ProcessingRetrieveData( $self, $response );
    }
    else {
        $self->{fetchTime} = time() if ( not defined( $self->{fetchTime} ) );
        _ErrorHandling( $self, $err );
        _ProcessingRetrieveData( $self, $response );
    }

    return;
}

sub _ProcessingRetrieveData {
    my $self     = shift;
    my $response = shift;

    if (   $self->{cached}->{status} eq 'ok'
        && defined($response)
        && $response )
    {
        if ( $response =~ m/^{.*}$/x ) {
            my $data = eval { decode_json($response) };

            if ($@) {
                _ErrorHandling( $self,
                    'OpenWeatherMap Weather decode JSON err ' . $@ );
            }
            elsif (defined( $data->{cod} )
                && $data->{cod}
                && $data->{cod} != 200
                && defined( $data->{message} )
                && $data->{message} )
            {
                _ErrorHandling( $self, $data->{cod} . ': ' . $data->{message} );
            }
            else {
                ### Debug
                # print '!!! DEBUG !!! - Endpoint: ' . $self->{endpoint} . "\n";
                # print '!!! DEBUG !!! - Response: ' . Dumper $data;
                ###### Ab hier wird die ResponseHash Referenze für die Rückgabe zusammen gestellt
                $self->{cached}->{current_date_time} =
                  strftimeWrapper( "%a, %e %b %Y %H:%M",
                    localtime( $self->{fetchTime} ) );

                given ( $self->{endpoint} ) {
                    when ('onecall') {
                        $self->{cached}->{current} = {
                            'temperature' => int(
                                sprintf( "%.1f", $data->{current}->{temp} ) +
                                  0.5
                            ),
                            'temp_c' => int(
                                sprintf( "%.1f", $data->{current}->{temp} ) +
                                  0.5
                            ),
                            'tempFeelsLike_c' => int(
                                sprintf( "%.1f",
                                    $data->{current}->{feels_like} ) + 0.5
                            ),
                            'dew_point' => int(
                                sprintf(
                                    "%.1f", $data->{current}->{dew_point}
                                ) + 0.5
                            ),
                            'humidity'  => $data->{current}->{humidity},
                            'condition' => encode_utf8(
                                $data->{current}->{weather}->[0]->{description}
                            ),
                            'pressure' => int(
                                sprintf( "%.1f", $data->{current}->{pressure} )
                                  + 0.5
                            ),
                            'wind' => int(
                                sprintf( "%.1f",
                                    ( $data->{current}->{wind_speed} * 3.6 ) )
                                  + 0.5
                            ),
                            'wind_speed' => int(
                                sprintf( "%.1f",
                                    ( $data->{current}->{wind_speed} * 3.6 ) )
                                  + 0.5
                            ),
                            'wind_gust' => int(
                                sprintf( "%.1f",
                                    ( $data->{current}->{wind_gust} * 3.6 ) ) +
                                  0.5
                            ),
                            'wind_direction' => $data->{current}->{wind_deg},
                            'rain_1h'        => $data->{rain}->{'1h'},
                            'cloudCover'     => $data->{current}->{clouds},
                            'code'           =>
                              $codes{ $data->{current}->{weather}->[0]->{id} },
                            'iconAPI' =>
                              $data->{current}->{weather}->[0]->{icon},
                            'condition' => encode_utf8(
                                $data->{current}->{weather}->[0]->{description}
                            ),
                            'sunsetTime' => strftimeWrapper(
                                "%a, %e %b %Y %H:%M",
                                localtime( $data->{current}->{sunset} )
                            ),
                            'sunriseTime' => strftimeWrapper(
                                "%a, %e %b %Y %H:%M",
                                localtime( $data->{current}->{sunrise} )
                            ),
                            'pubDate' => strftimeWrapper(
                                "%a, %e %b %Y %H:%M",
                                localtime( $data->{current}->{dt} )
                            ),
                            'visibility' => int(
                                sprintf( "%.1f",
                                    $data->{current}->{visibility} ) + 0.5
                            ),
                            'uvi' => $data->{current}->{uvi},
                        };

                        if ( ref( $data->{hourly} ) eq "ARRAY"
                            && scalar( @{ $data->{hourly} } ) > 0 )
                        {
                            ## löschen des alten Datensatzes
                            delete $self->{cached}->{forecast};

                            my $i = 0;
                            for ( @{ $data->{hourly} } ) {
                                push(
                                    @{ $self->{cached}->{forecast}->{hourly} },
                                    {
                                        'pubDate' => strftimeWrapper(
                                            "%a, %e %b %Y %H:%M",
                                            localtime(
                                                ( $data->{hourly}->[$i]->{dt} )
                                                - 3600
                                            )
                                        ),
                                        'day_of_week' => strftime(
                                            "%a, %H:%M",
                                            localtime(
                                                ( $data->{hourly}->[$i]->{dt} )
                                                - 3600
                                            )
                                        ),
                                        'temperature' => int(
                                            sprintf(
                                                "%.1f",
                                                (
                                                    $data->{hourly}->[$i]
                                                      ->{temp}
                                                )
                                            ) + 0.5
                                        ),
                                        'temp_c' => int(
                                            sprintf(
                                                "%.1f",
                                                (
                                                    $data->{hourly}->[$i]
                                                      ->{temp}
                                                )
                                            ) + 0.5
                                        ),
                                        'tempFeelsLike' => int(
                                            sprintf(
                                                "%.1f",
                                                (
                                                    $data->{hourly}->[$i]
                                                      ->{feels_like}
                                                )
                                            ) + 0.5
                                        ),
                                        'dew_point' => int(
                                            sprintf( "%.1f",
                                                $data->{hourly}->[$i]
                                                  ->{dew_point} ) + 0.5
                                        ),
                                        'humidity' =>
                                          $data->{hourly}->[$i]->{humidity},
                                        'condition' => encode_utf8(
                                            $data->{hourly}->[$i]->{weather}
                                              ->[0]->{description}
                                        ),
                                        'pressure' => int(
                                            sprintf( "%.1f",
                                                $data->{hourly}->[$i]
                                                  ->{pressure} ) + 0.5
                                        ),
                                        'wind' => int(
                                            sprintf(
                                                "%.1f",
                                                (
                                                    $data->{hourly}->[$i]
                                                      ->{wind_speed} * 3.6
                                                )
                                            ) + 0.5
                                        ),
                                        'wind_speed' => int(
                                            sprintf(
                                                "%.1f",
                                                (
                                                    $data->{hourly}->[$i]
                                                      ->{wind_speed} * 3.6
                                                )
                                            ) + 0.5
                                        ),
                                        'wind_gust' => int(
                                            sprintf(
                                                "%.1f",
                                                (
                                                    $data->{hourly}->[$i]
                                                      ->{wind_gust} * 3.6
                                                )
                                            ) + 0.5
                                        ),
                                        'wind_direction' =>
                                          $data->{hourly}->[$i]->{wind_deg},
                                        'cloudCover' =>
                                          $data->{hourly}->[$i]->{clouds},
                                        'code' => $codes{
                                            $data->{hourly}->[$i]->{weather}
                                              ->[0]->{id}
                                        },
                                        'iconAPI' =>
                                          $data->{hourly}->[$i]->{weather}->[0]
                                          ->{icon},
                                        'rain1h' =>
                                          $data->{hourly}->[$i]->{rain}->{'1h'},
                                        'snow1h' =>
                                          $data->{hourly}->[$i]->{snow}->{'1h'},
                                        'uvi' => $data->{hourly}->[$i]->{uvi},
                                        'visibility' => int(
                                            sprintf( "%.1f",
                                                $data->{hourly}->[$i]
                                                  ->{visibility} ) + 0.5
                                        ),
                                    },
                                );

                                $i++;
                            }
                        }

                        if ( ref( $data->{daily} ) eq "ARRAY"
                            && scalar( @{ $data->{daily} } ) > 0 )
                        {
                            my $i = 0;
                            for ( @{ $data->{daily} } ) {
                                push(
                                    @{ $self->{cached}->{forecast}->{daily} },
                                    {
                                        'pubDate' => strftimeWrapper(
                                            "%a, %e %b %Y %H:%M",
                                            localtime(
                                                ( $data->{daily}->[$i]->{dt} )
                                                - 3600
                                            )
                                        ),
                                        'day_of_week' => strftime(
                                            "%a, %H:%M",
                                            localtime(
                                                ( $data->{daily}->[$i]->{dt} )
                                                - 3600
                                            )
                                        ),
                                        'sunrise' => strftime(
                                            "%H:%M",
                                            localtime(
                                                (
                                                    $data->{daily}->[$i]
                                                      ->{sunrise}
                                                ) - 3600
                                            )
                                        ),
                                        'sunset' => strftime(
                                            "%a, %H:%M",
                                            localtime(
                                                (
                                                    $data->{daily}->[$i]
                                                      ->{sunset}
                                                ) - 3600
                                            )
                                        ),
                                        'moonrise' => strftime(
                                            "%a, %H:%M",
                                            localtime(
                                                (
                                                    $data->{daily}->[$i]
                                                      ->{moonrise}
                                                ) - 3600
                                            )
                                        ),
                                        'moon_phase' =>
                                          $data->{daily}->[$i]->{moon_phase},
                                        'moonset' => strftime(
                                            "%a, %H:%M",
                                            localtime(
                                                (
                                                    $data->{daily}->[$i]
                                                      ->{moonset}
                                                ) - 3600
                                            )
                                        ),
                                        'temperature' => int(
                                            sprintf( "%.1f",
                                                $data->{daily}->[$i]->{temp}
                                                  ->{day} ) + 0.5
                                        ),
                                        'temperature_morn' => int(
                                            sprintf( "%.1f",
                                                $data->{daily}->[$i]->{temp}
                                                  ->{morn} ) + 0.5
                                        ),
                                        'temperature_eve' => int(
                                            sprintf( "%.1f",
                                                $data->{daily}->[$i]->{temp}
                                                  ->{eve} ) + 0.5
                                        ),
                                        'temperature_night' => int(
                                            sprintf( "%.1f",
                                                $data->{daily}->[$i]->{temp}
                                                  ->{night} ) + 0.5
                                        ),
                                        'tempFeelsLike_morn' => int(
                                            sprintf( "%.1f",
                                                $data->{daily}->[$i]
                                                  ->{feels_like}->{morn} ) + 0.5
                                        ),
                                        'tempFeelsLike_eve' => int(
                                            sprintf( "%.1f",
                                                $data->{daily}->[$i]
                                                  ->{feels_like}->{eve} ) + 0.5
                                        ),
                                        'tempFeelsLike_night' => int(
                                            sprintf( "%.1f",
                                                $data->{daily}->[$i]
                                                  ->{feels_like}->{night} ) +
                                              0.5
                                        ),
                                        'tempFeelsLike_day' => int(
                                            sprintf( "%.1f",
                                                $data->{daily}->[$i]
                                                  ->{feels_like}->{day} ) + 0.5
                                        ),
                                        'temp_c' => int(
                                            sprintf( "%.1f",
                                                $data->{daily}->[$i]->{temp}
                                                  ->{day} ) + 0.5
                                        ),
                                        'low_c' => int(
                                            sprintf( "%.1f",
                                                $data->{daily}->[$i]->{temp}
                                                  ->{min} ) + 0.5
                                        ),
                                        'high_c' => int(
                                            sprintf( "%.1f",
                                                $data->{daily}->[$i]->{temp}
                                                  ->{max} ) + 0.5
                                        ),
                                        'tempLow' => int(
                                            sprintf( "%.1f",
                                                $data->{daily}->[$i]->{temp}
                                                  ->{min} ) + 0.5
                                        ),
                                        'tempHigh' => int(
                                            sprintf( "%.1f",
                                                $data->{daily}->[$i]->{temp}
                                                  ->{max} ) + 0.5
                                        ),
                                        'dew_point' => int(
                                            sprintf( "%.1f",
                                                $data->{daily}->[$i]
                                                  ->{dew_point} ) + 0.5
                                        ),
                                        'humidity' =>
                                          $data->{daily}->[$i]->{humidity},
                                        'condition' => encode_utf8(
                                            $data->{daily}->[$i]->{weather}
                                              ->[0]->{description}
                                        ),
                                        'code' => $codes{
                                            $data->{daily}->[$i]->{weather}
                                              ->[0]->{id}
                                        },
                                        'iconAPI' =>
                                          $data->{daily}->[$i]->{weather}->[0]
                                          ->{icon},
                                        'pressure' => int(
                                            sprintf( "%.1f",
                                                $data->{daily}->[$i]->{pressure}
                                            ) + 0.5
                                        ),
                                        'wind' => int(
                                            sprintf(
                                                "%.1f",
                                                (
                                                    $data->{daily}->[$i]
                                                      ->{wind_speed} * 3.6
                                                )
                                            ) + 0.5
                                        ),
                                        'wind_speed' => int(
                                            sprintf(
                                                "%.1f",
                                                (
                                                    $data->{daily}->[$i]
                                                      ->{wind_speed} * 3.6
                                                )
                                            ) + 0.5
                                        ),
                                        'wind_gust' => int(
                                            sprintf(
                                                "%.1f",
                                                (
                                                    $data->{daily}->[$i]
                                                      ->{wind_gust} * 3.6
                                                )
                                            ) + 0.5
                                        ),
                                        'wind_direction' => int(
                                            sprintf(
                                                "%.1f",
                                                (
                                                    $data->{daily}->[$i]
                                                      ->{wind_deg}
                                                )
                                            )
                                        ),
                                        'cloudCover' =>
                                          $data->{daily}->[$i]->{clouds},
                                        'code' => $codes{
                                            $data->{daily}->[$i]->{weather}
                                              ->[0]->{id}
                                        },
                                        'rain' => $data->{daily}->[$i]->{rain},
                                        'snow' => $data->{daily}->[$i]->{snow},
                                        'uvi'  => $data->{daily}->[$i]->{uvi},
                                    },
                                );

                                $i++;
                            }
                        }

                        if ( ref( $data->{alerts} ) eq "ARRAY"
                            && scalar( @{ $data->{alerts} } ) > 0 )
                        {
                            ## löschen des alten Datensatzes
                            delete $self->{cached}->{alerts};

                            my $i = 0;
                            for ( @{ $data->{alerts} } ) {
                                push(
                                    @{ $self->{cached}->{alerts} },
                                    {
                                        'warn_'
                                          . $i
                                          . '_End' => strftimeWrapper(
                                            "%a, %e %b %Y %H:%M",
                                            localtime(
                                                (
                                                    $data->{alerts}->[$i]->{end}
                                                ) - 3600
                                            )
                                          ),
                                        'warn_'
                                          . $i
                                          . '_Start' => strftimeWrapper(
                                            "%a, %e %b %Y %H:%M",
                                            localtime(
                                                (
                                                    $data->{alerts}->[$i]
                                                      ->{start}
                                                ) - 3600
                                            )
                                          ),
                                        'warn_'
                                          . $i
                                          . '_Description' => encode_utf8(
                                            $data->{alerts}->[$i]->{description}
                                          ),
                                        'warn_'
                                          . $i
                                          . '_SenderName' => encode_utf8(
                                            $data->{alerts}->[$i]->{sender_name}
                                          ),
                                        'warn_'
                                          . $i
                                          . '_Event' => encode_utf8(
                                            $data->{alerts}->[$i]->{event}
                                          ),
                                    },
                                );

                                $i++;
                            }
                        }
                    }
                }
            }
        }
        else { _ErrorHandling( $self, 'OpenWeatherMap ' . $response ); }
    }

    $self->{endpoint} = 'none' if ( $self->{endpoint} eq 'onecall' );

    _RetrieveDataFromOpenWeatherMap($self)
      if ( $self->{endpoint} eq 'weather' );

    _CallWeatherCallbackFn($self) if ( $self->{endpoint} eq 'none' );

    return;
}

sub _CallWeatherCallbackFn {
    my $self = shift;

    #     print 'Dumperausgabe: ' . Dumper $self;
    ### Aufruf der callbackFn
    ::Weather_RetrieveCallbackFn( $self->{devName} );

    return;
}

sub _ErrorHandling {
    my $self = shift;
    my $err  = shift;

    $self->{cached}->{current_date_time} =
      strftimeWrapper( "%a, %e %b %Y %H:%M", localtime( $self->{fetchTime} ) );
    $self->{cached}->{status}   = $err;
    $self->{cached}->{validity} = 'stale';

    return;
}

sub _CreateForecastRef {
    my $self = shift;

    my $forecastRef = (
        {
            lat           => $self->{lat},
            long          => $self->{long},
            apiMaintainer =>
'Marko Oldenburg (<a href=https://forum.fhem.de/index.php?action=profile;u=13684>CoolTux</a>)',
            apiVersion =>
              version->parse( OpenWeatherMapAPI->VERSION() )->normal,
        }
    );

    return $forecastRef;
}

sub strftimeWrapper {
    my @data   = @_;
    my $string = POSIX::strftime(@data);

    $string =~ s/\xe4/ä/xg;
    $string =~ s/\xc4/Ä/xg;
    $string =~ s/\xf6/ö/xg;
    $string =~ s/\xd6/Ö/xg;
    $string =~ s/\xfc/ü/xg;
    $string =~ s/\xdc/Ü/xg;
    $string =~ s/\xdf/ß/xg;
    $string =~ s/\xdf/ß/xg;
    $string =~ s/\xe1/á/xg;
    $string =~ s/\xe9/é/xg;
    $string =~ s/\xc1/Á/xg;
    $string =~ s/\xc9/É/xg;

    return $string;
}

##############################################################################

1;

=pod

=encoding utf8

=for :application/json;q=META.json OpenWeatherMapAPI.pm
{
  "abstract": "Weather API for Weather OpenWeatherMap",
  "x_lang": {
    "de": {
      "abstract": "Wetter API für OpenWeatherMap"
    }
  },
  "version": "v3.0.1",
  "author": [
    "Marko Oldenburg <fhemdevelopment@cooltux.net>"
  ],
  "x_fhem_maintainer": [
    "CoolTux"
  ],
  "x_fhem_maintainer_github": [
    "LeonGaultier"
  ],
  "prereqs": {
    "runtime": {
      "requires": {
        "FHEM::Meta": 0,
        "HttpUtils": 0,
        "strict": 0,
        "warnings": 0,
        "constant": 0,
        "POSIX": 0,
        "JSON::PP": 0
      },
      "recommends": {
        "JSON": 0
      },
      "suggests": {
        "JSON::XS": 0,
        "Cpanel::JSON::XS": 0
      }
    }
  }
}
=end :application/json;q=META.json

=cut

__END__
