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

  /// Whether this airport has an operating control tower. Meaningful only
  /// when ``toweredKnown`` is `true`; when the user hasn't configured a
  /// "Towered" custom attribute on places, this is always `false` and
  /// callers should treat it as unknown.
  package let towered: Bool

  /// Whether ``towered`` reflects real data (custom attribute is configured)
  /// vs. a default. When `false`, towered/non-towered attribution should be
  /// skipped.
  package let toweredKnown: Bool

  // MARK: Computed properties

  /// The ICAO identifier if available, otherwise the local identifier.
  package var ICAO_or_LID: String { ICAO ?? identifier }

  // MARK: Initializers

  init?(place: CNPlace?, toweredProperty: KeyPath<CNPlace, String?>?) {
    guard let place else { return nil }
    identifier = place.place_identifier
    ICAO = place.place_icaoid
    if let toweredProperty {
      toweredKnown = true
      towered = Self.isTruthy(place[keyPath: toweredProperty])
    } else {
      toweredKnown = false
      towered = false
    }
  }

  private static func isTruthy(_ value: String?) -> Bool {
    guard let value else { return false }
    let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    guard !trimmed.isEmpty else { return false }
    switch trimmed {
      case "0", "false", "no", "n": return false
      default: return true
    }
  }
}
