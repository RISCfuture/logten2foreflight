import Foundation

/// A specific aircraft or simulator in a LogTen Pro logbook.
///
/// An `Aircraft` represents a physical aircraft (identified by tail number) or a
/// simulator device. It contains type information and equipment flags.
package struct Aircraft: IdentifiableRecord {

  // MARK: Properties

  /// The aircraft type information.
  package let type: AircraftType

  /// The aircraft registration (tail number) or simulator identifier.
  package let tailNumber: String

  /// The unique identifier for this aircraft (same as tail number).
  package var id: String { tailNumber }

  /// The year the aircraft was manufactured.
  package let year: UInt?

  /// Whether the aircraft meets the definition of a complex aircraft under
  /// the user's primary regulatory regime (interpreted per
  /// `--default-regulations`).
  package let complex: Bool

  /// Whether the aircraft meets the definition of a high-performance aircraft
  /// under the user's primary regulatory regime.
  package let highPerformance: Bool

  /// Whether the aircraft is pressurized.
  package let pressurized: Bool

  /// Whether the aircraft qualifies as technically advanced.
  package let technicallyAdvanced: Bool

  /// Whether the aircraft has retractable landing gear.
  package let retractableGear: Bool

  /// Whether the aircraft is amphibious.
  package let amphibious: Bool

  /// Whether the aircraft has floats.
  package let floats: Bool

  /// Whether the aircraft has skis.
  package let skis: Bool

  /// Whether the aircraft has skids.
  package let skids: Bool

  /// Whether the aircraft is a tailwheel (conventional gear) aircraft.
  package let tailwheel: Bool

  /// Whether the aircraft has a radial engine.
  package let radial: Bool

  /// Whether the aircraft has a diesel engine (from custom LogTen field).
  package let diesel: Bool

  /// Optional user override for FAA complex (from custom LogTen field).
  package let faaComplexOverride: Bool?

  /// Optional user override for EASA complex (from custom LogTen field).
  package let easaComplexOverride: Bool?

  /// Optional user override for FAA high-performance (from custom LogTen field).
  package let faaHighPerformanceOverride: Bool?

  /// Optional user override for EASA SPHP (from custom LogTen field).
  package let easaSPHPOverride: Bool?

  // MARK: Initializers

  init(
    aircraft: CNAircraft,
    typeCodeProperty: KeyPath<CNAircraftType, String?>,
    simTypeProperty: KeyPath<CNAircraftType, String?>,
    dieselProperty: KeyPath<CNAircraft, Bool>,
    faaComplexProperty: KeyPath<CNAircraft, Bool>?,
    easaComplexProperty: KeyPath<CNAircraft, Bool>?,
    faaHighPerformanceProperty: KeyPath<CNAircraft, Bool>?,
    easaSPHPProperty: KeyPath<CNAircraft, Bool>?,
    categoryTitles: [String: String],
    classTitles: [String: String],
    engineTypeTitles: [String: String],
    easaEquipTypeProperty: KeyPath<CNAircraftType, String?>?
  ) {
    type = .init(
      aircraftType: aircraft.aircraft_aircraftType,
      typeCodeProperty: typeCodeProperty,
      simTypeProperty: simTypeProperty,
      categoryTitles: categoryTitles,
      classTitles: classTitles,
      engineTypeTitles: engineTypeTitles,
      easaEquipTypeProperty: easaEquipTypeProperty
    )
    tailNumber = aircraft.aircraft_aircraftID
    year = {
      guard let year = aircraft.aircraft_year else { return nil }
      let components = Calendar.current.dateComponents(in: zulu, from: year)
      guard let year = components.year else { return nil }
      return UInt(year)
    }()
    complex = aircraft.aircraft_complex
    highPerformance = aircraft.aircraft_highPerformance
    pressurized = aircraft.aircraft_pressurized
    technicallyAdvanced = aircraft.aircraft_technicallyAdvanced
    retractableGear = aircraft.aircraft_undercarriageRetractable
    amphibious = aircraft.aircraft_undercarriageAmphib
    floats = aircraft.aircraft_undercarriageFloats
    skis = aircraft.aircraft_undercarriageSkis
    skids = aircraft.aircraft_undercarriageSkids
    tailwheel = aircraft.aircraft_tailwheel
    radial = aircraft.aircraft_radialEngine
    diesel = aircraft[keyPath: dieselProperty]
    faaComplexOverride = faaComplexProperty.map { aircraft[keyPath: $0] }
    easaComplexOverride = easaComplexProperty.map { aircraft[keyPath: $0] }
    faaHighPerformanceOverride = faaHighPerformanceProperty.map { aircraft[keyPath: $0] }
    easaSPHPOverride = easaSPHPProperty.map { aircraft[keyPath: $0] }
  }
}
