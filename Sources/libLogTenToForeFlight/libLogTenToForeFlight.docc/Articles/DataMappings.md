# Data Mappings Reference

Complete reference for how LogTen Pro fields map to ForeFlight format.

@Metadata {
    @PageColor(purple)
}

## Overview

This article provides detailed mapping tables showing how each LogTen Pro field is converted to the corresponding ForeFlight field.

## Aircraft Category Mappings

| LogTen Category | ForeFlight Category |
|-----------------|---------------------|
| Airplane | Airplane |
| Rotorcraft | Rotorcraft |
| Glider | Glider |
| Lighter Than Air | Lighter Than Air |
| Powered Lift | Powered Lift |
| Powered Parachute | Powered Parachute |
| Weight-Shift Control | Weight-Shift Control |
| Simulator | Simulator |
| PC/ATD | Simulator |
| Training Device | Simulator |

## Aircraft Class Mappings

### Airplane Classes

| LogTen Class | ForeFlight Class |
|--------------|------------------|
| Single-Engine Land | ASEL |
| Single-Engine Sea | ASES |
| Multi-Engine Land | AMEL |
| Multi-Engine Sea | AMES |

### Rotorcraft Classes

| LogTen Class | ForeFlight Class |
|--------------|------------------|
| Helicopter | Helicopter |
| Gyroplane | Gyroplane |

### Lighter Than Air Classes

| LogTen Class | ForeFlight Class |
|--------------|------------------|
| Airship | Airship |
| Free Balloon | Free Balloon |

### Simulator Classes

| LogTen Simulator Type | ForeFlight Class |
|-----------------------|------------------|
| BATD | ATD |
| AATD | ATD |
| FTD | FTD |
| FFS | FFS |

## Engine Type Mappings

| LogTen Engine | ForeFlight Engine | Notes |
|---------------|-------------------|-------|
| Reciprocating | Piston | Default |
| Reciprocating | Radial | If aircraft has "Radial" flag |
| Reciprocating | Diesel | If aircraft has "Diesel" custom field |
| Electric | Electric | |
| Jet | Turbojet | |
| Turbofan | Turbofan | |
| Turboprop | Turboprop | |
| Turboshaft | Turboshaft | |
| Non-Powered | Non-Powered | |

## Gear Type Mappings

| LogTen Configuration | ForeFlight Gear Type |
|----------------------|----------------------|
| Amphibious | Amphibian |
| Floats | Floats |
| Skids | Skids |
| Skis | Skis |
| Retractable + Tailwheel | Retractable Conventional |
| Retractable | Retractable Tricycle |
| Tailwheel | Fixed Conventional |
| (Default) | Fixed Tricycle |

## Approach Type Mappings

| LogTen Approach | ForeFlight Approach | Notes |
|-----------------|---------------------|-------|
| GCA | GCA | |
| GLS | GLS | |
| GPS/GNSS | RNAV (GPS) | |
| IGS | LDA | Mapped to LDA |
| ILS | ILS | |
| JPALS | RNAV (GPS) | |
| GBAS | RNAV (GPS) | |
| LNAV | RNAV (GPS) | |
| LNAV/VNAV | RNAV (GPS) | |
| LPV | RNAV (GPS) | |
| MLS | MLS | |
| PAR | PAR | |
| WAAS | RNAV (GPS) | |
| ARA | ASR/SRA | |
| Contact | (Ignored) | Not exported |
| DME | VOR | Mapped to VOR |
| GPS | RNAV (GPS) | Legacy GPS |
| IAN | (Ignored) | Not supported |
| LDA | LDA | |
| LOC | LOC | |
| LOC BC | LOC BC | |
| LOC DME | LOC | |
| LP | RNAV (GPS) | |
| NDB | NDB | |
| RNAV | RNAV (GPS) | |
| RNP | RNAV (RNP) | |
| SDF | SDF | |
| SRA | ASR/SRA | |
| TACAN | TACAN | |
| Visual | (Ignored) | Not exported |
| VOR | VOR | |
| VOR DME | VOR | |

## Crew Role Mappings

| LogTen Role | ForeFlight Role | Notes |
|-------------|-----------------|-------|
| PIC | PIC | Unless "me" or instructor |
| SIC | SIC | Unless safety pilot |
| Instructor | Instructor | |
| Student | Student | |
| Safety Pilot | Safety Pilot | Custom LogTen field |
| Examiner | Examiner | Custom LogTen field |
| Flight Engineer | Flight Engineer | |
| Purser | Flight Attendant | |
| Passenger | Passenger | |
| Commander | (Ignored) | |
| Observer | (Ignored) | |
| Relief Crew | (Ignored) | |

## Custom LogTen Fields Required

For full compatibility, configure these custom fields in LogTen Pro:

### Aircraft Fields

- **Diesel Engine** (Checkbox) - Mark aircraft with diesel engines

### Aircraft Type Fields

- **Type Code** - FAA type designator (e.g., "C172" instead of "C-172SP")
- **Sim Type** - Simulator type: BATD, AATD, FTD, or FFS
- **Sim A/C Cat** - Simulated aircraft category/class: ASEL, ASES, AMEL, AMES, or GL

### Flight Fields

- **Night Full Stops** (Custom Landings) - Night full-stop landing count
- **Checkride** (Custom Notes) - Any value marks flight as checkride
- **FAR 61.58** (Custom Notes) - Any value marks flight as recurrent

### Crew Fields

- **Safety Pilot** (Custom Role) - Safety pilot assignment
- **Examiner** (Custom Role) - Examiner assignment

## See Also

- <doc:ConversionProcess>
- ``Converter``
