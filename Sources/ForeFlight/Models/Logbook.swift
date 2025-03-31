import Foundation

/// A ForeFlight logbook consisting of flights, aircraft, and people.
public actor Logbook {
    package var entries = [Flight]()
    package var aircraft = [Aircraft]()
    package var people = [Person]()

    package init() {}

    package func add(entry: Flight) { entries.append(entry) }
    package func add(aircraft: Aircraft) { self.aircraft.append(aircraft) }
    package func add(person: Person) { people.append(person) }
}
