import Foundation
@preconcurrency import GRDB
import LogTenToForeFlightMacros

@QueryObject
package struct AircraftType: Model, Identifiable, Equatable, Hashable {
    
    // MARK: Columns
    
    @QueryField(column: "Z_PK")
    package let id: Int64

    @QueryField(column: "ZAIRCRAFTTYPE_TYPE")
    package let typeCode: String
    @QueryField(column: "ZAIRCRAFTTYPE_MAKE")
    package let make: String
    @QueryField(column: "ZAIRCRAFTTYPE_MODEL")
    package let model: String
    @QueryField(column: "ZAIRCRAFTTYPE_CATEGORY", convert: { Category(from: $0)! })
    package let category: Category
    @QueryField(column: "ZAIRCRAFTTYPE_AIRCRAFTCLASS", convert: { Class(from: $0) })
    package let `class`: Class?

    @QueryField(column: "ZAIRCRAFTTYPE_CUSTOMATTRIBUTE1", convert: { SimulatorType(from: $0) })
    package let simulatorType: SimulatorType?
    @QueryField(column: "ZAIRCRAFTTYPE_CUSTOMATTRIBUTE2")
    package let simulatedAircraftType: String?
    @QueryField(column: "ZAIRCRAFTTYPE_CUSTOMATTRIBUTE3", convert: { SimulatorCategoryClass(from: $0) })
    package let simulatedAircraftCategory: SimulatorCategoryClass?

    @QueryField(column: "ZAIRCRAFTTYPE_ENGINETYPE", convert: { EngineType(from: $0) })
    package let engineType: EngineType?

    // MARK: Database configuration
    
    static package let databaseTableName = "ZAIRCRAFTTYPE"
    
    // MARK: Enums
    
    package enum Category: Int64, RecordEnum {
        case airplane = 579
        case glider = 568
        case simulator = 562
    }
    
    package enum Class: Int64, RecordEnum {
        case airplaneSingleEngineLand = 359
        case airplaneSingleEngineSea = 348
        case airplaneMultiEngineLand = 364
        case airplaneMultiEngineSea = 354
    }
    
    package enum EngineType: Int64, RecordEnum {
        case piston = 641
        case turbofan = 617
        case nonpowered = 631
    }
    
    package enum SimulatorType: String, RecordEnum {
        case BATD
        case AATD
        case FTD
        case FFS
    }
    
    package enum SimulatorCategoryClass: String, RecordEnum {
        case airplaneSingleEngineLand = "ASEL"
        case airplaneSingleEngineSea = "ASES"
        case airplaneMultiEngineLand = "AMEL"
        case airplaneMultiEngineSea = "AMES"
        case glider = "GL"
    }
}
