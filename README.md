# LogTen Pro to ForeFlight Logbook Converter

This tool reads a LogTen Pro logbook, stored on your computer by the LogTen
Pro application for macOS, and outputs a CSV file suitable for import into
ForeFlight Logbook at https://plan.foreflight.com/logbook#/import

To use this script, you must have LogTen Pro for macOS.

## Installation

This script requires Swift 6 and Swift Package Manager. After checking out the
project, run `swift build` to install dependencies and create the executable.

## Usage

Run `logten-to-foreflight --help` for usage instructions:

```
USAGE: logten-to-foreflight [--logten-file <logten-file>] [--logten-managed-object-model <logten-managed-object-model>] <foreflight-file> [--verbose]

ARGUMENTS:
  <foreflight-file>       The ForeFlight logbook.csv file to create.

OPTIONS:
  --logten-file <logten-file>
                          The LogTenCoreDataStore.sql file containing the logbook entries.
  --logten-managed-object-model <logten-managed-object-model>
                          The location of the LogTen Pro managed object model file.
  --verbose               Include extra information in the output.
  -h, --help              Show help information.
```

After generating the ForeFlight CSV file, import it to ForeFlight Logbook.

## Limitations, Assumptions, and Idiosyncrasies

This script has been tailored to my specific logbook. It will likely require at
least a little modification before it works with your logbook, but it should
take you 95% of the way there. In particular:

### Flights

- LogTen Pro does not have a "night full-stop landings" field by default. You
  will need a "Custom Landings" field named "Night Full Stops". (If you are not
  recording night full-stop landings, then how are you tracking night currency?)
- LogTen Pro does not have a "checkride" Boolean field. You will need a
  "Custom Notes" field named "Checkride". Flights with any non-empty value in
  this field will be considered checkrides.
- ForeFlight does not support old-style GPS approaches, only RNAV (GPS). Any
  LogTen approaches that are GPS will be converted into RNAV (GPS), even though
  this technically isn't correct.
- LogTen supports NVG proficiency and operations logging, which is not supported
  by this script.
- LogTen Pro does not have a field for indicating FAR 61.58 recurrent flights.
  You will need a "Custom Notes" field named "FAR 61.58". Flights with any
  non-empty value in this field will be considered recurrent checkrides.

### Aircraft and aircraft types

- This script will not work if you have modified or rearranged your engine
  types, aircraft categories, or aircraft classes.
- LogTen Pro only has "jet" and "turbofan" engine types. The "jet" type is
  assumed to mean "turbojet".
- The "aircraft type" field in my logbook does not conform to FAA aircraft
  types. For example, I have "C-172SP" as a type instead of "C172". I use a
  custom Aircraft Type field called "Type Code". If you also have such a field,
  it will use the value from that field; otherwise, it will use the normal
  aircraft type.
- ForeFlight requires more simulator information than LogTen Pro is set up for
  by default. To provide this info, you will need to modify Aircraft Type to
  include:
  - a custom field called "Sim Type" whose values can be "BATD", "AATD", "FTD",
    or "FFS" (or blank for aircraft);
  - a custom field called "Type Code" whose value is the type code for the
    aircraft being simulated (FFS and FTD only); and
  - a custom field called "Sim A/C Cat" whose value is the category and class
    for the aircraft being simulated (FTD and FFS only, values can be "ASEL",
    "ASES", "AMEL", "AMES", or "GL" for glider).
- LogTen Pro does not record whether an aircraft has diesel engines. You must
  have a custom checkbox field on Aircraft called "Diesel Engine".
- ForeFlight supports land and sea variants for Powered Parachute and
  Weight-Shift-Control aircraft, whereas LogTen Pro does not. These aircraft are
  assumed to be land variants.

### Crew and passengers

- LogTen Pro does not have a "safety pilot" or "examiner" role. You must have
  "Custom Role" fields titled "Safety Pilot" and "Examiner".
- The script allows a crew member to have only one role. For example, if a crew
  member is both SIC and Safety Pilot, they will be listed as Safety Pilot only.
  If a crew member is both PIC and Student, they will be listed as Student only.
- The LogTen "Purser" role is exported to ForeFlight as a flight attendant.
- LogTen Pro does not have roles for "First Officer" and "Second Officer", which
  are supported by ForeFlight. These roles are not supported by this script.
- LogTen Pro has a bounty of roles not supported by ForeFlight (commander,
  observer, relief crew). These roles are ignored by this script.
