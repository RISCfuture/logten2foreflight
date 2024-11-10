@preconcurrency import GRDB
import LogTenToForeFlightMacros

@QueryObject
package struct FlightPassengers: Model, Identifiable, Equatable, Hashable {
    
    // MARK: Columns
    
    @QueryField(column: "ZFLIGHTPASSENGERS_FLIGHT") package let id: Int64
    @RepeatingQueryField(count: 20, prefix: "passenger", columnPrefix: "ZFLIGHTPASSENGERS_PAX")
    var passengers: Array<Int64>
    
    // MARK: Database configuration
    
    static package let databaseTableName = "ZFLIGHTPASSENGERS"
}
