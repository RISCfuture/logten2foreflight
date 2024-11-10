import Foundation
@preconcurrency import GRDB
import LogTenToForeFlightMacros

@QueryObject
package struct Place: Model, Identifiable, Equatable, Hashable {

    // MARK: Columns

    @QueryField(column: "Z_PK") package let id: Int64
    @QueryField(column: "ZPLACE_IDENTIFIER") package let identifier: String
    @QueryField(column: "ZPLACE_ICAOID") package let ICAO_ID: String?

    // MARK: Computed properties

    package var ICAO_or_LID: String { ICAO_ID ?? identifier }

    // MARK: Database configuration

    static package let databaseTableName = "ZPLACE"
}
