import Foundation

public struct Entry {
    public private(set) var date: Date
    public private(set) var out: Date? = nil
    public private(set) var off: Date? = nil
    public private(set) var on: Date? = nil
    public private(set) var `in`: Date? = nil
    public private(set) var onDuty: Date? = nil
    public private(set) var offDuty: Date? = nil
    public private(set) var hobbsStart: Double?
    public private(set) var hobbsEnd: Double? = nil
    public private(set) var tachStart: Double? = nil
    public private(set) var tachEnd: Double? = nil
    
    public private(set) var aircraft: String?
    
    public private(set) var from: String?
    public private(set) var to: String?
    public private(set) var route: String? = nil
    public private(set) var distance: Double? = nil
    
    public private(set) var totalTime: UInt = 0 // minutes
    public private(set) var PICTime: UInt = 0 // minutes
    public private(set) var SICTime: UInt = 0 // minutes
    public private(set) var soloTime: UInt = 0 // minutes
    public private(set) var nightTime: UInt = 0 // minutes
    public private(set) var crossCountryTime: UInt = 0 // minutes
    public private(set) var dualGivenTime: UInt = 0 // minutes
    public private(set) var dualReceivedTime: UInt = 0 // minutes
    public private(set) var actualInstrumentTime: UInt = 0 // minutes
    public private(set) var simulatedInstrumentTime: UInt = 0 // minutes
    public private(set) var simulatorTime: UInt = 0 // minutes
    public private(set) var groundTime: UInt = 0 // minutes
    public private(set) var NVGTime: UInt = 0 // minutes
    
    public private(set) var takeoffsDay: UInt = 0
    public private(set) var takeoffsNight: UInt = 0
    public private(set) var landingsDay: UInt = 0
    public private(set) var landingsNight: UInt = 0
    public private(set) var landingsFullStop: UInt = 0
    public private(set) var landingsNightFullStop: UInt = 0
    public private(set) var takeoffsNVG: UInt = 0
    public private(set) var landingsNVG: UInt = 0
    
    public private(set) var holds: UInt = 0
    public private(set) var approaches: Array<Approach> = []
    
    public private(set) var members: Array<Member> = []
    
    public private(set) var flightReview = false
    public private(set) var IPC = false
    public private(set) var proficiencyCheck = false
    
    public private(set) var remarks: String? = nil
    
    public var landingsAll: UInt { landingsDay + landingsNight }
    public var landingsDayFullStop: UInt { landingsFullStop - landingsNightFullStop }
    
    public var dutyTime: TimeInterval? {
        guard let onDuty = onDuty else { return nil }
        guard let offDuty = offDuty else { return nil }
        return offDuty.timeIntervalSince(onDuty)
    }
    
    public var dutyHours: Double? {
        guard let dutyTime = dutyTime else { return nil }
        return dutyTime / 3600
    }
    
    public var blockTime: TimeInterval? {
        guard let out = out else { return nil }
        guard let `in` = `in` else { return nil }
        return `in`.timeIntervalSince(out)
    }
    
    public var blockHours: Double? {
        guard let blockTime = blockTime else { return nil }
        return blockTime / 3600
    }
    
    public var flightTime: TimeInterval? {
        guard let off = off else { return nil }
        guard let on = on else { return nil }
        return on.timeIntervalSince(off)
    }
    
    public var flightHours: Double? {
        guard let flightTime = flightTime else { return nil }
        return flightTime / 3600
    }
    
    public var totalHours: Double { Double(totalTime)/60 }
    public var PICHours: Double { Double(PICTime)/60 }
    public var SICHours: Double { Double(SICTime)/60 }
    public var soloHours: Double { Double(soloTime)/60 }
    public var nightHours: Double { Double(nightTime)/60 }
    public var crossCountryHours: Double { Double(crossCountryTime)/60 }
    public var dualGivenHours: Double { Double(dualGivenTime)/60 }
    public var dualReceivedHours: Double { Double(dualReceivedTime)/60 }
    public var actualInstrumentHours: Double { Double(actualInstrumentTime)/60 }
    public var simulatedInstrumentHours: Double { Double(simulatedInstrumentTime)/60 }
    public var simulatorHours: Double { Double(simulatorTime)/60 }
    public var groundHours: Double { Double(groundTime)/60 }
    public var NVGHours: Double { Double(NVGTime)/60 }
    
    public var approachCount: UInt {
        approaches.reduce(0) { $0 + $1.count }
    }
    
    public var PIC: Person? { members.first(where: { $0.role == .PIC })?.person }
    public var SIC: Person? { members.first(where: { $0.role == .SIC })?.person }
    public var instructor: Person? { members.first(where: { $0.role == .instructor })?.person }
    public var student: Person? { members.first(where: { $0.role == .student })?.person }
    public var safetyPilot: Person? { members.first(where: { $0.role == .safetyPilot })?.person }
    public var examiner: Person? { members.first(where: { $0.role == .examiner })?.person }
    public var passengers: Array<Person> { members.filter { $0.role == .passenger }.map { $0.person } }
    
    public enum ApproachType: String, RawRepresentable {
        case GCA
        case GLS
        case GPS_GNSS = "GPS/GNSS"
        case IGS
        case ILS
        case JPALS
        case GBAS
        case LNAV
        case LNAV_VNAV = "LNAV/VNAV"
        case LPV
        case MLS
        case PAR
        case WAAS
        case ARA
        case contact = "CONTACT"
        case DME
        case GPS
        case IAN
        case LDA
        case LOC
        case LOC_BC = "LOC BC"
        case LOC_DME = "LOC/DME"
        case LP
        case NDB
        case RNAV
        case RNP
        case SDF
        case SRA
        case TACAN
        case visual = "VISUAL"
        case VOR
        case VOR_DME = "VOR/DME"
    }
    
    public struct Approach: Hashable {
        public private(set) var type: ApproachType
        public private(set) var runway: String?
        public private(set) var airport: String
        public private(set) var count: UInt
    }
    
    public enum Role {
        case PIC
        case SIC
        case instructor
        case student
        case passenger
        case safetyPilot
        case examiner
    }
    
    public struct Member {
        public private(set) var person: Person
        public private(set) var role: Role
    }
}
