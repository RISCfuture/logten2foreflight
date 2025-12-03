/// An airport or location in a LogTen Pro logbook.
///
/// A `Place` represents a departure or destination airport. It stores both the
/// local identifier (e.g., "SFO") and the ICAO identifier (e.g., "KSFO").
package struct Place: IdentifiableRecord {

  // MARK: Properties

  /// The local airport identifier.
  package let identifier: String

  /// The unique identifier for this place (same as local identifier).
  package var id: String { identifier }

  /// The ICAO airport identifier, if available.
  package let ICAO: String?

  // MARK: Computed properties

  /// The ICAO identifier if available, otherwise the local identifier.
  package var ICAO_or_LID: String { ICAO ?? identifier }

  // MARK: Initializers

  init?(place: CNPlace?) {
    guard let place else { return nil }
    identifier = place.place_identifier
    ICAO = place.place_icaoid
  }
}
