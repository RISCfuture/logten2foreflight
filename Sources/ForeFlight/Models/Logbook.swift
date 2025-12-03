import Foundation

/// A ForeFlight logbook containing flights, aircraft, and people.
///
/// The `Logbook` actor provides thread-safe storage for ForeFlight logbook data.
/// Use the ``libLogTenToForeFlight/Converter`` to create a logbook from LogTen Pro
/// data, or populate it directly for testing.
public actor Logbook {
  /// All flight entries in the logbook.
  package var entries = [Flight]()

  /// All aircraft in the logbook.
  package var aircraft = [Aircraft]()

  /// All people (crew and passengers) referenced in the logbook.
  package var people = [Person]()

  /// Creates an empty logbook.
  package init() {}

  /// Adds a flight entry to the logbook.
  /// - Parameter entry: The flight to add.
  package func add(entry: Flight) { entries.append(entry) }

  /// Adds an aircraft to the logbook.
  /// - Parameter aircraft: The aircraft to add.
  package func add(aircraft: Aircraft) { self.aircraft.append(aircraft) }

  /// Adds a person to the logbook.
  /// - Parameter person: The person to add.
  package func add(person: Person) { people.append(person) }
}
