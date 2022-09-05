import Foundation

public struct Aircraft {
    public private(set) var tailNumber: String
    
    public private(set) var typeCode: String
    public private(set) var make: String
    public private(set) var model: String
    private(set) var yearDate: Date? = nil
    public private(set) var category: Category
    public private(set) var `class`: Class? = nil
    public private(set) var complex = false
    public private(set) var highPerformance = false
    public private(set) var pressurized = false
    public private(set) var technicallyAdvanced = false
    
    public private(set) var simulatorType: SimulatorType? = nil
    public private(set) var simulatedAircraftType: String? = nil
    public private(set) var simulatedAircraftCategory: SimulatorCategoryClass? = nil
    
    public private(set) var retractableGear = false
    public private(set) var amphibious = false
    public private(set) var floats = false
    public private(set) var skis = false
    public private(set) var skids = false
    public private(set) var tailwheel = false
    
    public private(set) var engineType: EngineType? = nil
    public private(set) var radial = false
    
    public var year: UInt? {
        guard let yearDate = yearDate else { return nil }
        let components = Calendar.current.dateComponents(in: zulu, from: yearDate)
        guard let year = components.year else { return nil }
        return UInt(year)
    }
    
    public enum Category: Int64, RawRepresentable {
        case airplane = 210
        case glider = 581
        case simulator = 100
    }
    
    public enum Class: Int64, RawRepresentable {
        case airplaneSingleEngineLand = 321
        case airplaneSingleEngineSea = 146
        case airplaneMultiEngineLand = 680
        case airplaneMultiEngineSea = 97
    }
    
    public enum EngineType: Int64, RawRepresentable {
        case piston = 244
        case turbofan = 676
        case nonpowered = 507
    }
    
    public enum SimulatorType: String, RawRepresentable {
        case BATD
        case AATD
        case FTD
        case FFS
    }
    
    public enum SimulatorCategoryClass: String, RawRepresentable {
        case airplaneSingleEngineLand = "ASEL"
        case airplaneSingleEngineSea = "ASES"
        case airplaneMultiEngineLand = "AMEL"
        case airplaneMultiEngineSea = "AMES"
        case glider = "GL"
    }
}
