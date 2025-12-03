import Foundation

/// A LogTen Pro logbook containing flights, aircraft, and people.
///
/// The `Logbook` actor provides thread-safe access to all records loaded from
/// a LogTen Pro Core Data store. Use ``Reader`` to create a logbook instance.
public actor Logbook {

  // MARK: Data

  /// All aircraft in the logbook.
  package let aircraft: [Aircraft]

  /// All flight records in the logbook.
  package let flights: [Flight]

  /// All people (crew members and passengers) in the logbook.
  package let people: [Person]

  // MARK: Initializers

  init(
    aircraft: [Aircraft],
    flights: [Flight],
    people: [Person]
  ) {
    self.aircraft = Array(aircraft)
    self.flights = Array(flights)
    self.people = Array(people)
  }
}
