import Foundation

public actor Logbook {
    package var entries = Array<Flight>()
    package var aircraft = Array<Aircraft>()
    package var people = Array<Person>()
    
    package init() {}
    
    package func add(entry: Flight) { entries.append(entry) }
    package func add(aircraft: Aircraft) { self.aircraft.append(aircraft) }
    package func add(person: Person) { people.append(person) }
}
