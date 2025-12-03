# Getting Started with libLogTenToForeFlight

Learn how to integrate the LogTen to ForeFlight conversion library into your Swift application.

@Metadata {
    @PageColor(green)
}

## Overview

This guide walks you through the process of using libLogTenToForeFlight to convert LogTen Pro logbook data to ForeFlight format in your own applications.

## Adding the Dependency

Add libLogTenToForeFlight to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/RISCfuture/logten2foreflight.git", from: "1.0.0")
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            .product(name: "libLogTenToForeFlight", package: "logten2foreflight")
        ]
    )
]
```

## Prerequisites

To use this library, you need:

1. **LogTen Pro for macOS** installed on the system
2. Access to the LogTen Pro Core Data store file
3. Access to the LogTen Pro managed object model

### Finding LogTen Pro Files

The LogTen Pro data is typically stored at:

```
~/Library/Group Containers/group.com.coradine.LogTenPro/
    LogTenProData_*/LogTenCoreDataStore.sql
```

The managed object model is located in the application bundle:

```
/Applications/LogTen.app/Contents/Resources/CNLogBookDocument.momd
```

## Basic Conversion Flow

The conversion process involves three steps:

### Step 1: Read the LogTen Logbook

```swift
import LogTen

let storeURL = URL(filePath: "path/to/LogTenCoreDataStore.sql")
let modelURL = URL(filePath: "/Applications/LogTen.app/Contents/Resources/CNLogBookDocument.momd")

let reader = try await LogTen.Reader(storeURL: storeURL, modelURL: modelURL)
let logbook = try reader.read()
```

### Step 2: Convert to ForeFlight Format

```swift
import libLogTenToForeFlight

let converter = Converter(logbook: logbook)
let foreflightLogbook = try await converter.convert()
```

### Step 3: Write the CSV Output

```swift
import ForeFlight

let writer = ForeFlight.Writer(logbook: foreflightLogbook)
try await writer.write(to: URL(filePath: "output.csv"))
```

## Error Handling

The conversion process can throw errors for unsupported configurations:

```swift
do {
    let foreflightLogbook = try await converter.convert()
} catch libLogTenToForeFlight.Error.unsupportedCategory(let category) {
    print("Unsupported aircraft category: \(category)")
} catch libLogTenToForeFlight.Error.missingClass(let typeCode) {
    print("Missing class for aircraft type: \(typeCode)")
} catch {
    print("Conversion failed: \(error)")
}
```

## Next Steps

- Learn about the <doc:ConversionProcess> in detail
- Review <doc:DataMappings> between LogTen and ForeFlight
