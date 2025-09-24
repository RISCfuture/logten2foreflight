import Foundation
import StreamingCSV

class Template {
  private let templateURL = Bundle.module.url(
    forResource: "logbook_template",
    withExtension: "csv"
  )!

  func buildRows() async throws -> [Row] {
    let reader = try StreamingCSVReader(url: templateURL)

    var rows = [Row]()
    var lineNumber = 0
    var aircraftFields: [String]!
    var flightFields: [String]!

    for try await row in await reader.rows() {
      lineNumber += 1

      switch lineNumber {
        case 1...4:
          // Static header rows (ForeFlight Logbook Import, blank, Aircraft Table, Text types)
          rows.append(.static(values: row))
        case 5:
          // Aircraft field names row - save for later use
          aircraftFields = row
          rows.append(.static(values: row))
        case 6:
          // This is where aircraft data will be inserted
          rows.append(.aircraft(fields: aircraftFields))
        case 7...13:
          // Static spacing rows
          rows.append(.static(values: row))
        case 14:
          // Flight table header type row
          rows.append(.static(values: row))
        case 15:
          // Flight field names row - save for later use
          flightFields = row
          rows.append(.static(values: row))
        default:
          // Any additional rows (should be none in the template)
          break
      }
    }

    // After processing the template, add the entries row for flight data
    if let flightFields {
      rows.append(.entries(fields: flightFields))
    }

    return rows
  }

  enum Row {
    case `static`(values: [String])
    case aircraft(fields: [String])
    case entries(fields: [String])
  }
}
