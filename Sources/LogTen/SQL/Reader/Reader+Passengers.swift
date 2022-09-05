import Foundation
import GRDB

extension Reader {
    private static let queryFields = (1...numPaxFields).map { RawQueryField<Int64?>(name: "ZFLIGHTPASSENGERS_PAX\($0)") }
    
    private static let query = """
    SELECT \(queryFields.map { $0.queryName }.joined(separator: ", "))
    FROM ZFLIGHTPASSENGERS
    WHERE ZFLIGHTPASSENGERS_FLIGHT = :flightID
    """
    
    func getPassengerIDs(in db: Database, for flightID: Int64) throws -> Set<Int64> {
        var people = Set<Int64>()
        
        let rows = try Row.fetchCursor(db, sql: Self.query, arguments: ["flightID": flightID])
        while let row = try rows.next() {
            for field in Self.queryFields {
                guard let paxID = try field.value(from: row) else { continue }
                people.insert(paxID)
            }
        }
        
        return people
    }
}
