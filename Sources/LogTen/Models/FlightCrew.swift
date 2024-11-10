import Foundation
@preconcurrency import GRDB
import LogTenToForeFlightMacros

@QueryObject
package struct FlightCrew: Model, Identifiable, Equatable, Hashable {

    // MARK: Columns

    @QueryField(column: "ZFLIGHTCREW_FLIGHT") package let id: Int64

    @QueryField(column: "ZFLIGHTCREW_PIC") package let PIC_ID: Int64?
    @QueryField(column: "ZFLIGHTCREW_SIC") package let SIC_ID: Int64?
    @QueryField(column: "ZFLIGHTCREW_INSTRUCTOR") package let instructorID: Int64?
    @QueryField(column: "ZFLIGHTCREW_STUDENT") package let studentID: Int64?
    @QueryField(column: "ZFLIGHTCREW_CUSTOM1") package let safetyPilotID: Int64?
    @QueryField(column: "ZFLIGHTCREW_CUSTOM2") package let examinerID: Int64?

    // MARK: Database configuration

    static package let databaseTableName = "ZFLIGHTCREW"
}


