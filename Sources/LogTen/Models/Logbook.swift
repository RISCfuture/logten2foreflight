import Foundation

public actor Logbook {
    
    // MARK: Data
    
    package let aircraft: Set<Aircraft>
    private let aircraftTypes: Dictionary<Int64, AircraftType>
    private let approaches: Dictionary<Int64, Approach>
    package let flights: Set<Flight>
    private let flightApproaches: Dictionary<Int64, FlightApproaches>
    private let flightCrew: Dictionary<Int64, FlightCrew>
    private let flightPassengers: Dictionary<Int64, FlightPassengers>
    package let people: Set<Person>
    private let places: Dictionary<Int64, Place>

    private var aircraftByID: Dictionary<Int64, Aircraft> {
        aircraft.reduce(into: [:]) { $0[$1.id] = $1 }
    }
    
    private var peopleByID: Dictionary<Int64, Person> {
        people.reduce(into: [:]) { $0[$1.id] = $1 }
    }
    
    // MARK: Initializers
    
    init(aircraft: Array<Aircraft>,
         aircraftTypes: Array<AircraftType>,
         approaches: Array<Approach>,
         flights: Array<Flight>,
         flightApproaches: Array<FlightApproaches>,
         flightCrew: Array<FlightCrew>,
         flightPassengers: Array<FlightPassengers>,
         people: Array<Person>,
         places: Array<Place>) {
        self.aircraft = Set(aircraft)
        self.aircraftTypes = aircraftTypes.reduce(into: [:]) { $0[$1.id] = $1 }
        self.approaches = approaches.reduce(into: [:]) { $0[$1.id] = $1 }
        self.flights = Set(flights)
        self.flightApproaches = flightApproaches.reduce(into: [:]) { $0[$1.id] = $1 }
        self.flightCrew = flightCrew.reduce(into: [:]) { $0[$1.id] = $1 }
        self.flightPassengers = flightPassengers.reduce(into: [:]) { $0[$1.id] = $1 }
        self.people = Set(people)
        self.places = places.reduce(into: [:]) { $0[$1.id] = $1 }
    }
    
    // MARK: Associations
    
    package func type(for aircraft: Aircraft) -> AircraftType { aircraftTypes[aircraft.typeID]! }
    package func aircraft(for flight: Flight) -> Aircraft? {
        guard let aircraftID = flight.aircraftID else { return nil }
        return aircraftByID[aircraftID]
    }
    
    package func origin(for flight: Flight) -> Place? {
        guard let fromID = flight.originID else { return nil }
        return places[fromID]
    }
    
    package func destination(for flight: Flight) -> Place? {
        guard let toID = flight.destinationID else { return nil }
        return places[toID]
    }
    
    package func approaches(for flight: Flight) -> Set<Approach> {
        guard let approaches = flightApproaches[flight.id]?.approaches else { return Set() }
        return Set(approaches.compactMap { self.approaches[$0] })
    }
    
    package func passengers(for flight: Flight) -> Set<Person> {
        guard let passengers = flightPassengers[flight.id]?.passengers else { return Set() }
        return Set(passengers.compactMap { self.peopleByID[$0] })
    }
    
    package func PIC(for flight: Flight) -> Person? {
        guard let crew = flightCrew[flight.id],
              let personID = crew.PIC_ID else { return nil }
        return peopleByID[personID]
    }
    
    package func SIC(for flight: Flight) -> Person? {
        guard let crew = flightCrew[flight.id],
              let personID = crew.SIC_ID else { return nil }
        return peopleByID[personID]
    }
    
    package func instructor(for flight: Flight) -> Person? {
        guard let crew = flightCrew[flight.id],
              let personID = crew.instructorID else { return nil }
        return peopleByID[personID]
    }
    
    package func student(for flight: Flight) -> Person? {
        guard let crew = flightCrew[flight.id],
              let personID = crew.studentID else { return nil }
        return peopleByID[personID]
    }
    
    package func safetyPilot(for flight: Flight) -> Person? {
        guard let crew = flightCrew[flight.id],
              let personID = crew.safetyPilotID else { return nil }
        return peopleByID[personID]
    }
    
    package func examiner(for flight: Flight) -> Person? {
        guard let crew = flightCrew[flight.id],
              let personID = crew.examinerID else { return nil }
        return peopleByID[personID]
    }
    
    package func place(for approach: Approach) -> Place? {
        guard let placeID = approach.placeID else { return nil }
        return places[placeID]
    }
}
