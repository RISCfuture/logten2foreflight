import Foundation
@preconcurrency import GRDB

package actor Reader {
    package let url: URL
    let dbQueue: DatabaseQueue

    package init(url: URL) throws {
        self.url = url
        dbQueue = try DatabaseQueue(path: url.path)
    }

    package func read() async throws -> Logbook {
        let aircraft = try await dbQueue.read { try Aircraft.fetchAll($0) }
        let aircraftTypes = try await dbQueue.read { try AircraftType.fetchAll($0) }
        let approaches = try await dbQueue.read { try Approach.fetchAll($0) }
        let flights = try await dbQueue.read { try Flight.fetchAll($0) }
        let flightApproaches = try await dbQueue.read { try FlightApproaches.fetchAll($0) }
        let flightCrew = try await dbQueue.read { try FlightCrew.fetchAll($0) }
        let flightPassengers = try await dbQueue.read { try FlightPassengers.fetchAll($0) }
        let people = try await dbQueue.read { try Person.fetchAll($0) }
        let places = try await dbQueue.read { try Place.fetchAll($0) }

        return Logbook(aircraft: aircraft,
                       aircraftTypes: aircraftTypes,
                       approaches: approaches,
                       flights: flights,
                       flightApproaches: flightApproaches,
                       flightCrew: flightCrew,
                       flightPassengers: flightPassengers,
                       people: people,
                       places: places)
    }
}
