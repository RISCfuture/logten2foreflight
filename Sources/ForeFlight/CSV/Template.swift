import Foundation
import CodableCSV

class Template {
    private let templateURL = Bundle.module.url(forResource: "logbook_template", withExtension: "csv")!
    static let shared = Template()
    var rows = Array<Row>()
    
    private init() {
        do {
            try buildRows()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    private func buildRows() throws {
        let reader = try CSVReader(input: templateURL)
        
        var aircraftFieldsRow: Array<String>!
        var entryFieldsRow: Array<String>!
        
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
    }
    
    private func aircraftFields(from row: Array<String>) -> Array<PartialKeyPath<Aircraft>> {
        row.compactMap { fieldName in
            guard !fieldName.isEmpty else { return nil }
            guard let field = Aircraft.fieldMapping[fieldName] else { fatalError("No var on Aircraft for \(fieldName)") }
            return field
        }
    }
    
    private func entryFields(from row: Array<String>) -> Array<PartialKeyPath<Entry>?> {
        row.map { fieldName in
            guard let field = Entry.fieldMapping[fieldName] else { fatalError("No var on Entry for \(fieldName)") }
            return field
        }
    }
    
    enum Row {
        case `static`(values: Array<String>)
        case aircraft(fields: Array<PartialKeyPath<Aircraft>?>)
        case entries(fields: Array<PartialKeyPath<Entry>?>)
    }
}
