# ws-raidcore-translator

## Overview
This small script handles the -automatic- translation of the Wildstar [RaidCore add-on](https://github.com/NielsH/RaidCore).

## Installation
`$ docker pull olbat/ws-raidcore-translator`

## Getting Started
1. Download and extract [the archive](https://github.com/NielsH/RaidCore/archive/master.zip) of the Raidcore add-on source code
2. Run the raidcore-translator script in a docker container (by default it convert the files in the Modules directory):
```
$ docker run -v /path/to/Raidcore:/src/ olbat/ws-raidcore-translator raidcore-translator [options...]
```

## Use cases
### Translate the Raidcore module in French
```
$ docker run -v /path/to/Raidcore:/src/ olbat/ws-raidcore-translator \
    raidcore-translator convert -l fr -v /src/Modules
```

### Generate a JSON dump of German translations
```
$ docker run -v /path/to/Raidcore:/src/ olbat/ws-raidcore-translator \
    raidcore-translator dump -l de -o /src/dump-de.json /src/Modules
$ cat /path/to/Raidcore/dump-de.json
```

### Translate the Raidcore module using a translation file
_Note_: the translation file contains translations that for items that cant be downloaded by the script
```
$ cat /path/to/Raidcore/example-fr.json
{
        "Halls of the Infinite Mind" : "Salles de l'Esprit infini",
        "Infinite Generator Core" : "Noyau du générateur d'infinité",
        "INVALID SIGNAL. DISCONNECTING" : "SIGNAL INCORRECT.",
        "COMMENCING ENHANCEMENT SEQUENCE" : "DÉBUT DE LA SEQUENCE D'AMÉLIORATION"
}

$ docker run -v /path/to/Raidcore:/src/ olbat/ws-raidcore-translator \
    raidcore-translator convert -l fr -t /src/example-fr.json -v /src/Modules
```

## Usage
```
usage: raidcore-translator <convert|dump> [opts] <file1> <file2> ... <fileN>
    -h, --help                       Display this screen
    -c, --[no-]comment               Add comments to specify the original names
    -l, --lang NAME                  The output language (default: fr)
    -n, --noop                       Do not do not write translations in their files
    -N, --no-network                 Do not download any translations from the network
    -o, --output FILE                Dump data in a file
    -t, --translation-file FILE      Load translations from a file (download>file)
    -d, --debug                      Debug mode
    -v, --verbose                    Verbose mode
```

## How does it work

This script parses the source code of the [RaidCore add-on](https://github.com/NielsH/RaidCore) to find what spell/zone/NPC names and messages are used.

Then it uses the [wildstar.datminer.com](http://wildstar.datminer.com/) website to translate the names in French or German.

Translations can then exploited two different ways:
* __convert__: re-write the source code of the add-on to use the translated names
* __dump__: generate a JSON file containing every translations (a Hash, key: english name, value: translated name)

_Note_: The JSON dump can (will?) be used to generate localization/translation files for the addon.

Since some translations cannot be downloaded from the web (boss messages, ...), it's possible to specify a translation file (JSON Hash, key: english name, value: translated name) to specify missing translations.

## Run examples
### Dump
```
$ docker run -v /path/to/Raidcore:/src/ olbat/ws-raidcore-translator \
    raidcore-translator dump -o /src/dump.json /src/Modules/SystemDeamons.lua
[WARN] (/src/Modules/SystemDeamons.lua:12) No reference for 'Lower Infinite Generator Core' (see http://wildstar.datminer.com/search/Lower%20Infinite%20Generator%20Core)
[WARN] (/src/Modules/SystemDeamons.lua:12) No reference for 'Halls of the Infinite Mind' (see http://wildstar.datminer.com/search/Halls%20of%20the%20Infinite%20Mind)
[WARN] (/src/Modules/SystemDeamons.lua:12) No reference for 'Infinite Generator Core' (see http://wildstar.datminer.com/search/Infinite%20Generator%20Core)
[WARN] (/src/Modules/SystemDeamons.lua:13) No reference for 'Lower Infinite Generator Core' (see http://wildstar.datminer.com/search/Lower%20Infinite%20Generator%20Core)
[WARN] (/src/Modules/SystemDeamons.lua:13) No reference for 'Halls of the Infinite Mind' (see http://wildstar.datminer.com/search/Halls%20of%20the%20Infinite%20Mind)
[WARN] (/src/Modules/SystemDeamons.lua:13) No reference for 'Infinite Generator Core' (see http://wildstar.datminer.com/search/Infinite%20Generator%20Core)
[WARN] (/src/Modules/SystemDeamons.lua:106) No reference for 'Infinite Generator Core' (see http://wildstar.datminer.com/search/Infinite%20Generator%20Core)
[WARN] (/src/Modules/SystemDeamons.lua:110) No reference for 'Infinite Generator Core' (see http://wildstar.datminer.com/search/Infinite%20Generator%20Core)
[WARN] (/src/Modules/SystemDeamons.lua:114) No reference for 'Infinite Generator Core' (see http://wildstar.datminer.com/search/Infinite%20Generator%20Core)
[WARN] (/src/Modules/SystemDeamons.lua:230) No reference for 'Halls of the Infinite Mind' (see http://wildstar.datminer.com/search/Halls%20of%20the%20Infinite%20Mind)
[WARN] (/src/Modules/SystemDeamons.lua:240) No reference for 'Infinite Generator Core' (see http://wildstar.datminer.com/search/Infinite%20Generator%20Core)
[WARN] (/src/Modules/SystemDeamons.lua:267) No reference for 'INVALID SIGNAL. DISCONNECTING' (see http://wildstar.datminer.com/search/INVALID%20SIGNAL.%20DISCONNECTING)
[WARN] (/src/Modules/SystemDeamons.lua:277) No reference for 'COMMENCING ENHANCEMENT SEQUENCE' (see http://wildstar.datminer.com/search/COMMENCING%20ENHANCEMENT%20SEQUENCE)
[WARN] (/src/Modules/SystemDeamons.lua:362) No reference for 'Infinite Generator Core' (see http://wildstar.datminer.com/search/Infinite%20Generator%20Core)

$ cat /path/to/Raidcore/dump.json
{
  "Binary System Daemon": "Daemon 2.0",
  "Null System Daemon": "Daemon 1.0",
  "Lower Infinite Generator Core": null,
  "Halls of the Infinite Mind": null,
  "Infinite Generator Core": null,
  "Conduction Unit Mk. I": "Unité de conductivité v1",
  "Conduction Unit Mk. II": "Unité de conductivité v2",
  "Conduction Unit Mark III": "Unité de conductivité v3",
  "Enhancement Module": "Module d'amélioration",
  "Recovery Protocol": "Protocole de récupération",
  "Repair Sequence": "Séquence de réparation",
  "Power Surge": "Afflux d'énergie",
  "Purge": "Purge",
  "Defragmentation Unit": "Unité de défragmentation",
  "Black IC": "CI noir",
  "Overload": "Surcharge",
  "Datascape": "Infosphère",
  "INVALID SIGNAL. DISCONNECTING": null,
  "COMMENCING ENHANCEMENT SEQUENCE": null
}
```

### Verbose convert
```
$ docker run -v /path/to/Raidcore:/src/ olbat/ws-raidcore-translator \
    raidcore-translator convert -v /src/Modules/SystemDeamons.lua
[INFO] Convert /src/Modules/SystemDeamons.lua
[INFO]   Translate "Binary System Daemon" (l.11)
[INFO]   Translate "Null System Daemon" (l.11)
[INFO]   Translate "Lower Infinite Generator Core" (l.12)
[WARN] (/src/Modules/SystemDeamons.lua:12) No reference for 'Lower Infinite Generator Core' (see http://wildstar.datminer.com/search/Lower%20Infinite%20Generator%20Core)
[INFO]   Translate "Halls of the Infinite Mind" (l.12)
[WARN] (/src/Modules/SystemDeamons.lua:12) No reference for 'Halls of the Infinite Mind' (see http://wildstar.datminer.com/search/Halls%20of%20the%20Infinite%20Mind)
[INFO]   Translate "Infinite Generator Core" (l.12)
[WARN] (/src/Modules/SystemDeamons.lua:12) No reference for 'Infinite Generator Core' (see http://wildstar.datminer.com/search/Infinite%20Generator%20Core)
[INFO]   Translate "Lower Infinite Generator Core" (l.13)
[WARN] (/src/Modules/SystemDeamons.lua:13) No reference for 'Lower Infinite Generator Core' (see http://wildstar.datminer.com/search/Lower%20Infinite%20Generator%20Core)
[INFO]   Translate "Halls of the Infinite Mind" (l.13)
[WARN] (/src/Modules/SystemDeamons.lua:13) No reference for 'Halls of the Infinite Mind' (see http://wildstar.datminer.com/search/Halls%20of%20the%20Infinite%20Mind)
[INFO]   Translate "Infinite Generator Core" (l.13)
[WARN] (/src/Modules/SystemDeamons.lua:13) No reference for 'Infinite Generator Core' (see http://wildstar.datminer.com/search/Infinite%20Generator%20Core)
[INFO]   Translate "Binary System Daemon" (l.95)
[INFO]   Translate "Null System Daemon" (l.95)
[INFO]   Translate "Conduction Unit Mk. I" (l.104)
[INFO]   Translate "Infinite Generator Core" (l.106)
[WARN] (/src/Modules/SystemDeamons.lua:106) No reference for 'Infinite Generator Core' (see http://wildstar.datminer.com/search/Infinite%20Generator%20Core)
[INFO]   Translate "Conduction Unit Mk. II" (l.108)
[INFO]   Translate "Infinite Generator Core" (l.110)
[WARN] (/src/Modules/SystemDeamons.lua:110) No reference for 'Infinite Generator Core' (see http://wildstar.datminer.com/search/Infinite%20Generator%20Core)
[INFO]   Translate "Conduction Unit Mark III" (l.112)
[INFO]   Translate "Infinite Generator Core" (l.114)
[WARN] (/src/Modules/SystemDeamons.lua:114) No reference for 'Infinite Generator Core' (see http://wildstar.datminer.com/search/Infinite%20Generator%20Core)
[INFO]   Translate "Enhancement Module" (l.115)
[INFO]   Translate "Recovery Protocol" (l.121)
[INFO]   Translate "Enhancement Module" (l.128)
[INFO]   Translate "Recovery Protocol" (l.160)
[INFO]   Translate "Repair Sequence" (l.160)
[INFO]   Translate "Binary System Daemon" (l.167)
[INFO]   Translate "Power Surge" (l.167)
[INFO]   Translate "Null System Daemon" (l.172)
[INFO]   Translate "Power Surge" (l.172)
[INFO]   Translate "Purge" (l.177)
[INFO]   Translate "Defragmentation Unit" (l.185)
[INFO]   Translate "Black IC" (l.185)
[INFO]   Translate "Recovery Protocol" (l.188)
[INFO]   Translate "Repair Sequence" (l.188)
[INFO]   Translate "Overload" (l.206)
[INFO]   Translate "Purge" (l.208)
[INFO]   Translate "Overload" (l.220)
[INFO]   Translate "Purge" (l.222)
[INFO]   Translate "Datascape" (l.228)
[INFO]   Translate "Halls of the Infinite Mind" (l.230)
[WARN] (/src/Modules/SystemDeamons.lua:230) No reference for 'Halls of the Infinite Mind' (see http://wildstar.datminer.com/search/Halls%20of%20the%20Infinite%20Mind)
[INFO]   Translate "Infinite Generator Core" (l.240)
[WARN] (/src/Modules/SystemDeamons.lua:240) No reference for 'Infinite Generator Core' (see http://wildstar.datminer.com/search/Infinite%20Generator%20Core)
[INFO]   Translate "INVALID SIGNAL. DISCONNECTING" (l.267)
[WARN] (/src/Modules/SystemDeamons.lua:267) No reference for 'INVALID SIGNAL. DISCONNECTING' (see http://wildstar.datminer.com/search/INVALID%20SIGNAL.%20DISCONNECTING)
[INFO]   Translate "COMMENCING ENHANCEMENT SEQUENCE" (l.277)
[WARN] (/src/Modules/SystemDeamons.lua:277) No reference for 'COMMENCING ENHANCEMENT SEQUENCE' (see http://wildstar.datminer.com/search/COMMENCING%20ENHANCEMENT%20SEQUENCE)
[INFO]   Translate "Binary System Daemon" (l.343)
[INFO]   Translate "Null System Daemon" (l.343)
[INFO]   Translate "Defragmentation Unit" (l.361)
[INFO]   Translate "Infinite Generator Core" (l.362)
[WARN] (/src/Modules/SystemDeamons.lua:362) No reference for 'Infinite Generator Core' (see http://wildstar.datminer.com/search/Infinite%20Generator%20Core)
```
