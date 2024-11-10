import Foundation
@preconcurrency import GRDB

package protocol Model: Codable, Sendable, FetchableRecord, TableRecord, EncodableRecord {}

extension Model where Self: Identifiable {
    static package func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    package func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func parseDate(_ value: Int64?) -> Date? {
        guard let value else { return nil }
        return Date(timeIntervalSince2001: value)
    }
}

protocol RecordEnum: RawRepresentable, Codable {
    init?(from value: RawValue?)
}

extension RecordEnum {
    public init?(from value: RawValue?) {
        guard let value else { return nil }
        self.init(rawValue: value)
    }
}
