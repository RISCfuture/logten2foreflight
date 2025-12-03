import Foundation

/// An aircraft or simulator in ForeFlight's logbook format.
///
/// An `Aircraft` represents an aircraft or training device with all the
/// properties expected by ForeFlight's CSV import format.
package struct Aircraft {
  static var fieldMapping: [String: PartialKeyPath<Self>] {
    [
      "AircraftID": \Self.tailNumber,
      "EquipmentType": \Self.simulatorType,
      "TypeCode": \Self.typeCode,
      "Year": \Self.year,
      "Make": \Self.make,
      "Model": \Self.model,
      "Category": \Self.category,
      "Class": \Self.class,
      "GearType": \Self.gearType,
      "EngineType": \Self.engineType,
      "Complex": \Self.complex,
      "HighPerformance": \Self.highPerformance,
      "Pressurized": \Self.pressurized,
      "TAA": \Self.technicallyAdvanced
    ]
  }

  package private(set) var tailNumber: String?
  package private(set) var simulatorType: SimulatorType
  package private(set) var typeCode: String?
  package private(set) var year: UInt?
  package private(set) var make: String
  package private(set) var model: String
  package private(set) var category: Category
  package private(set) var `class`: Class?
  package private(set) var gearType: GearType?
  package private(set) var engineType: EngineType?
  package private(set) var complex: Bool
  package private(set) var highPerformance: Bool
  package private(set) var pressurized: Bool
  package private(set) var technicallyAdvanced: Bool

  package init(
    tailNumber: String,
    simulatorType: SimulatorType,
    typeCode: String?,
    year: UInt? = nil,
    make: String,
    model: String,
    category: Category,
    class: Class? = nil,
    gearType: GearType? = nil,
    engineType: EngineType? = nil,
    complex: Bool = false,
    highPerformance: Bool = false,
    pressurized: Bool = false,
    technicallyAdvanced: Bool = false
  ) {
    self.tailNumber = tailNumber
    self.simulatorType = simulatorType
    self.typeCode = typeCode
    self.year = year
    self.make = make
    self.model = model
    self.category = category
    self.class = `class`
    self.gearType = gearType
    self.engineType = engineType
    self.complex = complex
    self.highPerformance = highPerformance
    self.pressurized = pressurized
    self.technicallyAdvanced = technicallyAdvanced
  }

  /// Landing gear types supported by ForeFlight.
  package enum GearType: String {
    /// Amphibian (floats with retractable wheels).
    case amphibian = "AM"
    /// Float-equipped.
    case floats = "FL"
    /// Skids (helicopters).
    case skids = "Skids"
    /// Skis (winter operations).
    case skis = "Skis"
    /// Fixed conventional (tailwheel).
    case fixedConventional = "FC"
    /// Fixed tricycle (nosewheel).
    case fixedTricycle = "FT"
    /// Retractable conventional (tailwheel).
    case retractableConventional = "RC"
    /// Retractable tricycle (nosewheel).
    case retractableTricycle = "RT"
  }

  /// Engine types supported by ForeFlight.
  package enum EngineType: String {
    /// Diesel engine.
    case diesel = "Diesel"
    /// Electric motor.
    case electric = "Electric"
    /// Non-powered (gliders).
    case nonpowered = "Non-Powered"
    /// Piston (reciprocating) engine.
    case piston = "Piston"
    /// Radial piston engine.
    case radial = "Radial"
    /// Turbofan engine.
    case turbofan = "Turbofan"
    /// Turbojet engine.
    case turbojet = "Turbojet"
    /// Turboprop engine.
    case turboprop = "Turboprop"
    /// Turboshaft engine (helicopters).
    case turboshaft = "Turboshaft"
  }

  /// Equipment types for aircraft and simulators.
  package enum SimulatorType: String {
    /// Real aircraft.
    case aircraft
    /// Full flight simulator.
    case FFS = "ffs"
    /// Flight training device.
    case FTD = "ftd"
    /// Advanced aviation training device.
    case AATD = "aatd"
    /// Basic aviation training device.
    case BATD = "batd"
  }

  /// FAA aircraft categories supported by ForeFlight.
  package enum Category: String {
    /// Airplane (fixed-wing, powered).
    case airplane = "Airplane"
    /// Rotorcraft (helicopter or gyroplane).
    case rotorcraft = "Rotorcraft"
    /// Glider (unpowered fixed-wing).
    case glider = "Glider"
    /// Lighter than air (balloon or airship).
    case lighterThanAir = "Lighter Than Air"
    /// Powered lift (tiltrotor, etc.).
    case poweredLift = "Powered Lift"
    /// Powered parachute.
    case poweredParachute = "Powered Parachute"
    /// Weight-shift control aircraft.
    case weightShiftControl = "Weight-Shift-Control"
    /// Simulator or training device.
    case simulator = "Simulator"
  }

  /// FAA aircraft classes supported by ForeFlight.
  package enum Class: String {
    /// Airplane single-engine land.
    case singleEngineLand = "ASEL"
    /// Airplane multi-engine land.
    case multiEngineLand = "AMEL"
    /// Airplane single-engine sea.
    case singleEngineSea = "ASES"
    /// Airplane multi-engine sea.
    case multiEngineSea = "AMES"
    /// Rotorcraft helicopter.
    case helicopter = "RH"
    /// Rotorcraft gyroplane.
    case gyroplane = "RG"
    /// Glider.
    case glider = "Glider"
    /// Lighter than air airship.
    case airship = "LA"
    /// Lighter than air free balloon.
    case freeBalloon = "LB"
    /// Powered lift.
    case poweredLift = "Powered Lift"
    /// Powered parachute land.
    case poweredParachuteLand = "PL"
    /// Powered parachute sea.
    case poweredParachuteSea = "PS"
    /// Weight-shift control land.
    case weightShiftControlLand = "WL"
    /// Weight-shift control sea.
    case weightShiftCOntrolSea = "WS"
    /// Full flight simulator.
    case FFS = "FFS"
    /// Flight training device.
    case FTD = "FTD"
    /// Aviation training device.
    case ATD = "ATD"
  }
}
