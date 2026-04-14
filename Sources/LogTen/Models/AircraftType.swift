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

  /// The aircraft category, resolved by matching the LogTen category slot's
  /// title (not its slot index).
  package let category: Category

  /// The aircraft class, if applicable, resolved by title.
  package let `class`: Class?

  /// The simulator type, if this is a training device.
  package let simulatorType: SimulatorType?

  /// The category and class of aircraft being simulated.
  package let simulatorCategoryClass: SimulatorCategoryClass?

  /// The engine type, resolved by title.
  package let engineType: EngineType?

  /// Whether this aircraft type requires a multi-pilot crew.
  package let multiPilot: Bool

  /// Optional user override for FAA equipType (aircraft type custom attribute).
  package let faaEquipTypeOverride: String?

  /// Optional user override for EASA equipType (aircraft type custom attribute).
  package let easaEquipTypeOverride: String?

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
    simCategoryProperty: KeyPath<CNAircraftType, String?>,
    categoryTitles: [String: String],
    classTitles: [String: String],
    engineTypeTitles: [String: String],
    faaEquipTypeProperty: KeyPath<CNAircraftType, String?>?,
    easaEquipTypeProperty: KeyPath<CNAircraftType, String?>?
  ) {
    id = aircraftType.aircraftType_type
    typeCode = aircraftType[keyPath: typeCodeProperty] ?? aircraftType.aircraftType_type
    make = aircraftType.aircraftType_make
    model = aircraftType.aircraftType_model

    let categoryKey = aircraftType.aircraftType_category.logTenProperty_key
    category = Category.from(title: categoryTitles[categoryKey])

    `class` = {
      guard let key = aircraftType.aircraftType_aircraftClass?.logTenProperty_key else {
        return nil
      }
      return Class.from(title: classTitles[key])
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
      return EngineType.from(title: engineTypeTitles[key])
    }()
    multiPilot = aircraftType.aircraftType_multiPilot
    faaEquipTypeOverride = faaEquipTypeProperty.flatMap { aircraftType[keyPath: $0] }
    easaEquipTypeOverride = easaEquipTypeProperty.flatMap { aircraftType[keyPath: $0] }
  }

  // MARK: Enums

  /// Aircraft categories recognized by the converter.
  ///
  /// Resolved by matching the LogTen category slot's display title against a
  /// case-insensitive, hyphen-tolerant list of known names. Unknown titles
  /// fall back to `.other`.
  package enum Category: String, RecordEnum {
    case airplane
    case rotorcraft
    case poweredLift
    case glider
    case lighterThanAir
    case simulator
    case trainingDevice
    case PC_ATD
    case poweredParachute
    case weightShiftControl
    case UAV
    case ultralight
    case other

    static func from(title: String?) -> Self {
      let normalized = (title ?? "").normalizedForMatching
      switch normalized {
        case "airplane": return .airplane
        case "rotorcraft": return .rotorcraft
        case "poweredlift": return .poweredLift
        case "glider": return .glider
        case "lighterthanair": return .lighterThanAir
        case "simulator": return .simulator
        case "trainingdevice": return .trainingDevice
        case "pcatd", "pc-atd", "pc_atd": return .PC_ATD
        case "poweredparachute", "power-parachute", "powerparachute": return .poweredParachute
        case "weightshiftcontrol": return .weightShiftControl
        case "uav": return .UAV
        case "ultralight": return .ultralight
        default: return .other
      }
    }
  }

  /// Aircraft classes recognized by the converter, resolved by title.
  package enum Class: String, RecordEnum {
    case multiEngineLand
    case singleEngineLand
    case multiEngineSea
    case singleEngineSea
    case other
    case gyroplane
    case airship
    case freeBalloon
    case helicopter

    static func from(title: String?) -> Self? {
      let normalized = (title ?? "").normalizedForMatching
      switch normalized {
        case "multiengineland": return .multiEngineLand
        case "singleengineland": return .singleEngineLand
        case "multienginesea": return .multiEngineSea
        case "singleenginesea": return .singleEngineSea
        case "other": return .other
        case "gyroplane": return .gyroplane
        case "airship": return .airship
        case "freeballoon", "balloon": return .freeBalloon
        case "helicopter": return .helicopter
        default: return nil
      }
    }
  }

  /// Engine types recognized by the converter, resolved by title.
  package enum EngineType: String, RecordEnum {
    case jet
    case turbine
    case turboprop
    case reciprocating
    case nonpowered
    case turboshaft
    case turbofan
    case ramjet
    case twoCycle
    case fourCycle
    case other
    case electric

    static func from(title: String?) -> Self? {
      let normalized = (title ?? "").normalizedForMatching
      switch normalized {
        case "jet": return .jet
        case "turbine": return .turbine
        case "turboprop": return .turboprop
        case "reciprocating", "piston": return .reciprocating
        case "nonpowered": return .nonpowered
        case "turboshaft": return .turboshaft
        case "turbofan": return .turbofan
        case "ramjet": return .ramjet
        case "2cycle", "twocycle": return .twoCycle
        case "4cycle", "fourcycle": return .fourCycle
        case "other": return .other
        case "electric": return .electric
        default: return nil
      }
    }
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

extension String {
  /// Lowercased, with spaces, hyphens, and underscores removed. Used for loose
  /// matching of user-editable titles (e.g., "Multi-Engine Land" → "multiengineland").
  fileprivate var normalizedForMatching: String {
    lowercased()
      .replacingOccurrences(of: " ", with: "")
      .replacingOccurrences(of: "-", with: "")
      .replacingOccurrences(of: "_", with: "")
  }
}
