import Foundation
import GRDB

public class Reader {
    public let url: URL
    let dbQueue: DatabaseQueue
    
    public init(url: URL) throws {
        self.url = url
        dbQueue = try DatabaseQueue(path: url.path)
    }
    
    public func read() throws -> Logbook {
        let people = try getPeople()
        return .init(entries: try getEntries(people: people),
                     aircraft: try getAircraft(),
                     people: Array(people.values))
    }
}
