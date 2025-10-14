### Refactor language handling to improve readability (HEAD -> patch-remove-perlexperimental)
>Tue, 14 Oct 2025 07:01:07 +0200

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

Improved the language initialization logic by replacing the
experimental `given/when` construct with a more standard
`if/elsif` structure, enhancing code readability and
maintainability. Additionally, the attribute handling in the
`Attr` subroutine was refactored for clarity, removing
unnecessary usage of `given/when`, which helps reduce
complexity across the codebase.

Furthermore, in the OpenWeatherMapAPI module, logic for
handling weather response data was streamlined by removing
the `given/when` statements in favor of `if` conditions.
This change eliminates potential confusion and enhances
the clarity of the code logic. No breaking changes were
introduced; the overall functionality remains intact.



### Refactor language initialization and attribute handling
>Tue, 14 Oct 2025 06:53:44 +0200

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

Improved the language initialization logic by replacing
the experimental `given/when` construct with a more
standard `if/elsif` structure. This change enhances code
readability and maintainability, making it easier to follow
the flow of language assignments.

Additionally, refactored attribute handling in the `Attr`
subroutine by streamlining the conditions, removing
unnecessary `given/when` usage, and maintaining clarity
in the logic for setting and deleting forecasts and alerts.
These changes help reduce complexity and improve
consistency throughout the codebase.



### ``` Refactor pre-commit hook by removing DarkSkyAPI references
>Wed, 5 Feb 2025 07:08:45 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

Updated the pre-commit hook to eliminate references to
'lib/FHEM/APIs/Weather/DarkSkyAPI.pm'. This change was made to
simplify the codebase and make it more relevant by focusing on
the other weather API files.

Additionally, the output formatting of the pre-commit hook
has been improved for better readability, and the order of
the files in the @filenames array has been restructured for
clarity.

No breaking changes have been introduced; the pre-commit
hook continues to operate as intended.
```



### ``` Refactor pre-commit hook file list and output formatting
>Wed, 5 Feb 2025 07:07:52 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

Updated the list of files in the pre-commit hook to remove
references to 'lib/FHEM/APIs/Weather/DarkSkyAPI.pm' and adjusted
the output formatting for better readability. The order of the
files in the @filenames array has been restructured for clarity.
These changes were necessary to ensure our code base focuses on
the more relevant weather API files.

No breaking changes introduced; the pre-commit hook continues to
function as intended.
```



### docs: add changelog
>Tue, 4 Feb 2025 21:27:10 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### docs: fix unbalanced p
>Tue, 4 Feb 2025 21:26:52 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### docs: add changelog
>Tue, 4 Feb 2025 21:01:33 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### feat: remove DarkSky, change versions remove DarkSkyAPI, no longer supported change Copyright years and versions of OWM API
>Tue, 4 Feb 2025 21:01:17 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

[Ticket: no]



### docs: changelog
>Tue, 4 Feb 2025 20:53:14 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

[Ticket: no]



### fix: apply patch from stefanru https://forum.fhem.de/index.php?msg=1332884
>Tue, 4 Feb 2025 20:52:52 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

[Ticket: no]



### docs: new CHANGELOG
>Fri, 11 Oct 2024 12:04:37 +0200

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### docs: change versions and add copyright
>Fri, 11 Oct 2024 12:04:07 +0200

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### docs: Changelog
>Fri, 11 Oct 2024 07:07:57 +0200

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

[Ticket: no]



### fix: Update forecast with cachemaxage after API calls are down. special thanks to stefanru (forum)
>Fri, 11 Oct 2024 06:59:53 +0200

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

[Ticket: no]



### test: add new CHANGELOG
>Sat, 21 Oct 2023 08:59:11 +0200

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### feat: new reading owmAPICode for original code
>Tue, 11 Jul 2023 14:10:13 +0200

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

[Ticket: no]



### feat: add human-readable text of daily forecast
>Tue, 6 Jun 2023 08:35:06 +0200

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

add the proper human-readable text description of the daily forecast

[Ticket: no]



### add temperatur reading and fix weblink
>Tue, 23 May 2023 08:08:42 +0200

>Author: Marko Oldenburg (oldenburg@b1-systems.de)

>Commiter: Marko Oldenburg (oldenburg@b1-systems.de)




### fix: missing perl modules
>Sun, 5 Feb 2023 09:26:04 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### fix: failed then Readonly is missing
>Sun, 5 Feb 2023 09:20:20 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### fix: : Undefined subroutine
>Thu, 2 Feb 2023 22:58:40 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

&FHEM::Core::Weather::DeleteForecastreadings

[Ticket: #46]



### docs: add new entry in CHANGELOG.md (tag: v2.2.22)
>Tue, 10 Jan 2023 21:44:20 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### build: v2.2.22
>Tue, 10 Jan 2023 21:43:26 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### docs: add new modul path in to pre-commit
>Tue, 10 Jan 2023 21:37:10 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

add new modul path in to pre-commit hook file



### revert: mod packages
>Tue, 10 Jan 2023 21:32:56 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

- packages Weather.pm
- split FHEM/59_Weather.pm in two files and packages (FEHM/59_Weather.pm
and FHEM/Core/Weather.pm

[optional body]

[Ticket: no]



### fix: #40
>Tue, 10 Jan 2023 16:09:53 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

Undefined subroutine &FHEM::APIs::Weather::DarkSkyAPI::__strftimeWrapper



### docs: add new changelog and change version (tag: v2.2.21)
>Sun, 8 Jan 2023 21:56:15 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### fix: bugfix function WeatherAsHtmlD not working
>Sun, 8 Jan 2023 21:54:31 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### docs: new changelog entry
>Sun, 8 Jan 2023 17:11:31 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### docs: new versions
>Sun, 8 Jan 2023 17:11:03 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### fix: #31
>Sun, 8 Jan 2023 17:05:11 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

Use of uninitialized value in DarkSkyAPI.pm line 730



### fix: #30
>Sun, 8 Jan 2023 16:52:11 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

Use of uninitialized value in OpenWeatherMapAPI.pm line 981



### fix: wrong snow hour assignment
>Sun, 8 Jan 2023 16:21:40 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### feat: v2.2.20 out (tag: v2.2.20)
>Sat, 7 Jan 2023 13:39:03 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

new version is out, Release 2.2.20



### style: change version
>Sat, 7 Jan 2023 13:33:17 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

change version numbers



### docs: change commandref
>Sat, 7 Jan 2023 13:21:27 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

change commandref with id tags



### fix uninitialized value in multiplication
>Thu, 5 Jan 2023 19:40:21 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

when wind_guest not given



### change old snow and rain value to zero
>Thu, 5 Jan 2023 17:02:46 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### add hook example add support for onecall endpoint with api version 2.5
>Thu, 5 Jan 2023 08:18:05 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### fix regex for sun and moon set and rise
>Mon, 2 Jan 2023 09:27:41 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### fix Undefined subroutine
>Fri, 30 Dec 2022 13:17:40 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

Undefined subroutine &FHEM::APIs::Weather::wundergroundAPI::strftimeWrapper



### fix
>Fri, 30 Dec 2022 12:17:37 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### fix sub
>Fri, 30 Dec 2022 12:14:33 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### fix undefined value as an ARRAY reference
>Fri, 30 Dec 2022 12:11:19 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### fix some regex formating
>Thu, 29 Dec 2022 04:41:10 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### change versions and add control file
>Wed, 28 Dec 2022 09:24:12 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### remove celvin substration
>Wed, 28 Dec 2022 09:10:14 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### fix "PERL WARNING: Use of uninitialized value"
>Sun, 25 Dec 2022 09:20:58 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

no {wind}->{gust} field in $data



### fix undefined value
>Sat, 24 Dec 2022 12:57:41 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

Can't use an undefined value as an ARRAY reference at ./FHEM/59_Weather.pm line 589



### change versions
>Sat, 24 Dec 2022 10:20:09 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### move and rename API.de API description
>Sat, 24 Dec 2022 04:48:42 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

change README.m API.de description



### add directory structure move API files remove YahooWeatherAPI
>Sat, 24 Dec 2022 04:39:45 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### move API files to lib/FHEM/APIs/Weather
>Thu, 22 Dec 2022 18:45:07 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### fix forecast number for weblink
>Wed, 21 Dec 2022 09:06:54 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### expand notify fn grep syntax
>Tue, 20 Dec 2022 18:42:36 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### change code for better def modify
>Tue, 20 Dec 2022 18:04:45 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### fix IsDisabled
>Tue, 20 Dec 2022 15:29:49 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

change condition for is disabled in GetUpdate fn



### change versions of API modules add Copyright year range
>Tue, 20 Dec 2022 14:43:12 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### fix remove old data
>Tue, 20 Dec 2022 13:24:15 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### fix Weather_CheckOptions func
>Tue, 20 Dec 2022 12:53:44 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### add warnCount reading
>Mon, 19 Dec 2022 15:29:06 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### fix negativ integer value round fix alerts integration
>Mon, 19 Dec 2022 11:24:27 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### fix onecall update, remove weather endpoint
>Sun, 18 Dec 2022 10:58:24 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### change wind_chill to decimal
>Wed, 14 Dec 2022 21:35:21 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### change pressure value to decimal
>Wed, 14 Dec 2022 20:42:07 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### fix integer declaration for temperature values
>Wed, 14 Dec 2022 20:10:58 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### Subject line (try to keep under 50 characters)
>Wed, 14 Dec 2022 19:51:18 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

Multi-line description of commit,
feel free to be detailed.

[Ticket: X]



### fix older entrys
>Wed, 14 Dec 2022 19:24:14 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### add numericPrecision=decimal option
>Wed, 14 Dec 2022 16:21:14 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### fix delete Readings
>Wed, 14 Dec 2022 11:26:32 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### fix delete Reading Counter
>Wed, 14 Dec 2022 11:08:36 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### fix forecast exclude and change commandref
>Wed, 14 Dec 2022 10:38:04 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### fix empty deklaration
>Tue, 13 Dec 2022 19:04:01 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### fix litte bugs in API modul
>Tue, 13 Dec 2022 14:00:46 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

add first code for daily and hourly forcast delete count



### better formart
>Sat, 26 Nov 2022 06:43:20 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### remove double dewpoint reading
>Fri, 25 Nov 2022 20:02:39 +0100

>Author: Marko Oldenburg (oldenburg@b1-systems.de)

>Commiter: Marko Oldenburg (oldenburg@b1-systems.de)




### full api support weather and onecall
>Fri, 25 Nov 2022 14:09:45 +0100

>Author: Marko Oldenburg (oldenburg@b1-systems.de)

>Commiter: Marko Oldenburg (oldenburg@b1-systems.de)




### change OpenWeatherMapAPI Code and extend 59_Weather.pm Modul
>Thu, 24 Nov 2022 19:22:40 +0100

>Author: Marko Oldenburg (oldenburg@b1-systems.de)

>Commiter: Marko Oldenburg (oldenburg@b1-systems.de)




### new OpenWeatherMapAPI onecall v3 Support
>Sun, 20 Nov 2022 21:10:22 +0100

>Author: Marko Oldenburg (oldenburg@b1-systems.de)

>Commiter: Marko Oldenburg (oldenburg@b1-systems.de)




### new API Call and Data
>Thu, 17 Nov 2022 19:58:56 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### add Onecall to Endpoint
>Sat, 12 Feb 2022 12:56:04 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

for daily output

[Ticket: no]



### new version
>Wed, 9 Jun 2021 20:37:02 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### add wind_gust
>Wed, 9 Jun 2021 20:30:35 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change Maintainer name from pseudo name to real name
>Sat, 30 Jan 2021 18:41:41 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### insert forcast attributs to english commandref
>Sat, 17 Oct 2020 14:40:20 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### code style
>Sat, 25 Apr 2020 08:51:34 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix no visibility is available
>Sat, 25 Apr 2020 08:49:56 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix Use of uninitialized value in sprintf
>Wed, 22 Apr 2020 09:18:12 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add wunderground documentation in commandref
>Tue, 4 Feb 2020 14:09:47 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### delete table options in commandref
>Fri, 6 Dec 2019 13:12:35 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### check newLocation insert
>Mon, 16 Sep 2019 08:16:55 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add wundergroundAPI for setter newLocation
>Fri, 13 Sep 2019 11:03:44 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add commandref entry for set command newLocation
>Wed, 11 Sep 2019 09:00:13 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add support fpr Meta.pm and little Code changes
>Wed, 11 Sep 2019 08:42:42 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add Meta.pm Support
>Wed, 11 Sep 2019 08:20:28 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add support for set weather newLocation, temorary location change
>Wed, 11 Sep 2019 08:19:31 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change version numbers
>Wed, 11 Sep 2019 08:02:08 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change code in SetFn, change delimiter for set cmd newLocation
>Tue, 10 Sep 2019 10:50:30 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add setter locationTemp to change location temporary
>Mon, 9 Sep 2019 17:35:59 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add setter locationTemp to change location temporary
>Mon, 9 Sep 2019 17:35:35 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### Bugfix forum #971394
>Mon, 2 Sep 2019 13:43:53 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### Remove SVN data
>Sun, 14 Jul 2019 13:48:03 +0200

>Author: Julian Pawlowski (jpawlowski@users.noreply.github.com)

>Commiter: GitHub (noreply@github.com)




### fix default value for units
>Sun, 14 Jul 2019 13:47:28 +0200

>Author: Julian Pawlowski (jpawlowski@users.noreply.github.com)

>Commiter: GitHub (noreply@github.com)




### change loglevel
>Sat, 15 Jun 2019 09:45:03 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### try to use JSON::MaybeXS wrapper for chance of better performance + open code
>Sat, 15 Jun 2019 09:42:07 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add more logout, code stype, add LICENSE
>Sat, 15 Jun 2019 09:36:11 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix README.md
>Fri, 7 Jun 2019 21:27:41 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### Update to version v1.0.0
>Fri, 7 Jun 2019 21:04:21 +0200

>Author: Julian Pawlowski (jpawlowski@users.noreply.github.com)

>Commiter: GitHub (noreply@github.com)

night/day forecasts for 5 days now implemented using hourly readings hfcX_ (misleading but no other option ...)


### little gugfix
>Tue, 4 Jun 2019 22:12:19 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add more Information to README.md
>Tue, 4 Jun 2019 21:34:33 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add more Information to README.md
>Tue, 4 Jun 2019 21:32:38 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add README.md file
>Tue, 4 Jun 2019 21:29:03 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### Create wundergroundAPI.pm
>Tue, 4 Jun 2019 17:23:16 +0200

>Author: Julian Pawlowski (jpawlowski@users.noreply.github.com)

>Commiter: GitHub (noreply@github.com)




### fix little bug in weblink creator
>Tue, 14 May 2019 13:49:34 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add sub for apioptions, add darksky api extend option
>Tue, 19 Mar 2019 21:35:59 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change version
>Mon, 18 Mar 2019 13:40:08 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change translation for nl
>Mon, 18 Mar 2019 13:26:00 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### rewrite options sub for weblink
>Mon, 18 Mar 2019 13:17:55 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix bugs in weblink and expand hourly forcast
>Mon, 18 Mar 2019 10:31:41 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change package deklaration
>Fri, 15 Mar 2019 21:41:32 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix umlaute problem
>Thu, 14 Mar 2019 18:40:42 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### suchen und ersetzen der Sonderzeichen
>Thu, 14 Mar 2019 14:34:59 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add contributors
>Thu, 14 Mar 2019 08:43:14 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### Update 59_Weather.pm
>Wed, 13 Mar 2019 07:00:45 +0100

>Author: Lippie81 (46738685+Lippie81@users.noreply.github.com)

>Commiter: GitHub (noreply@github.com)

Bugfix zum letzten merge meines patches:
in sub WeatherAsHtmlH($;$$)  fehlte:
    $f =~ tr/dh/./cd;
    $f = "h" if ( !$f || length($f) > 1);
    $items =~ tr/0-9/./cd;
    $items = 6   if ( !$items );


### Update 59_Weather.pm
>Tue, 12 Mar 2019 21:07:58 +0100

>Author: Lippie81 (46738685+Lippie81@users.noreply.github.com)

>Commiter: GitHub (noreply@github.com)

Paramater 2 und 3 werden automatisch dem zugehörigen internen Parameter Anzahl oder daily/hourly zugeordnet.
Damit ist die Reihenfolge beim Aufruf frei wählbar und beide Parameter können beim Aufruf beliebig weggelassen werden.


### Update 59_Weather.pm
>Tue, 12 Mar 2019 06:46:11 +0100

>Author: Lippie81 (46738685+Lippie81@users.noreply.github.com)

>Commiter: GitHub (noreply@github.com)

Bugfix: 
761: ReadingsVal( $d, "${fc}${i}_day_of_week", "" ),<br>%s =>Das <br>%s  gehört da nicht hin.
In Zeile 763 und 773 fehlt ein Komma als Zeilenabschluss.


### Update 59_Weather.pm
>Thu, 7 Mar 2019 22:34:49 +0100

>Author: Lippie81 (46738685+Lippie81@users.noreply.github.com)

>Commiter: GitHub (noreply@github.com)

Aktualisierung des Änderungsvorschlags wie besprochen:
- WeatherAsHtml() haben jetzt alle die gleiche Schnittstelle  ($d, $f , $items)und sind damit abwärtskompatibel entsprechend Doku (ebenfalls angepasst)
Zur Absicherung der optionalen Parameter in WeatherAsHtml(): Filter auf die erlaubten Zeichen und setzen eines defaultwertes, falls der Parameter leer ist. Eine Abfrage auf defined() ist nicht notwendig, habe alle möglichen Eingabekombinationen abgeprüft.
In WeatherAsHtmlH($;$$) wird, wie vereinbart, _low_c und _high_c nur angezeigt, wenn die Readings vorhanden sind, ansonsten wird _temperature verwendet.
Gleiches habe ich in WeatherAsHtmlV($;$$) angepasst.
Die Änderungen laufen bei mir mit DarkSkyAPI und OpenWeatherMapAPI einwandfrei. Aussehen habe ich ebenfalls gecheckt.

Beste Grüße
Lippie


### little change
>Tue, 5 Mar 2019 21:01:23 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### Update WeatherAsHtml
>Tue, 5 Mar 2019 20:24:24 +0100

>Author: Lippie81 (46738685+Lippie81@users.noreply.github.com)

>Commiter: GitHub (noreply@github.com)

- alle WeatherAsHtml-functionen auf $d, $items, $i gleichgestellt
- Abfrage in WeatherAsHtmlH, ob *fc(i)_low_c vorhanden, wenn nicht Verwendung von *fc(i)_temperature
- Erweiterung der Beispiels um Anzahl und daily/hourly-Angabe


### Fixed an minor typo
>Tue, 5 Mar 2019 18:02:06 +0100

>Author: Christoph Morrison (post@christoph-jeschke.de)

>Commiter: Christoph Morrison (post@christoph-jeschke.de)




### Added markdown version of the german API description
>Tue, 5 Mar 2019 18:01:13 +0100

>Author: Christoph Morrison (post@christoph-jeschke.de)

>Commiter: Christoph Morrison (post@christoph-jeschke.de)




### add code to use demo data up to start
>Mon, 4 Mar 2019 21:34:17 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### little code changing
>Wed, 27 Feb 2019 08:23:28 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change version
>Wed, 27 Feb 2019 07:55:46 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add DEMO Support
>Wed, 27 Feb 2019 07:53:29 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix bug then month are umlauts
>Tue, 26 Feb 2019 12:54:09 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### typo fix in commandref
>Wed, 23 Jan 2019 07:37:52 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change commandref
>Mon, 21 Jan 2019 11:53:50 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add configuration forecast data
>Mon, 21 Jan 2019 11:41:33 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add forecastLimit and forecast Attribut
>Mon, 21 Jan 2019 08:49:38 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add internal MODEL for statistic
>Fri, 18 Jan 2019 21:07:48 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### remove attribut mode
>Fri, 18 Jan 2019 20:21:51 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix change attribut model
>Fri, 18 Jan 2019 19:08:07 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add note for day_of_week tranlation
>Fri, 18 Jan 2019 14:07:50 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add apiVersion to API Documentation
>Fri, 18 Jan 2019 10:29:28 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix readingupdate
>Thu, 17 Jan 2019 22:22:44 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### code style, add attribut model
>Thu, 17 Jan 2019 11:49:06 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix uninitialized value in localtime at FHEM/DarkSkyAPI.pm line 430
>Wed, 16 Jan 2019 23:05:41 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add snow and rain for the last 1 and/or 3 hour
>Tue, 15 Jan 2019 14:51:50 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### neue Datei
>Tue, 15 Jan 2019 13:49:27 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add 59_Weather API-Modul Documentation, fix setreading line
>Tue, 15 Jan 2019 13:45:31 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix bugs, change day_of_week formated
>Mon, 14 Jan 2019 18:16:39 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add factor 3.6 to windGust
>Mon, 14 Jan 2019 10:50:35 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change wind speed to factor 3.6 for hourly
>Mon, 14 Jan 2019 05:53:43 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change formated output, add hourly support for DarkSky - thanks to Lippie, multiple factor to wind speed and many bugfix
>Sun, 13 Jan 2019 21:13:54 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix table commandref
>Sun, 13 Jan 2019 10:30:37 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix table bug
>Sun, 13 Jan 2019 10:22:39 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix more typo in commandref
>Sun, 13 Jan 2019 09:37:01 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### expand error handling, fix typo in commandref
>Sun, 13 Jan 2019 09:22:28 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix negative tagcount for table
>Sat, 12 Jan 2019 16:35:03 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### style code
>Sat, 12 Jan 2019 16:20:31 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### added $Id tag for subversion
>Sat, 12 Jan 2019 15:02:53 +0100

>Author: Dr. Boris Neubert (omega@online.de)

>Commiter: Dr. Boris Neubert (omega@online.de)




### removed dead or deprecated code, updated commandref
>Sat, 12 Jan 2019 15:00:52 +0100

>Author: Dr. Boris Neubert (omega@online.de)

>Commiter: Dr. Boris Neubert (omega@online.de)




### change and expand the commandref for 59_Weather
>Sat, 12 Jan 2019 11:54:39 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix weblink bug by hourly forcast
>Sat, 12 Jan 2019 08:18:52 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change day_of_week processing
>Sat, 12 Jan 2019 07:34:54 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change day_of_week language handling
>Fri, 11 Jan 2019 08:47:13 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix error in empty Hash check
>Thu, 10 Jan 2019 22:35:57 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change license reading
>Thu, 10 Jan 2019 14:58:51 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### forcast Datastructure change to HashRef daily and hourly
>Thu, 10 Jan 2019 14:08:31 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change hashRef for parameter from cachemaxage to apioptions
>Thu, 10 Jan 2019 10:55:03 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### publish forecast data in OpenWeatherMap, code change in 59_Weather, change response data structure for Weather Modul
>Thu, 10 Jan 2019 09:30:26 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add daily and hourly support code for WOM, fix bug Readingvalue HASH
>Thu, 10 Jan 2019 00:11:19 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add yahoo icon mapping
>Wed, 9 Jan 2019 13:42:27 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change dumper output
>Wed, 9 Jan 2019 13:14:06 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change data handle for callBackFn - wichtig alle Module Updaten
>Wed, 9 Jan 2019 12:55:21 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix write Hash then ref current not present
>Wed, 9 Jan 2019 12:17:10 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### first commit
>Wed, 9 Jan 2019 10:37:55 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




