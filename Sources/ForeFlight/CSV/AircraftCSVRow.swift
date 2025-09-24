import Foundation
import StreamingCSV

package struct AircraftCSVRow {
  package var aircraftID: String?
  package var equipmentType: Aircraft.SimulatorType
  package var typeCode: String?
  package var year: UInt?
  package var make: String
  package var model: String
  package var gearType: Aircraft.GearType?
  package var engineType: Aircraft.EngineType?
  package var categoryClass: String  // Combined Category/Class field
  package var complex: CSVBool
  package var highPerformance: CSVBool
  package var pressurized: CSVBool
  package var taa: CSVBool

  package var csvRow: [String] {
    [
      aircraftID ?? "",
      equipmentType.csvString,
      typeCode ?? "",
      year.map { String($0) } ?? "",
      make,
      model,
      gearType?.csvString ?? "",
      engineType?.csvString ?? "",
      categoryClass,
      complex.csvString,
      highPerformance.csvString,
      pressurized.csvString,
      taa.csvString
    ]
  }

  package init(from aircraft: Aircraft) {
    self.aircraftID = aircraft.tailNumber
    self.equipmentType = aircraft.simulatorType
    self.typeCode = aircraft.typeCode
    self.year = aircraft.year
    self.make = aircraft.make
    self.model = aircraft.model
    self.gearType = aircraft.gearType
    self.engineType = aircraft.engineType
    // Map to ForeFlight's Category/Class format
    self.categoryClass = Self.mapCategoryClass(category: aircraft.category, class: aircraft.class)
    self.complex = CSVBool(aircraft.complex)
    self.highPerformance = CSVBool(aircraft.highPerformance)
    self.pressurized = CSVBool(aircraft.pressurized)
    self.taa = CSVBool(aircraft.technicallyAdvanced)
  }

  private static func mapCategoryClass(category: Aircraft.Category, class: Aircraft.Class?)
    -> String
  {
    switch category {
      case .airplane:
        guard let classValue = `class` else { return "" }
        switch classValue {
          case .singleEngineLand: return "airplane_single_engine_land"
          case .multiEngineLand: return "airplane_multi_engine_land"
          case .singleEngineSea: return "airplane_single_engine_sea"
          case .multiEngineSea: return "airplane_multi_engine_sea"
          default: return ""
        }
      case .rotorcraft:
        guard let classValue = `class` else { return "" }
        switch classValue {
          case .helicopter: return "rotorcraft_helicopter"
          case .gyroplane: return "rotorcraft_gyroplane"
          default: return ""
        }
      case .glider:
        return "glider"
      case .lighterThanAir:
        guard let classValue = `class` else { return "" }
        switch classValue {
          case .airship: return "lighter_than_air_airship"
          case .freeBalloon: return "lighter_than_air_balloon"
          default: return ""
        }
      case .poweredLift:
        return "powered_lift"
      case .poweredParachute:
        guard let classValue = `class` else { return "" }
        switch classValue {
          case .poweredParachuteLand: return "powered_parachute_land"
          case .poweredParachuteSea: return "powered_parachute_sea"
          default: return ""
        }
      case .weightShiftControl:
        guard let classValue = `class` else { return "" }
        switch classValue {
          case .weightShiftControlLand: return "weight_shift_control_land"
          case .weightShiftCOntrolSea: return "weight_shift_control_sea"  // Note: typo in enum
          default: return ""
        }
      case .simulator:
        // Simulators don't use category/class in ForeFlight
        return ""
    }
  }
}
