# ``libLogTenToForeFlight``

Convert LogTen Pro logbooks to ForeFlight format programmatically.

@Metadata {
    @DisplayName("LogTen to ForeFlight Library")
}

## Overview

The libLogTenToForeFlight library provides a programmatic interface for converting LogTen Pro logbooks to ForeFlight CSV format. This library is used by the `logten-to-foreflight` command-line tool but can also be integrated into your own Swift applications.

### Key Features

- **Complete Conversion:** Converts flights, aircraft, and crew from LogTen Pro format
- **Smart Mapping:** Automatically maps aircraft categories, classes, and approach types
- **Async/Await:** Built with Swift concurrency for efficient I/O operations
- **Type Safety:** Full Swift 6 language mode support with `Sendable` conformance

### Basic Usage

```swift
import libLogTenToForeFlight
import LogTen
import ForeFlight

// Read the LogTen Pro logbook
let reader = try await LogTen.Reader(
    storeURL: logtenDataStoreURL,
    modelURL: managedObjectModelURL
)
let logtenLogbook = try reader.read()

// Convert to ForeFlight format
let converter = Converter(logbook: logtenLogbook)
let foreflightLogbook = try await converter.convert()

// Write to CSV
let writer = ForeFlight.Writer(logbook: foreflightLogbook)
try await writer.write(to: outputURL)
```

## Topics

### Articles

- <doc:GettingStarted>
- <doc:ConversionProcess>
- <doc:DataMappings>

### Conversion

- ``Converter``
