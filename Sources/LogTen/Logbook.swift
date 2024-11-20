import Foundation

public actor Logbook {
    
    // MARK: Data
    
    package let aircraft: Array<Aircraft>
    package let flights: Array<Flight>
    package let people: Array<Person>
    
    
    // MARK: Initializers
    
    init(aircraft: Array<Aircraft>,
         flights: Array<Flight>,
         people: Array<Person>) {
        self.aircraft = Array(aircraft)
        self.flights = Array(flights)
        self.people = Array(people)
    }
}
