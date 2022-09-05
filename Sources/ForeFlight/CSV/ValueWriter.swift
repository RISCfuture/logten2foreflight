import Foundation

fileprivate let zulu = TimeZone(secondsFromGMT: 0)!
fileprivate let posix = Locale(identifier: "en_US_POSIX")

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
    
    private let fields: Array<PartialKeyPath<Record>?>
    
    init(fields: Array<PartialKeyPath<Record>?>) {
        self.fields = fields
    }
    
    func row(for record: Record) -> Array<String> {
        fields.map { field in
            guard let field = field else { return "" }
            return encode(value: record[keyPath: field])
        }
    }
    
    func encode(value: Any) -> String {
        if let value = value as? String { return value }
        if let value = value as? any BinaryInteger { return String(value) }
        if let value = value as? any BinaryFloatingPoint { return String(format: "%0.1f", value as! CVarArg) }
        if let value = value as? Bool { return value ? "x" : "" }
        if let value = value as? any RawRepresentable { return encode(value: value.rawValue) }
        if let value = value as? DateOnly { return Self.dateFormatter.string(from: value.date) }
        if let value = value as? TimeOnly { return Self.timeFormatter.string(from: value.date) }
        if let value = value as? Entry.Approach {
            let vars: Array<Any> = [value.count as Any,
                                    value.type as Any,
                                    value.runway as Any,
                                    value.airport as Any,
                                    value.comments as Any]
            return vars.map { encode(value: $0) }.joined(separator: ";")
        }
        if let value = value as? Entry.Member {
            let vars: Array<Any> = [value.person.name as Any,
                                    value.role as Any,
                                    value.person.email as Any]
            return vars.map { encode(value: $0) }.joined(separator: ";")
        }
        return ""
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
