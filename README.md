# ws-raidcore-translator


## Overview
This small script handles the -automatic- translation of the Wildstar [RaidCore add-on](https://github.com/NielsH/RaidCore).


## Installation
### with Docker
1. [Install Docker](https://docs.docker.com/installation/#installation)
2. Pull the image containing the script and it's runtime environment: `docker pull olbat/ws-raidcore-translator`
3. Run the script: `docker run ... olbat/ws-raidcore-translator raidcore-translator ...`

### without Docker
1. [Install Ruby runtime environment](https://www.ruby-lang.org/en/documentation/installation/)
2. [Install the Nokogiri library](http://www.nokogiri.org/tutorials/installing_nokogiri.html)
3. Run the script: `raidcore-translator ...`

## Getting Started
1. Download and extract [the archive](https://github.com/NielsH/RaidCore/archive/master.zip) of the Raidcore add-on source code
2. Run the raidcore-translator script in a docker container (by default it convert the files in the Modules directory):
```
$ docker run -v /path/to/Raidcore:/src/ olbat/ws-raidcore-translator \
    raidcore-translator [options...]
```


## Use cases
### Rewrite the Raidcore module in French
```
$ docker run -v /path/to/Raidcore:/src/ olbat/ws-raidcore-translator \
    raidcore-translator convert -l fr -v /src/Modules
```

### Translate the Raidcore module in French
```
$ docker run -v /path/to/Raidcore:/src/ olbat/ws-raidcore-translator \
    raidcore-translator i18n_v1 -l fr -v /src/Modules
```

### Generate a JSON dump of German translations
```
$ docker run -v /path/to/Raidcore:/src/ olbat/ws-raidcore-translator \
    raidcore-translator dump -n -l de -o /src/dump-de.json /src/Modules
$ cat /path/to/Raidcore/dump-de.json
```

### Translate the Raidcore module using a translation file
The translation file contains translations that for items that cant be downloaded by the script

_Note_: two -incomplete- translation files are available in the repository: `french.json` and `german.json`

```
$ cat /path/to/Raidcore/example-fr.json
{
        "Halls of the Infinite Mind" : "Salles de l'Esprit infini",
        "Infinite Generator Core" : "Noyau du générateur d'infinité",
        "INVALID SIGNAL. DISCONNECTING" : "SIGNAL INCORRECT.",
        "COMMENCING ENHANCEMENT SEQUENCE" : "DÉBUT DE LA SEQUENCE D'AMÉLIORATION"
}

$ docker run -v /path/to/Raidcore:/src/ olbat/ws-raidcore-translator \
    raidcore-translator i18n_v2 -l fr -t /src/example-fr.json -v /src/Modules
```

### Read existing translation and dump them (1)
```
$ docker run -v /path/to/Raidcore:/src/ olbat/ws-raidcore-translator \
    raidcore-translator i18n_v1 -l de -r -o /src/dump-de.json -v /src/Modules
```

### Read existing translations and translate (2)
```
$ docker run -v /path/to/Raidcore:/src/ olbat/ws-raidcore-translator \
    raidcore-translator i18n_v2 -l fr -rdnN -o /src/fr.json /src/Modules
$ docker run -v /path/to/Raidcore:/src/ olbat/ws-raidcore-translator \
    raidcore-translator i18n_v2 -l fr -t /src/fr.json /src/Modules
```

### Read existing translations (1) and translate (2)
```
$ git submodule init
$ git submodule update

$ cd Raidcore
$ git fetch origin translation2
$ git checkout FETCH_HEAD
$ cd ..

$ docker run -v $(pwd):/src/ olbat/ws-raidcore-translator \
    raidcore-translator i18n_v1 -l de -rdnN -o /src/de.json /src/Raidcore/Modules

$ cd Raidcore
$ git fetch origin review/translation
$ git checkout FETCH_HEAD
$ cd ..

$ docker run -v $(pwd):/src/ olbat/ws-raidcore-translator \
    raidcore-translator i18n_v2 -l de -t /src/de.json /src/Raidcore/Modules
```

### Generate rewrite dumps for every Raidcore modules
```
$ git submodule init
$ git submodule update
$ docker run -it -w /src -v $(pwd):/src olbat/ws-raidcore-translator \
    ./generate-dumps.sh convert Raidcore/Modules dumps
$ ls dumps/
All-de.json            EpEarthLogic-fr.log     Kuralak-fr.json
All-de.log             EpFrostAir-de.json      Kuralak-fr.log
All-fr.json            EpFrostAir-de.log       MaelstromAuthority-de.json
All-fr.log             EpFrostAir-fr.json      MaelstromAuthority-de.log
Avatus-de.json         EpFrostAir-fr.log       MaelstromAuthority-fr.json
Avatus-de.log          EpFrostFire-de.json     MaelstromAuthority-fr.log
...
```

### Generate translation dumps for every Raidcore module (1)
```
$ git submodule init
$ git submodule update
$ cd Raidcore
$ git fetch origin translation2
$ git checkout FETCH_HEAD
$ docker run -it -w /src -v $(pwd):/src olbat/ws-raidcore-translator \
    ./generate-dumps.sh i18n_v1 Raidcore/Modules dumps
$ ls dumps/
All-de.json            EpEarthLogic-fr.log     Kuralak-fr.json
All-de.log             EpFrostAir-de.json      Kuralak-fr.log
All-fr.json            EpFrostAir-de.log       MaelstromAuthority-de.json
...
```

### Generate translation dumps for every Raidcore module (2)
```
$ git submodule init
$ git submodule update
$ cd Raidcore
$ git fetch origin review/translation
$ git checkout FETCH_HEAD
$ docker run -it -w /src -v $(pwd):/src olbat/ws-raidcore-translator \
    ./generate-dumps.sh i18n_v2 Raidcore/Modules dumps
$ ls dumps/
All-de.json            EpEarthLogic-fr.log     Kuralak-fr.json
All-de.log             EpFrostAir-de.json      Kuralak-fr.log
All-fr.json            EpFrostAir-de.log       MaelstromAuthority-de.json
...
```

## Usage
```
usage: raidcore-translator <convert|i18n_v1|i18n_v2> [opts] <file1> <file2> ... <fileN>
    -h, --help                       Display this screen
    -c, --[no-]comment               Add comments to specify the original names
    -d, --dump                       Generate a JSON dump of translations
    -l, --lang NAME                  The output language (default: fr)
    -n, --noop                       Do not do not write translations in their files
    -N, --no-network                 Do not download any translations from the network
    -O, --[no-]overwrite-existing    Overwrite existing translations
    -r, --[no-]read-existing         Read existing translations
    -o, --output FILE                Dump data in a file
    -t, --translation-file FILE      Load translations from a file
    -D, --debug                      Debug mode
    -v, --verbose                    Verbose mode
```


## How does it work

This script parses the source code of the [RaidCore add-on](https://github.com/NielsH/RaidCore) to find what spell/zone/NPC names and messages are used.

Then it uses the [wildstar.datminer.com](http://wildstar.datminer.com/) website to translate the names in French or German.

Translations can then exploited two different ways:
* __convert__: re-write the source code of the add-on to use the translated names
* __i18n_v1__: translate the source code of the _translation2_ branch of the add-on using internationalization variables (see https://github.com/NielsH/RaidCore/tree/translation2)
* __i18n_v2__: translate the source code of the _review/translation_ branch of the add-on using internationalization variables (see https://github.com/NielsH/RaidCore/tree/review/translation)


Since some translations cannot be downloaded from the web (boss messages, ...), it's possible to specify a translation file (JSON Hash, key: english name, value: translated name) to specify missing translations.


## Dumps

Several dumps are available in the `dumps/` directory (_.json_ files).

The `dumps/All-fr.json` and `dumps/All-de.json` files are containing French and German translations for every modules of the add-on.


## Translation files

The translation files contains translations that for items that cant be downloaded by the script. Basically: messages sent from the bosses, zone names, ... .

This files can be used in the script by specifying the `-t` option.

Two -incomplete- translation files are availables in the repository: `french.json` and `german.json`, feel free to complete them !


## Run examples
### Generate rewrite dumps for a specific file
```
$ docker run -v /path/to/Raidcore:/src/ olbat/ws-raidcore-translator \
    raidcore-translator convert -n -o /src/dump.json /src/Modules/SystemDeamons.lua
[WARN] (/src/Modules/SystemDeamons.lua:12) No reference for 'Lower Infinite Generator Core' (see http://wildstar.datminer.com/search/Lower%20Infinite%20Generator%20Core)
[WARN] (/src/Modules/SystemDeamons.lua:12) No reference for 'Halls of the Infinite Mind' (see http://wildstar.datminer.com/search/Halls%20of%20the%20Infinite%20Mind)
[WARN] (/src/Modules/SystemDeamons.lua:12) No reference for 'Infinite Generator Core' (see http://wildstar.datminer.com/search/Infinite%20Generator%20Core)
[WARN] (/src/Modules/SystemDeamons.lua:13) No reference for 'Lower Infinite Generator Core' (see http://wildstar.datminer.com/search/Lower%20Infinite%20Generator%20Core)
[WARN] (/src/Modules/SystemDeamons.lua:13) No reference for 'Halls of the Infinite Mind' (see http://wildstar.datminer.com/search/Halls%20of%20the%20Infinite%20Mind)
...

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

### Verbose rewrite
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
...
```

### More
Log files of the `generate-dumps.sh` runs are available in the `dumps/` directory (_.log_ files).
