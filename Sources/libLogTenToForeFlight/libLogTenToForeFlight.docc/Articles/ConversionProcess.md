# Understanding the Conversion Process

Learn how LogTen Pro data is transformed into ForeFlight format.

@Metadata {
    @PageColor(orange)
}

## Overview

The ``Converter`` class orchestrates the transformation of a complete LogTen Pro logbook into ForeFlight format. This article explains the conversion logic and key decisions made during the process.

## Conversion Pipeline

The conversion processes three types of records in sequence:

1. **People** - Crew members and passengers
2. **Aircraft** - Aircraft and simulator records
3. **Flights** - Flight log entries

### People Conversion

People are converted with minimal transformation:

- Name and email are preserved directly
- The person's unique identifier (a URL in LogTen) is used for deduplication

### Aircraft Conversion

Aircraft conversion involves several mapping steps:

| LogTen Field | ForeFlight Field | Notes |
|--------------|------------------|-------|
| Tail Number | Aircraft ID | Direct mapping |
| Type | Type Code | Uses custom "Type Code" field if available |
| Year | Year | Direct mapping |
| Category | Category | See category mapping table |
| Class | Class | Derived from category and class |
| Engine Type | Engine Type | See engine mapping table |

#### Simulator Handling

Simulators require special handling because ForeFlight has a more detailed simulator classification:

- **BATD/AATD:** Maps to ATD class
- **FTD:** Maps to FTD class
- **FFS:** Maps to FFS class

The simulator's simulated aircraft category and class come from custom LogTen fields.

### Flight Conversion

Flight entries are the most complex conversion, involving:

#### Time Fields

All time fields (total, PIC, SIC, night, etc.) are converted from `TimeInterval` to hours.

#### Crew Roles

Each crew member can have only one role in the ForeFlight output. Roles are assigned in priority order:

1. Safety Pilot
2. Examiner
3. Instructor
4. Student
5. Flight Engineer
6. PIC (if not "me" and not the instructor)
7. SIC (if not the safety pilot)
8. Flight Attendants
9. Passengers

#### Approach Conversion

LogTen approach types are mapped to the smaller set of ForeFlight approach types. For example:

- GPS, LNAV, LPV, WAAS → RNAV (GPS)
- ARA, SRA → ASR/SRA
- IGS → LDA

#### Special Fields

Several fields require custom LogTen configuration:

- **Checkride:** Detected from flight review flag + "checkride" in remarks
- **Multi-pilot Time:** Calculated from the aircraft type's multi-pilot flag
- **Examiner Time:** Credited when the current user is the examiner

## Handling Edge Cases

### Missing Required Fields

The converter throws errors for missing required information:

- Missing aircraft class for categories that require one
- Missing simulator type for simulator categories
- Unsupported category or engine type values

### Logging

The converter uses Swift Logging to report decisions and warnings:

```swift
Self.logger.notice(
    "Assuming Powered Parachute land class for Powered Parachute type",
    metadata: ["aircraftType": "\(type.typeCode)"]
)
```

## See Also

- <doc:DataMappings>
- ``Converter``
