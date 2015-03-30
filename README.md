# ws-raidcore-translator


## Overview
This small script handles the -automatic- translation of the Wildstar [RaidCore add-on](https://github.com/NielsH/RaidCore).


## Installation
`$ docker pull olbat/ws-raidcore-translator`


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
    raidcore-translator i18n -l fr -v /src/Modules
```

### Generate a JSON dump of German translations
```
$ docker run -v /path/to/Raidcore:/src/ olbat/ws-raidcore-translator \
    raidcore-translator dump -n -l de -o /src/dump-de.json /src/Modules
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
    raidcore-translator i18n -l fr -t /src/example-fr.json -v /src/Modules
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

### Generate translation dumps for every Raidcore modules
```
$ git submodule init
$ git submodule update
$ cd Raidcore
$ git fetch origin translation2
$ git checkout FETCH_HEAD
$ docker run -it -w /src -v $(pwd):/src olbat/ws-raidcore-translator \
    ./generate-dumps.sh i18n Raidcore/Modules dumps
$ ls dumps/
All-de.json            EpEarthLogic-fr.log     Kuralak-fr.json
All-de.log             EpFrostAir-de.json      Kuralak-fr.log
All-fr.json            EpFrostAir-de.log       MaelstromAuthority-de.json
...
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
* __i18n__: translate the source code of the add-on using internationalization variables (see https://github.com/NielsH/RaidCore/tree/translation2)


Since some translations cannot be downloaded from the web (boss messages, ...), it's possible to specify a translation file (JSON Hash, key: english name, value: translated name) to specify missing translations.


## Dumps

Several dumps are available in the `dumps/` directory (_.json_ files).

The `dumps/All-fr.json` and `dumps/All-de.json` files are containing French and German translations for every modules of the add-on.


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
