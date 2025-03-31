@preconcurrency import CodableCSV
import Foundation

class Template {
    private let templateURL = Bundle.module.url(forResource: "logbook_template", withExtension: "csv")!

    func buildRows() throws -> [Row] {
        let reader = try CSVReader(input: templateURL)

        var aircraftFieldsRow: Array<String>!,
            entryFieldsRow: Array<String>!,
            rows = [Row]()

        while let row = try reader.readRow() {
            switch row.first {
                case "AIRCRAFT_FIELDS":
                    rows.append(.static(values: Array(row[1...])))
                    aircraftFieldsRow = Array(row[1...])
                case "FLIGHT_FIELDS":
                    rows.append(.static(values: Array(row[1...])))
                    entryFieldsRow = Array(row[1...])
                case "AIRCRAFT":
                    rows.append(.aircraft(fields: aircraftFields(from: aircraftFieldsRow)))
                case "FLIGHTS":
                    rows.append(.entries(fields: entryFields(from: entryFieldsRow)))
                case "STATIC": rows.append(.static(values: Array(row[1...])))
                default: fatalError("Unknown row type ‘\(String(describing: row.first))’")
            }
        }

        return rows
    }

    private func aircraftFields(from row: [String]) -> [PartialKeyPath<Aircraft>] {
        var fields = [PartialKeyPath<Aircraft>]()
        for fieldName in row {
            guard !fieldName.isEmpty else { continue }
            guard let field = Aircraft.fieldMapping[fieldName] else { fatalError("No var on Aircraft for \(fieldName)") }
            fields.append(field)
        }
        return fields
    }

    private func entryFields(from row: [String]) -> [PartialKeyPath<Flight>?] {
        row.map { fieldName in
            guard let field = Flight.fieldMapping[fieldName] else { fatalError("No var on Flight for \(fieldName)") }
            return field
        }
    }

    enum Row {
        case `static`(values: Array<String>)
        case aircraft(fields: Array<PartialKeyPath<Aircraft>?>)
        case entries(fields: Array<PartialKeyPath<Flight>?>)
    }
}
