# Using the LogTen to ForeFlight Converter

Learn how to convert your LogTen Pro logbook to ForeFlight format.

@Metadata {
    @PageColor(blue)
}

## Overview

This command-line tool reads your LogTen Pro logbook and outputs a CSV file compatible with ForeFlight Logbook's import feature.

## Installation

Build the tool using Swift Package Manager:

```bash
git clone https://github.com/RISCfuture/logten2foreflight.git
cd logten2foreflight
swift build -c release
```

The executable will be located at `.build/release/logten-to-foreflight`.

## Command-Line Options

### Basic Syntax

```
logten-to-foreflight [options] <foreflight-file>
```

### Arguments

| Argument | Description |
|----------|-------------|
| `<foreflight-file>` | **Required.** The path where the ForeFlight CSV file will be created. |

### Options

| Option | Description |
|--------|-------------|
| `--logten-file <path>` | Path to the LogTenCoreDataStore.sql file. Defaults to the standard LogTen Pro location. |
| `--logten-managed-object-model <path>` | Path to the LogTen Pro managed object model (.momd). Defaults to the standard location in /Applications. |
| `--verbose` | Enable verbose output for debugging. |
| `-h, --help` | Show help information. |

### Default Paths

When not specified, the tool uses these default locations:

- **LogTen Data Store:** `~/Library/Group Containers/group.com.coradine.LogTenPro/LogTenProData_*/LogTenCoreDataStore.sql`
- **Managed Object Model:** `/Applications/LogTen.app/Contents/Resources/CNLogBookDocument.momd`

## Examples

### Basic Conversion

Convert your logbook using default LogTen Pro locations:

```bash
logten-to-foreflight ~/Desktop/foreflight-import.csv
```

### Custom LogTen Location

If your LogTen Pro data is in a non-standard location:

```bash
logten-to-foreflight \
    --logten-file /path/to/LogTenCoreDataStore.sql \
    --logten-managed-object-model /path/to/CNLogBookDocument.momd \
    ~/Desktop/foreflight-import.csv
```

### Debugging Issues

Use verbose mode to see detailed information about the conversion:

```bash
logten-to-foreflight --verbose output.csv
```

## Importing to ForeFlight

After generating the CSV file:

1. Navigate to <https://plan.foreflight.com/logbook#/import>
2. Sign in to your ForeFlight account
3. Upload the generated CSV file
4. Review the import preview
5. Confirm the import

## Limitations and Assumptions

This tool has been tailored for specific logbook configurations. You may need to adjust your LogTen Pro setup for full compatibility.

### Flight Records

- **Night Full Stops:** Requires a "Custom Landings" field named "Night Full Stops"
- **Checkrides:** Requires a "Custom Notes" field named "Checkride"
- **FAR 61.58 Recurrent:** Requires a "Custom Notes" field named "FAR 61.58"
- **GPS Approaches:** Converted to RNAV (GPS) in ForeFlight
- **Examiner Time:** Credited when the Examiner field contains your crew profile

### Aircraft Configuration

- **Engine Types:** Must use standard LogTen Pro engine type values
- **Type Codes:** Uses a custom "Type Code" field if present, otherwise the standard aircraft type
- **Simulators:** Requires custom fields for "Sim Type", "Type Code", and "Sim A/C Cat"
- **Diesel Engines:** Requires a custom checkbox field on Aircraft called "Diesel Engine"

### Crew Roles

- **Safety Pilot/Examiner:** Requires custom role fields
- **Role Priority:** Each crew member can have only one role in the exported data
- **Unsupported Roles:** Commander, observer, and relief crew roles are ignored

## See Also

- <doc:Architecture>
