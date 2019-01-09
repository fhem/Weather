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
# https://api.openweathermap.org/data/2.5/forcast?lat=[lat]&lon=[long]&APPID=[API]   Forcast
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
## URL . 'forcast?' for forcast data

my %codes = (
    200 => 45, 201 => 45, 202 => 45, 210 => 4, 211 => 4, 212 => 3, 221 => 4, 230 => 45, 231 => 45, 232 => 45,
    300 => 9, 301 => 9, 302 => 9, 310 => 9, 311 => 9, 312 => 9, 313 => 9, 314 => 9, 321 => 9,
    500 => 35, 501 => 35, 502 => 35, 503 => 35, 504 => 35, 511 => 35, 520 => 35, 521 => 35, 522 => 35, 531 => 35,
);

sub new {
    ### geliefert wird ein Hash
    my ( $class, $argsRef ) = @_;

    my $self = {
        devHash => $argsRef->{hash},
        key => ( defined( $argsRef->{apikey} ) ? $argsRef->{apikey} : 'none' ),
        cachemaxage => $argsRef->{cachemaxage},
        lang        => $argsRef->{language},
        lat         => ( split( ',', $argsRef->{location} ) )[0],
        long        => ( split( ',', $argsRef->{location} ) )[1],
        fetchTime   => 0,
        endpoint    => 'none',
    };
    
    $self->{cached} = _CreateForcastRef($self);

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
    if ( (time() - $self->{fetchTime}) < $self->{cachemaxage} ) {
        return _CallWeatherCallbackFn($self);
    }

    my $paramRef = {
        timeout  => 15,
        self     => $self,
        endpoint => ( $self->{endpoint} eq 'none' ? 'weather' : 'forcast' ),
        callback => \&_RetrieveDataFinished,
    };

    $self->{endpoint} = $paramRef->{endpoint};

    if (   $self->{lat} eq 'error'
        or $self->{long} eq 'error'
        or $self->{key} eq 'none'
        or $missingModul )
    {
        _RetrieveDataFinished( $paramRef,
            'The given location is invalid. (wrong latitude or longitude?) put both as an attribute in the global device or set define option location=[LAT],[LONG]',
            undef )
          if ( $self->{lat} eq 'error' or $self->{long} eq 'error' );

        _RetrieveDataFinished( $paramRef, 'No given api key. (define  myWeather Weather apikey=[KEY])', undef )
          if ( $self->{key} eq 'none' );

        _RetrieveDataFinished( $paramRef,
            'Perl modul ' . $missingModul . ' is missing.', undef )
          if ($missingModul);
    }
    else {
        $paramRef->{url} =
            URL
          . $paramRef->{endpoint} . '?'
          . 'lat='
          . $self->{lat} . '&'
          . 'lon='
          . $self->{long} . '&'
          . 'APPID='
          . $self->{key} . '&'
          . 'lang='
          . $self->{lang};

        main::HttpUtils_NonblockingGet($paramRef);
    }
}

sub _RetrieveDataFinished($$$) {
    my ( $paramRef, $err, $response ) = @_;
    my $self = $paramRef->{self};

    if ( !$err ) {
        $self->{cached}->{status}   = 'ok';
        $self->{cached}->{validity} = 'up-to-date',
        $self->{fetchTime} = time();
        _ProcessingRetrieveData( $self, $response );
    }
    else {
        $self->{fetchTime} = time() if ( not defined( $self->{fetchTime} ) );
        _ErrorHandling( $self, $err );
        _ProcessingRetrieveData( $self, $response );
    }
    
    $self->{endpoint} = $paramRef->{endpoint};
}

sub _ProcessingRetrieveData($$) {
    my ( $self, $response ) = @_;

    if ( $self->{cached}->{status} eq 'ok' and defined($response) )
        {
            my $data = eval { decode_json($response) };
            #print 'Dumper1: ' . Dumper $data;

            if ($@) {
                _ErrorHandling( $self, 'OpenWeatherMap Weather decode JSON err ' . $@ );
            }
            elsif ( defined($data->{cod}) and defined($data->{message}) ) {
                print 'Dumper2: ' . Dumper $data;
                _ErrorHandling( $self, $data->{cod} . ': ' . $data->{message} );
            }
            else {
    #             print Dumper $data;       ## für Debugging
                return if ( $self->{endpoint} eq 'forcast' );
                

                $self->{cached}->{current_date_time} = strftime("%a,%e %b %Y %H:%M %p",localtime( $self->{fetchTime} )),
                $self->{cached}->{country} = $data->{sys}->{country};
                $self->{cached}->{city} = $data->{name};
                $self->{cached}->{current} = {
                            'temperature' => int(sprintf("%.1f",($data->{main}->{temp} - 273.15 )) + 0.5),
                            'temp_c'      => int(sprintf("%.1f",($data->{main}->{temp} - 273.15 )) + 0.5),
                            'low_c'       => int(sprintf("%.1f",($data->{main}->{temp_min} - 273.15 )) + 0.5),
                            'high_c'      => int(sprintf("%.1f",($data->{main}->{temp_max} - 273.15 )) + 0.5),
                            'tempLow'     => int(sprintf("%.1f",($data->{main}->{temp_min} - 273.15 )) + 0.5),
                            'tempHigh'    => int(sprintf("%.1f",($data->{main}->{temp_max} - 273.15 )) + 0.5),
                            'humidity'    => $data->{main}->{humidity},
                            'condition' =>
                            encode_utf8( $data->{weather}[0]{description} ),
                            'pressure'       => $data->{main}->{pressure},
                            'wind'           => $data->{wind}->{speed},
                            'wind_speed'     => $data->{wind}->{speed},
                            'wind_direction' => $data->{wind}->{deg},
                            'cloudCover'     => $data->{clouds}->{all},
                            'visibility'     => $data->{visibility},
    #                         'code'           => $codes{ $data->{weather}[0]{icon} },
                            'iconAPI'        => $data->{weather}[0]{icon},
                            'sunsetTime'     => strftime("%a,%e %b %Y %H:%M %p",localtime($data->{sys}->{sunset})),
                            'sunriseTime'    => strftime("%a,%e %b %Y %H:%M %p",localtime($data->{sys}->{sunrise})),
                            'pubDate'        => strftime(
                                "%a,%e %b %Y %H:%M %p",
                                localtime( $data->{dt} )
                            ),
                        } if ( $self->{endpoint} eq 'weather' );
            }
        }

#     $self->{cached} = $forcastRef;         Vorsicht
    
    _RetrieveDataFromOpenWeatherMap($self) if ( $self->{endpoint} eq 'weather' );
    $self->{endpoint} = 'none' if ( $self->{endpoint} eq 'forcast' );
    
    _CallWeatherCallbackFn($self);
}

sub _CallWeatherCallbackFn($) {
    my $self = shift;
    
    #     ## Aufruf der callbackFn
    main::Weather_RetrieveCallbackFn( $self->{devHash} );
}

sub _ErrorHandling($$) {
    my ($self,$err) = @_;

    $self->{cached}->{current_date_time} = strftime("%a,%e %b %Y %H:%M %p",localtime( $self->{fetchTime} )),
    $self->{cached}->{status} = $err;
    $self->{cached}->{validity} = 'stale';
}

sub _CreateForcastRef($) {
    my $self = shift;

    my $forcastRef = (
            {
                lat      => $self->{lat},
                long     => $self->{long},
                apiMaintainer => 'Leon Gaultier (<a href=https://forum.fhem.de/index.php?action=profile;u=13684>CoolTux</a>)',
            }
        );

    return $forcastRef;
}

##############################################################################

1;
