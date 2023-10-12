import Foundation
import GRDB

package class Reader {
    package let url: URL
    let dbQueue: DatabaseQueue
    
    package init(url: URL) throws {
        self.url = url
        dbQueue = try DatabaseQueue(path: url.path)
    }
    
    package func read() throws -> Logbook {
        let people = try getPeople()
        return .init(entries: try getEntries(people: people),
                     aircraft: try getAircraft(),
                     people: Array(people.values))
    }
}
