import Foundation

package struct Aircraft {
    static var fieldMapping: [String: PartialKeyPath<Aircraft>] {
        [
            "AircraftID": \Aircraft.tailNumber,
            "EquipmentType": \Aircraft.simulatorType,
            "TypeCode": \Aircraft.typeCode,
            "Year": \Aircraft.year,
            "Make": \Aircraft.make,
            "Model": \Aircraft.model,
            "Category": \Aircraft.category,
            "Class": \Aircraft.class,
            "GearType": \Aircraft.gearType,
            "EngineType": \Aircraft.engineType,
            "Complex": \Aircraft.complex,
            "HighPerformance": \Aircraft.highPerformance,
            "Pressurized": \Aircraft.pressurized,
            "TAA": \Aircraft.technicallyAdvanced
        ]
    }

    package private(set) var tailNumber: String?
    package private(set) var simulatorType: SimulatorType
    package private(set) var typeCode: String?
    package private(set) var year: UInt?
    package private(set) var make: String
    package private(set) var model: String
    package private(set) var category: Category
    package private(set) var `class`: Class?
    package private(set) var gearType: GearType?
    package private(set) var engineType: EngineType?
    package private(set) var complex: Bool
    package private(set) var highPerformance: Bool
    package private(set) var pressurized: Bool
    package private(set) var technicallyAdvanced: Bool

    package init(tailNumber: String,
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

    package enum GearType: String {
        case amphibian = "AM"
        case floats = "FL"
        case skids = "Skids"
        case skis = "Skis"
        case fixedConventional = "FC"
        case fixedTricycle = "FT"
        case retractableConventional = "RC"
        case retractableTricycle = "RT"
    }

    package enum EngineType: String {
        case diesel = "Diesel"
        case electric = "Electric"
        case nonpowered = "Non-Powered"
        case piston = "Piston"
        case radial = "Radial"
        case turbofan = "Turbofan"
        case turbojet = "Turbojet"
        case turboprop = "Turboprop"
        case turboshaft = "Turboshaft"
    }

    package enum SimulatorType: String {
        case aircraft
        case FFS = "ffs"
        case FTD = "ftd"
        case AATD = "aatd"
        case BATD = "batd"
    }

    package enum Category: String {
        case airplane = "Airplane"
        case rotorcraft = "Rotorcraft"
        case glider = "Glider"
        case lighterThanAir = "Lighter Than Air"
        case poweredLift = "Powered Lift"
        case poweredParachute = "Powered Parachute"
        case weightShiftControl = "Weight-Shift-Control"
        case simulator = "Simulator"
    }

    package enum Class: String {
        case singleEngineLand = "ASEL"
        case multiEngineLand = "AMEL"
        case singleEngineSea = "ASES"
        case multiEngineSea = "AMES"
        case helicopter = "RH"
        case gyroplane = "RG"
        case glider = "Glider"
        case airship = "LA"
        case freeBalloon = "LB"
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
