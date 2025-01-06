import Foundation

package enum Error: Swift.Error {
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
            case let .couldntCreateStore(path):
                return String(localized: "Couldn’t create Core Data store for “\(path.lastPathComponent)”")
            case let .missingProperty(property, model):
                return String(localized: "\(model) must have a property named “\(property)”")
            case let .unsupportedCategory(category):
                return String(localized: "LogTen Pro aircraft category “\(category.rawValue)” is not supported by ForeFlight")
            case let .unsupportedClass(`class`):
                return String(localized: "LogTen Pro aircraft class “\(`class`.rawValue)” is not supported by ForeFlight")
            case let .unsupportedEngineType(type):
                return String(localized: "LogTen Pro engine type “\(type.rawValue)” is not supported by ForeFlight")
            case let .invalidClass(`class`, category):
                return String(localized: "“\(`class`.rawValue)” is not a valid aircraft class for category “\(category.rawValue)”")
            case let .missingClass(type):
                return String(localized: "Missing aircraft class for aircraft type “\(type)”")
            case let .missingSimulatorType(type):
                return String(localized: "Missing Sim Type for aircraft type “\(type)”")
        }
    }
}
