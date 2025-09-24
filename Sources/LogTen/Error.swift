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
      case .couldntCreateStore(let path):
        return String(localized: "Couldn’t create Core Data store for “\(path.lastPathComponent)”")
      case .missingProperty(let property, let model):
        return String(localized: "\(model) must have a property named “\(property)”")
      case .unsupportedCategory(let category):
        return String(
          localized:
            "LogTen Pro aircraft category “\(category.rawValue)” is not supported by ForeFlight"
        )
      case .unsupportedClass(let `class`):
        return String(
          localized:
            "LogTen Pro aircraft class “\(`class`.rawValue)” is not supported by ForeFlight"
        )
      case .unsupportedEngineType(let type):
        return String(
          localized: "LogTen Pro engine type “\(type.rawValue)” is not supported by ForeFlight"
        )
      case .invalidClass(let `class`, let category):
        return String(
          localized:
            "“\(`class`.rawValue)” is not a valid aircraft class for category “\(category.rawValue)”"
        )
      case .missingClass(let type):
        return String(localized: "Missing aircraft class for aircraft type “\(type)”")
      case .missingSimulatorType(let type):
        return String(localized: "Missing Sim Type for aircraft type “\(type)”")
    }
  }
}
