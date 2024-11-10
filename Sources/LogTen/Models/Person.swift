import Foundation
@preconcurrency import GRDB
import LogTenToForeFlightMacros

@QueryObject
package struct Person: Model, Identifiable, Equatable, Hashable {
    
    // MARK: Columns
    
    @QueryField(column: "Z_PK") package let id: Int64
    @QueryField(column: "ZPERSON_NAME") package let name: String
    @QueryField(column: "ZPERSON_EMAIL") package let email: String?
    @QueryField(column: "ZPERSON_ISME") package let isMe: Bool

    // MARK: Database configuration
    
    static package let databaseTableName = "ZPERSON"
}
