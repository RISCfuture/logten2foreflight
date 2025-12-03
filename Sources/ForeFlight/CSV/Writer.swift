import Foundation
import StreamingCSV

/// Writes a ForeFlight logbook to CSV format.
///
/// The `Writer` class exports a ``Logbook`` to a CSV file using ForeFlight's
/// import template structure. The output includes sections for flights, aircraft,
/// and people.
///
/// ## Usage
///
/// ```swift
/// let logbook = ForeFlight.Logbook()
/// // ... populate logbook ...
/// let writer = Writer(logbook: logbook)
/// try await writer.write(to: URL(filePath: "output.csv"))
/// ```
package class Writer {
  /// The logbook to export.
  package let logbook: Logbook

  /// Creates a writer for the specified logbook.
  /// - Parameter logbook: The ForeFlight logbook to export.
  package init(logbook: Logbook) {
    self.logbook = logbook
  }

  /// Writes the logbook to a CSV file.
  ///
  /// - Parameter file: The URL where the CSV file will be created.
  /// - Throws: An error if the file cannot be written.
  package func write(to file: URL) async throws {
    let writer = try StreamingCSVWriter(url: file)
    let template = Template()
    let rows = try await template.buildRows()

    // Determine the total number of columns (flights table has the most)
    let totalColumns = 68  // Based on the ForeFlight template structure

    for row in rows {
      switch row {
        case .static(let values):
          try await writer.writeRow(values)
        case .aircraft:
          for aircraft in await logbook.aircraft {
            let csvRow = AircraftCSVRow(from: aircraft)
            // Convert to array and pad with empty strings
            var rowArray = csvRow.csvRow
            while rowArray.count < totalColumns {
              rowArray.append("")
            }
            try await writer.writeRow(rowArray)
          }
        case .entries:
          for entry in await logbook.entries {
            let csvRow = FlightCSVRow(from: entry)
            try await writer.writeRow(csvRow)
          }
      }
    }

    try await writer.flush()
  }
}
