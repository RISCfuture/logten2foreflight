import Foundation
@preconcurrency import CodableCSV

package class Writer {
    package let logbook: Logbook

    package init(logbook: Logbook) {
        self.logbook = logbook
    }

    package func write(to file: URL) async throws {
        let writer = try CSVWriter(fileURL: file),
            template = Template(),
            rows = try template.buildRows()

        for row in rows {
            switch row {
                case let .static(values):
                    try writer.write(row: values)
                case let .aircraft(fields):
                    let valueWriter = ValueWriter(fields: fields)
                    for aircraft in await logbook.aircraft {
                        try writer.write(row: valueWriter.row(for: aircraft))
                    }
                case let .entries(fields):
                    let valueWriter = ValueWriter(fields: fields)
                    for entry in await logbook.entries {
                        try writer.write(row: valueWriter.row(for: entry))
                    }
            }
        }
    }
}
