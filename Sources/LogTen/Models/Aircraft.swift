import Foundation
@preconcurrency import GRDB
import LogTenToForeFlightMacros

@QueryObject
package struct Aircraft: Model, Identifiable, Equatable, Hashable {
    
    // MARK: Columns
    
    @QueryField(column: "Z_PK") package let id: Int64
    @QueryField(column: "ZAIRCRAFT_AIRCRAFTTYPE") package let typeID: Int64
    @QueryField(column: "ZAIRCRAFT_AIRCRAFTID") package let tailNumber: String

    @QueryField(column: "ZAIRCRAFT_YEAR", convert: { Self.parseDate($0) }) let yearDate: Date?
    @QueryField(column: "ZAIRCRAFT_COMPLEX") package let complex: Bool
    @QueryField(column: "ZAIRCRAFT_HIGHPERFORMANCE") package let highPerformance: Bool
    @QueryField(column: "ZAIRCRAFT_PRESSURIZED") package let pressurized: Bool
    @QueryField(column: "ZAIRCRAFT_TECHNICALLYADVANCED") package let technicallyAdvanced: Bool

    @QueryField(column: "ZAIRCRAFT_UNDERCARRIAGERETRACTABLE") package let retractableGear: Bool
    @QueryField(column: "ZAIRCRAFT_UNDERCARRIAGEAMPHIB") package let amphibious: Bool
    @QueryField(column: "ZAIRCRAFT_UNDERCARRIAGEFLOATS") package let floats: Bool
    @QueryField(column: "ZAIRCRAFT_UNDERCARRIAGESKIS") package let skis: Bool
    @QueryField(column: "ZAIRCRAFT_UNDERCARRIAGESKIDS") package let skids: Bool
    @QueryField(column: "ZAIRCRAFT_TAILWHEEL") package let tailwheel: Bool

    @QueryField(column: "ZAIRCRAFT_RADIALENGINE") package let radial: Bool

    // MARK: Computed properties
    
    package var year: UInt? {
        guard let yearDate = yearDate else { return nil }
        let components = Calendar.current.dateComponents(in: zulu, from: yearDate)
        guard let year = components.year else { return nil }
        return UInt(year)
    }
    
    // MARK: Database configuration
    
    static package let databaseTableName = "ZAIRCRAFT"
}
