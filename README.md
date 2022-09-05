# LogTen Pro X to ForeFlight Logbook Converter

This tool reads a LogTen Pro X logbook, stored on your computer by the LogTen
Pro X application for Mac OS X, and outputs a CSV file suitable for import into
ForeFlight Logbook at https://plan.foreflight.com/logbook#/import

To use this script, you must have LogTen Pro X for macOS, or you must be
able to acquire a copy of your LogTenCoreDataStore.sql file from your iOS
device.

Important note to would-be contributors: This code is probably the worst
throwaway code I've ever written. Comments are sparse; obscurity abounds.

## Installation

This script requires Swift 5.7 and Swift Package Manager. After checking out the
project, run `swift build` to install dependencies and create the executable.

## Usage

Run `logten-to-foreflight --help` for usage instructions:

```
USAGE: logten-to-foreflight [--logten-file <logten-file>] <foreflight-file> [--verbose]

ARGUMENTS:
  <foreflight-file>       The ForeFlight logbook.csv file to create.

OPTIONS:
  --logten-file <logten-file>
                          The LogTenCoreDataStore.sql file containing the logbook entries.
  --verbose               Include extra information in the output.
  -h, --help              Show help information.
```

After generating the ForeFlight CSV file, import it to ForeFlight Logbook.

## Limitations and Idiosyncrasies

This script has been tailored to my specific logbook. It will likely require at
least a little modification before it works with your logbook, but it should
take you 95% of the way there. In particular:

### Flights

- LogTen Pro X does not have a "night full-stop landings" field by default. My
  "custom landings 1" field has been purposed to this effect. If you are using
  a different field, you will need to modify this code. If you are not
  recording night full-stop landings, then how are you tracking night currency??
- LogTen Pro X does not have support for a "checkride" Boolean field. I set
  this to true if "flight review" is checked and the remarks include the word
  "checkride".
- ForeFlight does not support old-style GPS approaches, only RNAV (GPS). Any
  LogTen approaches that are GPS will be converted into RNAV (GPS), even though
  this technically isn't correct.
- LogTen supports NVG proficiency and operations logging, which is not supported
  by this script.
- For FAR 61.58 proficiency flights, it is assumed that the Custom Note 1 field
  contains any value (e.g., "Y").

### Aircraft and aircraft types

- LogTen Pro X stores aircraft categories and classes as numeric identifiers. I
  only fly ASEL, ASES, AMEL, AMES, and glider aircraft so I don't know the
  numeric identifiers for any other categories/classes. If you need to know
  these identifiers, you will have to do some spelunking.
- LogTen Pro X stores engine types as numeric identifiers. I only fly piston
  and jet aircraft, so if you need numeric identifiers for other engine types
  (turboprop, turboshaft), you will have to figure them out yourself.
- LogTen Pro X only has a "jet" engine type, and does not distinguish between
  turbofan and turbojet engines, unlike ForeFlight. Aircraft with jet engines
  are assumed to be turbofans.
- The "aircraft type" field in my logbook does not conform to FAA aircraft
  types. For example, I have "C-172SP" as a type instead of "C172". There is a
  method that converts these types from my own format to FAA standard type
  identifiers. You may need to modify this method or not call it.
- The aircraft type custom fields should be set up as shown below, in order:
  1. simulator type ("BATD", "AATD", "FTD", or "FFS"; blank for aircraft)
  2. simulated aircraft ICAO type code (e.g., "SF50"; blank for aircraft, BATDs,
     and AATDs)
  3. simulated aircraft category and class (abbreviated, e.g., "ASEL"; blank for
     aircraft)
- LogTen Pro X does not record whether an aircraft has diesel engines. The only
  diesel I fly is a DA42, so I just set the engine type to Diesel for that type
  only.
- ForeFlight appears to require an simulated aircraft ICAO type code even for
  BATDs and AATDs (which is counterintuitive). I leave this blank in my logbook
  but it does produce an error.

### Crew and passengers

- LogTen Pro X does not have a "safety pilot" crew role. I "guess" the safety
  pilot by checking if the user is PIC (i.e., the PIC record has "Is Me"
  checked) and the words "safety pilot" appear in the remarks. If so, I change
  the role of the SIC to Safety Pilot.
- LogTen Pro X does not have a "safety pilot" or "examiner" role. I use Custom
  Role 1 and 2 for these, respectively.
- The script allows a crew member to have only one role. For example, if a crew
  member is both SIC and Safety Pilot, they will be listed as Safety Pilot only.
  If a crew member is both PIC and Student, they will be listed as Student only.
- LogTen Pro X has a bounty of different crew roles (relief, purser, flight
  attendant, observer, engineer, commander, etc. etc.) that I don't use as a
  general aviation pilot. To save time, I do not import these crew members. If
  you do wish to import these crew members, you will need to modify the code.
