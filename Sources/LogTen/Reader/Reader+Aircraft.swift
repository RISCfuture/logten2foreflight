import CoreData
import Foundation

private let typeCodeField = "Type Code"
private let simTypeField = "Sim Type"
private let dieselField = "Diesel Engine"

private let faaComplexField = "FAA Complex"
private let easaComplexField = "EASA Complex"
private let faaHighPerformanceField = "FAA High Performance"
private let easaSPHPField = "EASA SPHP"

private let easaEquipTypeField = "EASA Equip Type"

extension Reader {
  func fetchAircraft() throws -> [Aircraft] {
    let request = CNAircraft.fetchRequest()
    let aircraft = try container.viewContext.fetch(request)

    let typeCodeProperty = try aircraftTypeCustomAttribute(for: typeCodeField)
    let simTypeProperty = try aircraftTypeCustomAttribute(for: simTypeField)
    let dieselProperty = try aircraftCustomAttribute(for: dieselField)

    let faaComplexProperty = try? aircraftCustomAttribute(for: faaComplexField)
    let easaComplexProperty = try? aircraftCustomAttribute(for: easaComplexField)
    let faaHighPerformanceProperty = try? aircraftCustomAttribute(for: faaHighPerformanceField)
    let easaSPHPProperty = try? aircraftCustomAttribute(for: easaSPHPField)

    let easaEquipTypeProperty = try? aircraftTypeCustomAttribute(for: easaEquipTypeField)

    let categoryTitles = try customizationTitles(keyPrefix: "flight_category")
    let classTitles = try customizationTitles(keyPrefix: "flight_aircraftClass")
    let engineTypeTitles = try customizationTitles(keyPrefix: "flight_engineType")

    return aircraft.map { aircraft in
      .init(
        aircraft: aircraft,
        typeCodeProperty: typeCodeProperty,
        simTypeProperty: simTypeProperty,
        dieselProperty: dieselProperty,
        faaComplexProperty: faaComplexProperty,
        easaComplexProperty: easaComplexProperty,
        faaHighPerformanceProperty: faaHighPerformanceProperty,
        easaSPHPProperty: easaSPHPProperty,
        categoryTitles: categoryTitles,
        classTitles: classTitles,
        engineTypeTitles: engineTypeTitles,
        easaEquipTypeProperty: easaEquipTypeProperty
      )
    }
  }

  /// Fetches all customization properties whose key begins with the given
  /// prefix and returns a map from raw key to user-displayed title.
  func customizationTitles(keyPrefix: String) throws -> [String: String] {
    let request = NSFetchRequest<CNLogTenCustomizationProperty>(
      entityName: "LogTenCustomizationProperty"
    )
    request.predicate = .init(format: "logTenProperty_key BEGINSWITH %@", keyPrefix)
    let result = try container.viewContext.fetch(request)
    return Dictionary(
      result.map { ($0.logTenProperty_key, $0.logTenCustomizationProperty_title) },
      uniquingKeysWith: { first, _ in first }
    )
  }

  private func aircraftTypeCustomAttribute(for title: String) throws -> KeyPath<
    CNAircraftType, String?
  > {
    let request = CNLogTenCustomizationProperty.fetchRequest(
      title: title,
      keyPrefix: "aircraftType_customAttribute"
    )
    let result = try container.viewContext.fetch(request)
    guard result.count == 1, let property = result.first else {
      throw Error.missingProperty(title, model: "Aircraft Type")
    }
    switch property.logTenProperty_key {
      case "aircraftType_customAttribute1": return \.aircraftType_customAttribute1
      case "aircraftType_customAttribute2": return \.aircraftType_customAttribute2
      case "aircraftType_customAttribute3": return \.aircraftType_customAttribute3
      case "aircraftType_customAttribute4": return \.aircraftType_customAttribute4
      case "aircraftType_customAttribute5": return \.aircraftType_customAttribute5
      default: preconditionFailure("Unknown custom attribute \(property.logTenProperty_key)")
    }
  }

  private func aircraftCustomAttribute(for title: String) throws -> KeyPath<CNAircraft, Bool> {
    let request = CNLogTenCustomizationProperty.fetchRequest(
      title: title,
      keyPrefix: "aircraft_customAttribute"
    )
    let result = try container.viewContext.fetch(request)
    guard result.count == 1, let property = result.first else {
      throw Error.missingProperty(title, model: "Aircraft")
    }
    switch property.logTenProperty_key {
      case "aircraft_customAttribute1": return \.aircraft_customAttribute1
      case "aircraft_customAttribute2": return \.aircraft_customAttribute2
      case "aircraft_customAttribute3": return \.aircraft_customAttribute3
      case "aircraft_customAttribute4": return \.aircraft_customAttribute4
      case "aircraft_customAttribute5": return \.aircraft_customAttribute5
      default: preconditionFailure("Unknown custom attribute \(property.logTenProperty_key)")
    }
  }
}
