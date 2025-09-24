import Foundation
import StreamingCSV

package class Writer {
  package let logbook: Logbook

  package init(logbook: Logbook) {
    self.logbook = logbook
  }

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
