# ``ForeFlight``

Model and export ForeFlight logbook data.

@Metadata {
    @DisplayName("ForeFlight")
}

## Overview

The ForeFlight module provides types for representing ForeFlight logbook data and exporting it to CSV format. The data model matches ForeFlight's import format specification.

### CSV Export

The Writer class exports a Logbook to a CSV file using ForeFlight's template format. The CSV includes three sections: flights, aircraft, and people.

### Data Model

The ForeFlight data model is simpler than LogTen Pro's, with fewer aircraft categories and approach types. The Converter (in libLogTenToForeFlight) handles the mapping between the two systems.

### Key Types

- **Writer**: Exports logbooks to CSV format
- **Logbook**: Container for flights, aircraft, and people
- **Flight**: A flight entry with timing, approaches, and crew
- **Aircraft**: An aircraft with category, class, and equipment
- **Person**: Crew member or passenger

### Date and Time Helpers

- **DateOnly**: Date-only wrapper for CSV formatting
- **TimeOnly**: Time-only wrapper for CSV formatting
