import Foundation

/// Errors that can occur when reading or processing LogTen Pro data.
package enum Error: Swift.Error {
  /// The Core Data store could not be created from the managed object model.
  /// - Parameter path: The URL to the managed object model that failed to load.
  case couldntCreateStore(path: URL)

  /// A required property is missing from a Core Data record.
  /// - Parameters:
  ///   - property: The name of the missing property.
  ///   - model: The name of the Core Data entity.
  case missingProperty(_ property: String, model: String)

  /// The aircraft category is not supported by ForeFlight.
  /// - Parameter category: The unsupported LogTen Pro category.
  case unsupportedCategory(_ category: AircraftType.Category)

  /// The aircraft class is not supported by ForeFlight.
  /// - Parameter class: The unsupported LogTen Pro class.
  case unsupportedClass(_ `class`: AircraftType.Class)

  /// The engine type is not supported by ForeFlight.
  /// - Parameter type: The unsupported LogTen Pro engine type.
  case unsupportedEngineType(_ type: AircraftType.EngineType)

  /// The aircraft class is not valid for the specified category.
  /// - Parameters:
  ///   - class: The invalid class.
  ///   - forCategory: The category that doesn't support this class.
  case invalidClass(_ `class`: AircraftType.Class, forCategory: AircraftType.Category)

  /// The aircraft type requires a class but none is specified.
  /// - Parameter type: The type code of the aircraft missing a class.
  case missingClass(type: String)

  /// The simulator type requires a Sim Type custom field but none is specified.
  /// - Parameter type: The type code of the simulator missing type information.
  case missingSimulatorType(type: String)
}

extension Error: LocalizedError {
  package var errorDescription: String? {
    switch self {
      case .couldntCreateStore(let path):
        return String(localized: "Couldn’t create Core Data store for “\(path.lastPathComponent)”")
      case let .missingProperty(property, model):
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
      case let .invalidClass(`class`, category):
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
