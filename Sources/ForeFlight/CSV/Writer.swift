import Foundation
import CodableCSV

public class Writer {
    public let logbook: Logbook
    
    public init(logbook: Logbook) {
        self.logbook = logbook
    }
    
    public func write(to file: URL) throws {
        let writer = try CSVWriter(fileURL: file)
        let template = Template.shared
        
        for row in template.rows {
            switch row {
                case let .static(values):
                    try writer.write(row: values)
                case let .aircraft(fields):
                    let valueWriter = ValueWriter(fields: fields)
                    for aircraft in logbook.aircraft {
                        try writer.write(row: valueWriter.row(for: aircraft))
                    }
                case let .entries(fields):
                    let valueWriter = ValueWriter(fields: fields)
                    for entry in logbook.entries {
                        try writer.write(row: valueWriter.row(for: entry))
                    }
            }
        }
    }
}
