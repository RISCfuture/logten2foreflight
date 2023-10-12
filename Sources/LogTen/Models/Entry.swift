import Foundation

package struct Entry {
    package private(set) var date: Date
    package private(set) var out: Date? = nil
    package private(set) var off: Date? = nil
    package private(set) var on: Date? = nil
    package private(set) var `in`: Date? = nil
    package private(set) var onDuty: Date? = nil
    package private(set) var offDuty: Date? = nil
    package private(set) var hobbsStart: Double?
    package private(set) var hobbsEnd: Double? = nil
    package private(set) var tachStart: Double? = nil
    package private(set) var tachEnd: Double? = nil
    
    package private(set) var aircraft: String?
    
    package private(set) var from: String?
    package private(set) var to: String?
    package private(set) var route: String? = nil
    package private(set) var distance: Double? = nil
    
    package private(set) var totalTime: UInt = 0 // minutes
    package private(set) var PICTime: UInt = 0 // minutes
    package private(set) var SICTime: UInt = 0 // minutes
    package private(set) var soloTime: UInt = 0 // minutes
    package private(set) var nightTime: UInt = 0 // minutes
    package private(set) var crossCountryTime: UInt = 0 // minutes
    package private(set) var dualGivenTime: UInt = 0 // minutes
    package private(set) var dualReceivedTime: UInt = 0 // minutes
    package private(set) var actualInstrumentTime: UInt = 0 // minutes
    package private(set) var simulatedInstrumentTime: UInt = 0 // minutes
    package private(set) var simulatorTime: UInt = 0 // minutes
    package private(set) var groundTime: UInt = 0 // minutes
    package private(set) var NVGTime: UInt = 0 // minutes
    
    package private(set) var takeoffsDay: UInt = 0
    package private(set) var takeoffsNight: UInt = 0
    package private(set) var landingsDay: UInt = 0
    package private(set) var landingsNight: UInt = 0
    package private(set) var landingsFullStop: UInt = 0
    package private(set) var landingsNightFullStop: UInt = 0
    package private(set) var takeoffsNVG: UInt = 0
    package private(set) var landingsNVG: UInt = 0
    
    package private(set) var holds: UInt = 0
    package private(set) var approaches: Array<Approach> = []
    
    package private(set) var members: Array<Member> = []
    
    package private(set) var flightReview = false
    package private(set) var IPC = false
    package private(set) var proficiencyCheck = false
    
    package private(set) var remarks: String? = nil
    
    package var landingsAll: UInt { landingsDay + landingsNight }
    package var landingsDayFullStop: UInt { landingsFullStop - landingsNightFullStop }
    
    package var dutyTime: TimeInterval? {
        guard let onDuty = onDuty else { return nil }
        guard let offDuty = offDuty else { return nil }
        return offDuty.timeIntervalSince(onDuty)
    }
    
    package var dutyHours: Double? {
        guard let dutyTime = dutyTime else { return nil }
        return dutyTime / 3600
    }
    
    package var blockTime: TimeInterval? {
        guard let out = out else { return nil }
        guard let `in` = `in` else { return nil }
        return `in`.timeIntervalSince(out)
    }
    
    package var blockHours: Double? {
        guard let blockTime = blockTime else { return nil }
        return blockTime / 3600
    }
    
    package var flightTime: TimeInterval? {
        guard let off = off else { return nil }
        guard let on = on else { return nil }
        return on.timeIntervalSince(off)
    }
    
    package var flightHours: Double? {
        guard let flightTime = flightTime else { return nil }
        return flightTime / 3600
    }
    
    package var totalHours: Double { Double(totalTime)/60 }
    package var PICHours: Double { Double(PICTime)/60 }
    package var SICHours: Double { Double(SICTime)/60 }
    package var soloHours: Double { Double(soloTime)/60 }
    package var nightHours: Double { Double(nightTime)/60 }
    package var crossCountryHours: Double { Double(crossCountryTime)/60 }
    package var dualGivenHours: Double { Double(dualGivenTime)/60 }
    package var dualReceivedHours: Double { Double(dualReceivedTime)/60 }
    package var actualInstrumentHours: Double { Double(actualInstrumentTime)/60 }
    package var simulatedInstrumentHours: Double { Double(simulatedInstrumentTime)/60 }
    package var simulatorHours: Double { Double(simulatorTime)/60 }
    package var groundHours: Double { Double(groundTime)/60 }
    package var NVGHours: Double { Double(NVGTime)/60 }
    
    package var approachCount: UInt {
        approaches.reduce(0) { $0 + $1.count }
    }
    
    package var PIC: Person? { members.first(where: { $0.role == .PIC })?.person }
    package var SIC: Person? { members.first(where: { $0.role == .SIC })?.person }
    package var instructor: Person? { members.first(where: { $0.role == .instructor })?.person }
    package var student: Person? { members.first(where: { $0.role == .student })?.person }
    package var safetyPilot: Person? { members.first(where: { $0.role == .safetyPilot })?.person }
    package var examiner: Person? { members.first(where: { $0.role == .examiner })?.person }
    package var passengers: Array<Person> { members.filter { $0.role == .passenger }.map { $0.person } }
    
    package enum ApproachType: String, RawRepresentable {
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
    
    package struct Approach: Hashable {
        package private(set) var type: ApproachType
        package private(set) var runway: String?
        package private(set) var airport: String
        package private(set) var count: UInt
    }
    
    package enum Role {
        case PIC
        case SIC
        case instructor
        case student
        case passenger
        case safetyPilot
        case examiner
    }
    
    package struct Member {
        package private(set) var person: Person
        package private(set) var role: Role
    }
}
