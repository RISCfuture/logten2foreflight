# ``LogTen``

Read and model LogTen Pro logbook data.

@Metadata {
    @DisplayName("LogTen")
}

## Overview

The LogTen module provides types for reading LogTen Pro logbooks from their Core Data store and representing the data in Swift. This module handles the bridge between LogTen Pro's SQLite-based Core Data store and strongly-typed Swift models.

### Core Data Integration

LogTen Pro stores its logbook data in a Core Data SQLite store. The Reader actor loads this store using the managed object model bundled with LogTen Pro, then fetches and converts the Core Data entities into Swift structs.

### Thread Safety

The Logbook and Reader types are actors, providing thread-safe access to logbook data. All model types conform to `Sendable` for safe cross-actor transfer.

### Key Types

- **Reader**: Loads LogTen Pro Core Data stores
- **Logbook**: Container for flights, aircraft, and people
- **Flight**: A single flight record with timing and crew
- **Aircraft**: An aircraft with type information
- **AircraftType**: Type definitions with category and class
- **Person**: Crew member or passenger
- **Place**: Airport or location
- **Approach**: Instrument approach details
