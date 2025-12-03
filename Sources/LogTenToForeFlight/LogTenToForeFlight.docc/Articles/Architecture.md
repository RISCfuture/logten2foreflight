# Architecture Overview

Understand the structure and data flow of the LogTen to ForeFlight converter.

@Metadata {
    @PageImage(purpose: card, source: "architecture", alt: "Architecture diagram showing the conversion pipeline")
}

## Overview

The LogTen to ForeFlight converter uses a layered architecture with clear separation between input processing, conversion logic, and output generation.

![Architecture diagram showing the conversion pipeline](architecture.png)

## Module Structure

The project consists of four Swift modules:

| Module | Type | Purpose |
|--------|------|---------|
| `LogTenToForeFlight` | Executable | Command-line interface and orchestration |
| `libLogTenToForeFlight` | Library | Conversion logic (public API) |
| `LogTen` | Internal | LogTen Pro data models and Core Data reading |
| `ForeFlight` | Internal | ForeFlight data models and CSV writing |

## Data Flow

The conversion process follows a three-stage pipeline:

### Stage 1: Reading

The Reader actor (in LogTen module) loads the LogTen Pro Core Data store and constructs a Logbook containing:

- Flight records with times, approaches, and remarks
- Aircraft with type information
- Crew members and passengers

### Stage 2: Conversion

The Converter class (in libLogTenToForeFlight) transforms LogTen models to ForeFlight format:

- Maps aircraft categories and classes between systems
- Translates approach types to ForeFlight equivalents
- Assigns crew roles with priority-based deduplication
- Calculates derived fields like multi-pilot time

### Stage 3: Writing

The Writer class (in ForeFlight) exports the converted logbook to CSV format using the ForeFlight template structure.

## Concurrency Model

The converter uses Swift's modern concurrency features:

- **Actors:** `Logbook` and `Reader` are actors for thread-safe data access
- **Async/Await:** All I/O operations are asynchronous
- **Sendable:** All model types conform to `Sendable` for safe cross-actor transfer

## Error Handling

Errors are thrown at each stage and propagate to the command-line interface:

- **Read Errors:** Core Data store issues, missing model files
- **Conversion Errors:** Unsupported categories, missing required fields
- **Write Errors:** File system issues, encoding problems

## See Also

- <doc:Usage>
