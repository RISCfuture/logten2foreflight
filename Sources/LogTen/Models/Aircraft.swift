import Foundation

package struct Aircraft {
    package private(set) var tailNumber: String

    package private(set) var typeCode: String
    package private(set) var make: String
    package private(set) var model: String
    private(set) var yearDate: Date? = nil
    package private(set) var category: Category
    package private(set) var `class`: Class? = nil
    package private(set) var complex = false
    package private(set) var highPerformance = false
    package private(set) var pressurized = false
    package private(set) var technicallyAdvanced = false

    package private(set) var simulatorType: SimulatorType? = nil
    package private(set) var simulatedAircraftType: String? = nil
    package private(set) var simulatedAircraftCategory: SimulatorCategoryClass? = nil

    package private(set) var retractableGear = false
    package private(set) var amphibious = false
    package private(set) var floats = false
    package private(set) var skis = false
    package private(set) var skids = false
    package private(set) var tailwheel = false

    package private(set) var engineType: EngineType? = nil
    package private(set) var radial = false

    package var year: UInt? {
        guard let yearDate = yearDate else { return nil }
        let components = Calendar.current.dateComponents(in: zulu, from: yearDate)
        guard let year = components.year else { return nil }
        return UInt(year)
    }

    package enum Category: Int64, RawRepresentable {
        case airplane = 124
        case glider = 554
        case simulator = 540
    }

    package enum Class: Int64, RawRepresentable {
        case airplaneSingleEngineLand = 361
        case airplaneSingleEngineSea = 349
        case airplaneMultiEngineLand = 367
        case airplaneMultiEngineSea = 355
    }

    package enum EngineType: Int64, RawRepresentable {
        case piston = 185
        case turbofan = 167
        case nonpowered = 179
    }

    package enum SimulatorType: String, RawRepresentable {
        case BATD
        case AATD
        case FTD
        case FFS
    }

    package enum SimulatorCategoryClass: String, RawRepresentable {
        case airplaneSingleEngineLand = "ASEL"
        case airplaneSingleEngineSea = "ASES"
        case airplaneMultiEngineLand = "AMEL"
        case airplaneMultiEngineSea = "AMES"
        case glider = "GL"
    }
}
