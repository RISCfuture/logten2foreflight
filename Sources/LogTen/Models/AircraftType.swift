/// The type definition for an aircraft in LogTen Pro.
///
/// An `AircraftType` defines the make, model, category, class, and engine type
/// for a category of aircraft. Multiple ``Aircraft`` instances can share the
/// same type.
package struct AircraftType: IdentifiableRecord {

  // MARK: Properties

  /// The unique identifier for this aircraft type.
  package let id: String

  /// The FAA type designator (e.g., "C172", "PA28").
  package let typeCode: String

  /// The aircraft manufacturer.
  package let make: String

  /// The aircraft model name.
  package let model: String

  /// The FAA aircraft category.
  package let category: Category

  /// The FAA aircraft class, if applicable for this category.
  package let `class`: Class?

  /// The simulator type, if this is a training device.
  package let simulatorType: SimulatorType?

  /// The category and class of aircraft being simulated.
  package let simulatorCategoryClass: SimulatorCategoryClass?

  /// The engine type.
  package let engineType: EngineType?

  /// Whether this aircraft type requires a multi-pilot crew.
  package let multiPilot: Bool

  // MARK: Computed Properties

  /// The type code, or `nil` for ATD simulators.
  ///
  /// FFS and FTD simulators return the type code of the aircraft being simulated.
  /// BATD and AATD simulators return `nil` since they don't simulate a specific type.
  package var simulatorAwareTypeCode: String? {
    switch category {
      case .simulator:
        switch simulatorType {
          case .FFS, .FTD: return typeCode
          default: return nil
        }
      default: return typeCode
    }
  }

  // MARK: Initializers

  init(
    aircraftType: CNAircraftType,
    typeCodeProperty: KeyPath<CNAircraftType, String?>,
    simTypeProperty: KeyPath<CNAircraftType, String?>,
    simCategoryProperty: KeyPath<CNAircraftType, String?>
  ) {

    id = aircraftType.aircraftType_type
    typeCode = aircraftType[keyPath: typeCodeProperty] ?? aircraftType.aircraftType_type
    make = aircraftType.aircraftType_make
    model = aircraftType.aircraftType_model
    category = .init(rawValue: aircraftType.aircraftType_category.logTenProperty_key)!
    `class` = {
      guard let title = aircraftType.aircraftType_aircraftClass?.logTenProperty_key else {
        return nil
      }
      return .init(rawValue: title)
    }()

    simulatorType = {
      guard let typeString = aircraftType[keyPath: simTypeProperty] else { return nil }
      return .init(rawValue: typeString)
    }()
    simulatorCategoryClass = {
      guard let typeString = aircraftType[keyPath: simCategoryProperty] else { return nil }
      return .init(rawValue: typeString)
    }()
    engineType = {
      guard let key = aircraftType.aircraftType_engineType?.logTenProperty_key else { return nil }
      return .init(rawValue: key)
    }()
    multiPilot = aircraftType.aircraftType_multiPilot
  }

  // MARK: Enums

  /// FAA aircraft categories as defined in LogTen Pro.
  package enum Category: String, RecordEnum {
    /// Airplane (fixed-wing, powered).
    case airplane = "flight_category1"
    /// Rotorcraft (helicopter or gyroplane).
    case rotorcraft = "flight_category2"
    /// Powered lift (tiltrotor, etc.).
    case poweredLift = "flight_category3"
    /// Glider (unpowered fixed-wing).
    case glider = "flight_category4"
    /// Lighter than air (balloon or airship).
    case lighterThanAir = "flight_category5"
    /// Simulator or training device.
    case simulator = "flight_category6"
    /// Training device.
    case trainingDevice = "flight_category7"
    /// Personal computer aviation training device.
    case PC_ATD = "flight_category8"
    /// Powered parachute.
    case poweredParachute = "flight_category9"
    /// Weight-shift control aircraft.
    case weightShiftControl = "flight_category10"
    /// Unmanned aerial vehicle.
    case UAV = "flight_category11"
    /// Other category.
    case other = "flight_category12"
  }

  /// FAA aircraft classes as defined in LogTen Pro.
  package enum Class: String, RecordEnum {
    /// Airplane multi-engine land.
    case multiEngineLand = "flight_aircraftClass1"
    /// Airplane single-engine land.
    case singleEngineLand = "flight_aircraftClass2"
    /// Airplane multi-engine sea.
    case multiEngineSea = "flight_aircraftClass3"
    /// Airplane single-engine sea.
    case singleEngineSea = "flight_aircraftClass4"
    /// Other class.
    case other = "flight_aircraftClass5"
    /// Rotorcraft gyroplane.
    case gyroplane = "flight_aircraftClass6"
    /// Lighter than air airship.
    case airship = "flight_aircraftClass7"
    /// Lighter than air free balloon.
    case freeBalloon = "flight_aircraftClass8"
    /// Rotorcraft helicopter.
    case helicopter = "flight_aircraftClass9"
  }

  /// Engine types as defined in LogTen Pro.
  package enum EngineType: String, RecordEnum {
    /// Jet (turbojet) engine.
    case jet = "flight_engineType1"
    /// Generic turbine engine.
    case turbine = "flight_engineType2"
    /// Turboprop engine.
    case turboprop = "flight_engineType3"
    /// Reciprocating (piston) engine.
    case reciprocating = "flight_engineType4"
    /// Non-powered (glider).
    case nonpowered = "flight_engineType5"
    /// Turboshaft engine.
    case turboshaft = "flight_engineType6"
    /// Turbofan engine.
    case turbofan = "flight_engineType7"
    /// Ramjet engine.
    case ramjet = "flight_engineType8"
    /// Two-cycle piston engine.
    case twoCycle = "flight_engineType9"
    /// Four-cycle piston engine.
    case fourCycle = "flight_engineType10"
    /// Other engine type.
    case other = "flight_engineType11"
    /// Electric motor.
    case electric = "flight_engineType12"
  }

  /// Simulator and training device types.
  package enum SimulatorType: String, RecordEnum {
    /// Basic aviation training device.
    case BATD
    /// Advanced aviation training device.
    case AATD
    /// Flight training device.
    case FTD
    /// Full flight simulator.
    case FFS
  }

  /// Category and class combinations for simulators.
  package enum SimulatorCategoryClass: String, RecordEnum {
    /// Airplane single-engine land.
    case airplaneSingleEngineLand = "ASEL"
    /// Airplane single-engine sea.
    case airplaneSingleEngineSea = "ASES"
    /// Airplane multi-engine land.
    case airplaneMultiEngineLand = "AMEL"
    /// Airplane multi-engine sea.
    case airplaneMultiEngineSea = "AMES"
    /// Glider.
    case glider = "GL"
  }
}
