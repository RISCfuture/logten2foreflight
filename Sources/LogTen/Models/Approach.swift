/// An instrument approach flown during a flight.
///
/// An `Approach` records the details of an instrument approach, including the
/// airport, type of approach, runway, and number of approaches flown.
package struct Approach: Record {

  // MARK: Properties

  /// The airport where the approach was flown.
  package let place: Place?

  /// The type of approach (ILS, VOR, RNAV, etc.).
  package let type: ApproachType?

  /// The runway identifier.
  package let runway: String?

  /// The number of approaches of this type flown.
  package let count: UInt?

  // MARK: Initializers

  init(approach: CNApproach) {
    place = .init(place: approach.approach_place)
    type = {
      guard let type = approach.approach_type else { return nil }
      return .init(rawValue: type)
    }()
    runway = approach.approach_comment
    count = approach.approach_quantity?.uintValue
  }

  // MARK: Enums

  /// Types of instrument approaches as defined in LogTen Pro.
  package enum ApproachType: String, RecordEnum {
    /// Ground controlled approach.
    case GCA
    /// GBAS landing system.
    case GLS
    /// GPS/GNSS approach.
    case GPS_GNSS = "GPS/GNSS"
    /// Instrument guidance system.
    case IGS
    /// Instrument landing system.
    case ILS
    /// Joint precision approach and landing system.
    case JPALS
    /// Ground-based augmentation system.
    case GBAS
    /// Lateral navigation approach.
    case LNAV
    /// Lateral/vertical navigation approach.
    case LNAV_VNAV = "LNAV/VNAV"
    /// Localizer performance with vertical guidance.
    case LPV
    /// Microwave landing system.
    case MLS
    /// Precision approach radar.
    case PAR
    /// Wide area augmentation system approach.
    case WAAS
    /// Airborne radar approach.
    case ARA
    /// Contact approach.
    case contact = "CONTACT"
    /// DME arc approach.
    case DME
    /// Legacy GPS approach.
    case GPS
    /// Integrated approach navigation.
    case IAN
    /// Localizer type directional aid.
    case LDA
    /// Localizer approach.
    case LOC
    /// Localizer back course.
    case LOC_BC = "LOC BC"
    /// Localizer with DME.
    case LOC_DME = "LOC/DME"
    /// Localizer performance.
    case LP
    /// Non-directional beacon approach.
    case NDB
    /// Area navigation approach.
    case RNAV
    /// Required navigation performance approach.
    case RNP
    /// Simplified directional facility.
    case SDF
    /// Surveillance radar approach.
    case SRA
    /// Tactical air navigation approach.
    case TACAN
    /// Visual approach.
    case visual = "VISUAL"
    /// VOR approach.
    case VOR
    /// VOR with DME approach.
    case VOR_DME = "VOR/DME"
  }
}
