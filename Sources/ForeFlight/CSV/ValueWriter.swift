import Foundation

private let zulu = TimeZone(secondsFromGMT: 0)!,
            posix = Locale(identifier: "en_US_POSIX")

class ValueWriter<Record> {
    private static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = posix
        formatter.timeZone = zulu
        formatter.dateFormat = "yyyy-MM-dd"

        return formatter
    }

    private static var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = posix
        formatter.timeZone = zulu
        formatter.dateFormat = "HHmm"

        return formatter
    }

    private let fields: [PartialKeyPath<Record>?]

    init(fields: [PartialKeyPath<Record>?]) {
        self.fields = fields
    }

    func row(for record: Record) -> [String] {
        fields.map { field in
            guard let field else { return "" }
            return encode(value: record[keyPath: field])
        }
    }

    func encode(value: Any) -> String {
        return switch value {
            case let value as String: value
            case let value as any BinaryInteger: String(value)
            case let value as any BinaryFloatingPoint: String(format: "%0.1f", value as! CVarArg)
            case let value as Bool: value ? "x" : ""
            case let value as any RawRepresentable: encode(value: value.rawValue)
            case let value as DateOnly: Self.dateFormatter.string(from: value.date)
            case let value as TimeOnly: Self.timeFormatter.string(from: value.date)
            case let value as Flight.Approach:
                [value.count,
                 value.type,
                 value.runway as Any,
                 value.airport,
                 value.comments as Any]
                    .map { encode(value: $0) }.joined(separator: ";")
            case let value as Flight.Member:
                [value.person.name,
                 value.role,
                 value.person.email as Any]
                    .map { encode(value: $0) }.joined(separator: ";")
            default: ""
        }
    }
}

struct DateOnly {
    var date: Date

    init(_ date: Date) { self.date = date }
}

struct TimeOnly {
    var date: Date

    init(_ date: Date) { self.date = date }
}
