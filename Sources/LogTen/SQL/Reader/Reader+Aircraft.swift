import Foundation
import GRDB

extension Reader {
    private static let tailNumber = RawQueryField<String>(name: "ZAIRCRAFT_AIRCRAFTID")
    private static let year = OptionalConvertedQueryField<Int64, Date>(name: "ZAIRCRAFT_YEAR") { Date(timeIntervalSince2001: $0) }
    private static let typeCode = RawQueryField<String>(name: "ZAIRCRAFTTYPE_TYPE")
    private static let make = RawQueryField<String>(name: "ZAIRCRAFTTYPE_MAKE")
    private static let model = RawQueryField<String>(name: "ZAIRCRAFTTYPE_MODEL")
    private static let category = EnumQueryField<Int64, Aircraft.Category>(name: "ZAIRCRAFTTYPE_CATEGORY")
    private static let `class` = OptionalEnumQueryField<Int64, Aircraft.Class>(name: "ZAIRCRAFTTYPE_AIRCRAFTCLASS")
    private static let complex = BoolQueryField(name: "ZAIRCRAFT_COMPLEX")
    private static let highPerformance = BoolQueryField(name: "ZAIRCRAFT_HIGHPERFORMANCE")
    private static let pressurized = BoolQueryField(name: "ZAIRCRAFT_PRESSURIZED")
    private static let technicallyAdvanced = BoolQueryField(name: "ZAIRCRAFT_TECHNICALLYADVANCED")
    private static let simulatorType = OptionalEnumQueryField<String, Aircraft.SimulatorType>(name: "ZAIRCRAFTTYPE_CUSTOMATTRIBUTE1")
    private static let simulatedAircraftType = OptionalQueryField<String>(name: "ZAIRCRAFTTYPE_CUSTOMATTRIBUTE2")
    private static let simulatedAircraftCategory = OptionalEnumQueryField<String, Aircraft.SimulatorCategoryClass>(name: "ZAIRCRAFTTYPE_CUSTOMATTRIBUTE3")
    private static let retractableGear = BoolQueryField(name: "ZAIRCRAFT_UNDERCARRIAGERETRACTABLE")
    private static let amphibious = BoolQueryField(name: "ZAIRCRAFT_UNDERCARRIAGEAMPHIB")
    private static let floats = BoolQueryField(name: "ZAIRCRAFT_UNDERCARRIAGEFLOATS")
    private static let skis = BoolQueryField(name: "ZAIRCRAFT_UNDERCARRIAGESKIS")
    private static let skids = BoolQueryField(name: "ZAIRCRAFT_UNDERCARRIAGESKIDS")
    private static let tailwheel = BoolQueryField(name: "ZAIRCRAFT_TAILWHEEL")
    private static let engineType = OptionalEnumQueryField<Int64, Aircraft.EngineType>(name: "ZAIRCRAFTTYPE_ENGINETYPE")
    private static let radial = BoolQueryField(name: "ZAIRCRAFT_RADIALENGINE")
    
    private static let queryFields: Array<any QueryField> = [
        tailNumber, year, typeCode, make, model, category, `class`, complex,
        highPerformance, pressurized, technicallyAdvanced, simulatorType,
        simulatedAircraftType, simulatedAircraftCategory, retractableGear,
        amphibious, floats, skis, skids, tailwheel, engineType, radial
    ]
    
    private static let query = """
    SELECT \(queryFields.map { $0.queryName }.joined(separator: ", "))
    FROM ZAIRCRAFT
        INNER JOIN ZAIRCRAFTTYPE
            ON ZAIRCRAFTTYPE.Z_PK = ZAIRCRAFT_AIRCRAFTTYPE
    """
    
    public func getAircraft() throws -> Array<Aircraft> {
        var aircraft = Array<Aircraft>()
        
        try dbQueue.read { db in
            let rows = try Row.fetchCursor(db, sql: Self.query)
            while let row = try rows.next() {
                let tailNumber = try Self.tailNumber.value(from: row)
                let year = try Self.year.value(from: row)
                let typeCode = try Self.typeCode.value(from: row)
                let make = try Self.make.value(from: row)
                let model = try Self.model.value(from: row)
                let category = try Self.category.value(from: row)
                let `class` = try Self.`class`.value(from: row)
                let complex = try Self.complex.value(from: row)
                let highPerformance = try Self.highPerformance.value(from: row)
                let pressurized = try Self.pressurized.value(from: row)
                let technicallyAdvanced = try Self.technicallyAdvanced.value(from: row)
                let simulatorType = try Self.simulatorType.value(from: row)
                let simulatedAircraftType = try Self.simulatedAircraftType.value(from: row)
                let simulatedAircraftCategory = try Self.simulatedAircraftCategory.value(from: row)
                let retractableGear = try Self.retractableGear.value(from: row)
                let amphibious = try Self.amphibious.value(from: row)
                let floats = try Self.floats.value(from: row)
                let skis = try Self.skis.value(from: row)
                let skids = try Self.skids.value(from: row)
                let tailwheel = try Self.tailwheel.value(from: row)
                let engineType = try Self.engineType.value(from: row)
                let radial = try Self.radial.value(from: row)
                
                aircraft.append(.init(tailNumber: tailNumber,
                                      typeCode: typeCode,
                                      make: make,
                                      model: model,
                                      yearDate: year,
                                      category: category,
                                      class: `class`,
                                      complex: complex,
                                      highPerformance: highPerformance,
                                      pressurized: pressurized,
                                      technicallyAdvanced: technicallyAdvanced,
                                      simulatorType: simulatorType,
                                      simulatedAircraftType: simulatedAircraftType,
                                      simulatedAircraftCategory: simulatedAircraftCategory,
                                      retractableGear: retractableGear,
                                      amphibious: amphibious,
                                      floats: floats,
                                      skis: skis,
                                      skids: skids,
                                      tailwheel: tailwheel,
                                      engineType: engineType,
                                      radial: radial))
            }
        }
        
        return aircraft
    }
}
