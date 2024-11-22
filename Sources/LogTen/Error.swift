import Foundation

package enum Error: Swift.Error {
    case unknownLogTenValue(_ value: Sendable, field: String)
    case missingLogTenValue(field: String)
    case couldntCreateStore(path: URL)
    case missingProperty(_ property: String, model: String)
    case unsupportedCategory(_ category: AircraftType.Category)
    case unsupportedClass(_ `class`: AircraftType.Class)
    case unsupportedEngineType(_ type: AircraftType.EngineType)
    case invalidClass(_ `class`: AircraftType.Class, forCategory: AircraftType.Category)
    case missingClass(type: String)
    case missingSimulatorType(type: String)
}

extension Error: LocalizedError {
    package var errorDescription: String? {
        switch self {
            case let .unknownLogTenValue(value, field):
                return "Unknown value ‘\(value)’ for \(field)"
            case let .missingLogTenValue(field):
                return "Missing value for \(field)"
            case let .couldntCreateStore(path):
                return "Couldn’t create Core Data store for “\(path.lastPathComponent)”"
            case let .missingProperty(property, model):
                return "\(model) must have a property named “\(property)”"
            case let .unsupportedCategory(category):
                return "LogTen Pro aircraft category “\(category)” is not supported by ForeFlight"
            case let .unsupportedClass(`class`):
                return "LogTen Pro aircraft class “\(`class`)” is not supported by ForeFlight"
            case let .unsupportedEngineType(type):
                return "LogTen Pro engine type “\(type)” is not supported by ForeFlight"
            case let .invalidClass(`class`, category):
                return "“\(`class`)” is not a valid aircraft class for category “\(category)”"
            case let .missingClass(type):
                return "Missing aircraft class for aircraft type “\(type)”"
            case let .missingSimulatorType(type):
                return "Missing Sim Type for aircraft type “\(type)”"
        }
    }
}
