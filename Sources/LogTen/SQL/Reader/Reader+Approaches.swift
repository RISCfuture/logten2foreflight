import Foundation
import GRDB

extension Reader {
    private static let type = EnumQueryField<String, Entry.ApproachType>(name: "ZAPPROACH_TYPE")
    private static let runway = RawQueryField<String>(name: "ZAPPROACH_COMMENT")
    private static let airportIdent = RawQueryField<String>(name: "ZPLACE_IDENTIFIER")
    private static let airportICAO = OptionalQueryField<String>(name: "ZPLACE_ICAOID")
    private static let count = ConvertedQueryField<Int64, UInt>(name: "ZAPPROACH_QUANTITY") { UInt($0) }
    
    private static let queryFields: Array<any QueryField> = [
        type, runway, airportIdent, airportICAO, count
    ]
    
    private static let query = """
    SELECT \(queryFields.map { $0.queryName }.joined(separator: ", "))
    FROM ZAPPROACH
        INNER JOIN ZPLACE
            ON ZPLACE.Z_PK = ZAPPROACH_PLACE
    WHERE ZAPPROACH.Z_PK IN (:ids)
    """
    
    func getApproaches(in db: Database, IDs: Array<Int64>) throws -> Array<Entry.Approach> {
        var approaches = Array<Entry.Approach>()
        let IDsString = IDs.map { String($0) }.joined(separator: ",")
        
        let rows = try Row.fetchCursor(db, sql: Self.query.replacingOccurrences(of: ":ids", with: IDsString))
        while let row = try rows.next() {
            let type = try Self.type.value(from: row)
            let runway = try Self.runway.value(from: row)
            let airportIdent = try Self.airportIdent.value(from: row)
            let airportICAO = try Self.airportICAO.value(from: row)
            let count = try Self.count.value(from: row)
            
            approaches.append(.init(type: type,
                                    runway: runway,
                                    airport: airportICAO ?? airportIdent,
                                    count: count))
        }
        
        return approaches
    }
}
