import Foundation
@preconcurrency import GRDB
import LogTenToForeFlightMacros

@QueryObject
package struct FlightApproaches: Model, Identifiable, Equatable, Hashable {
    
    // MARK: Columns

    @QueryField(column: "ZFLIGHTAPPROACHES_FLIGHT")
    package let id: Int64
    @RepeatingQueryField(count: 9, prefix: "approach", columnPrefix: "ZFLIGHTAPPROACHES_APPROACH")
    package var approaches: Array<Int64>

    // MARK: Database configuration
    
    static package let databaseTableName = "ZFLIGHTAPPROACHES"
}
