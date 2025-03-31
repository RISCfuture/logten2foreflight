import Foundation

/// A LogTen logbook consisting of flights, aircraft, and people.
public actor Logbook {

    // MARK: Data

    package let aircraft: [Aircraft]
    package let flights: [Flight]
    package let people: [Person]

    // MARK: Initializers

    init(aircraft: [Aircraft],
         flights: [Flight],
         people: [Person]) {
        self.aircraft = Array(aircraft)
        self.flights = Array(flights)
        self.people = Array(people)
    }
}
