# ``LogTenToForeFlight``

Convert LogTen Pro logbooks to ForeFlight CSV format.

@Metadata {
    @DisplayName("LogTen to ForeFlight")
}

## Overview

LogTenToForeFlight is a command-line tool that reads a LogTen Pro logbook stored on your Mac and converts it to a CSV file suitable for import into ForeFlight Logbook.

The tool reads directly from LogTen Pro's Core Data store, extracts flight entries, aircraft, and crew information, then transforms this data into ForeFlight's CSV import format.

### Requirements

- macOS 15 or later
- LogTen Pro for macOS installed
- Swift 6 runtime

### Quick Start

```bash
# Basic usage with default LogTen Pro location
logten-to-foreflight output.csv

# Specify custom LogTen Pro data file
logten-to-foreflight --logten-file ~/path/to/LogTenCoreDataStore.sql output.csv

# Enable verbose output
logten-to-foreflight --verbose output.csv
```

After generating the CSV file, import it to ForeFlight Logbook at <https://plan.foreflight.com/logbook#/import>.

## Topics

### Articles

- <doc:Usage>
- <doc:Architecture>

### Entry Point

- ``LogtenToForeFlight``
