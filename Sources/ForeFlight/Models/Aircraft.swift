import Foundation

public struct Aircraft {
    public private(set) var tailNumber: String?
    public private(set) var simulatorType: SimulatorType
    public private(set) var typeCode: String?
    public private(set) var year: UInt?
    public private(set) var make: String
    public private(set) var model: String
    public private(set) var category: Category
    public private(set) var `class`: Class?
    public private(set) var gearType: GearType?
    public private(set) var engineType: EngineType?
    public private(set) var complex: Bool
    public private(set) var highPerformance: Bool
    public private(set) var pressurized: Bool
    public private(set) var technicallyAdvanced: Bool
    
    static let fieldMapping: Dictionary<String, PartialKeyPath<Self>> = [
        "AircraftID": \.tailNumber,
        "EquipmentType": \.simulatorType,
        "TypeCode": \.typeCode,
        "Year": \.year,
        "Make": \.make,
        "Model": \.model,
        "Category": \.category,
        "Class": \.class,
        "GearType": \.gearType,
        "EngineType": \.engineType,
        "Complex": \.complex,
        "HighPerformance": \.highPerformance,
        "Pressurized": \.pressurized,
        "TAA": \.technicallyAdvanced
    ]
    
    public init(tailNumber: String,
                simulatorType: SimulatorType,
                typeCode: String?,
                year: UInt? = nil,
                make: String,
                model: String,
                category: Category,
                class: Class? = nil,
                gearType: GearType? = nil,
                engineType: EngineType? = nil,
                complex: Bool = false,
                highPerformance: Bool = false,
                pressurized: Bool = false,
                technicallyAdvanced: Bool = false) {
        self.tailNumber = tailNumber
        self.simulatorType = simulatorType
        self.typeCode = typeCode
        self.year = year
        self.make = make
        self.model = model
        self.category = category
        self.class = `class`
        self.gearType = gearType
        self.engineType = engineType
        self.complex = complex
        self.highPerformance = highPerformance
        self.pressurized = pressurized
        self.technicallyAdvanced = technicallyAdvanced
    }
    
    
    public enum GearType: String {
        case amphibian = "AM"
        case floats = "FL"
        case skids = "Skids"
        case skis = "Skis"
        case fixedConventional = "FC"
        case fixedTricycle = "FT"
        case retractableConventional = "RC"
        case retractableTricycle = "RT"
    }
    
    public enum EngineType: String {
        case piston = "Piston"
        case turbofan = "Turbofan"
        case radial = "Radial"
        case diesel = "Diesel"
        case nonpowered = "Non-Powered"
    }
    
    public enum SimulatorType: String {
        case aircraft
        case FFS = "ffs"
        case FTD = "ftd"
        case AATD = "aatd"
        case BATD = "batd"
    }
    
    public enum Category: String {
        case airplane = "Airplane"
        case rotorcraft = "Rotorcraft"
        case glider = "Glider"
        case lighterThanAir = "Lighter Than Air"
        case poweredLift = "Powered Lift"
        case poweredParachute = "Powered Parachute"
        case weightShiftControl = "Weight-Shift-Control"
        case simulator = "Simulator"
    }
    
    public enum Class: String {
        case singleEngineLand = "ASEL"
        case multiEngineLand = "AMEL"
        case singleEngineSea = "ASES"
        case multiEngineSea = "AMES"
        case helicopter = "RH"
        case gyroplane = "RG"
        case glider = "Glider"
        case airship = "LA"
        case balloon = "LB"
        case poweredLift = "Powered Lift"
        case poweredParachuteLand = "PL"
        case poweredParachuteSea = "PS"
        case weightShiftControlLand = "WL"
        case weightShiftCOntrolSea = "WS"
        case FFS = "FFS"
        case FTD = "FTD"
        case ATD = "ATD"
    }
}
