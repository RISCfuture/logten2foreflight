import Foundation

public enum Error: Swift.Error {
    case unknownLogTenValue(_ value: Any, field: String)
    case missingLogTenValue(field: String)
}

extension Error: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case let .unknownLogTenValue(value, field):
                return "Unknown value ‘\(value)’ for \(field)"
            case let .missingLogTenValue(field):
                return "Missing value for \(field)"
        }
    }
}
