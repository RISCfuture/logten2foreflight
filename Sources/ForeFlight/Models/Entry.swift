import Foundation

public struct Entry {
    public private(set) var date: Date
    public private(set) var aircraftID: String?
    
    public private(set) var from: String?
    public private(set) var to: String?
    public private(set) var route: String?
    
    public private(set) var out: Date?
    public private(set) var off: Date?
    public private(set) var on: Date?
    public private(set) var `in`: Date?
    public private(set) var onDuty: Date?
    public private(set) var offDuty: Date?
    
    public private(set) var totalTime = 0.0
    public private(set) var PICTime = 0.0
    public private(set) var SICTime = 0.0
    public private(set) var nightTime = 0.0
    public private(set) var soloTime = 0.0
    public private(set) var crossCountryTime = 0.0
    public private(set) var NVGTime = 0.0
    
    public private(set) var NVGOps: UInt = 0
    
    public private(set) var distance: Double?
    
    public private(set) var takeoffsDay: UInt = 0
    public private(set) var landingsDayFullStop: UInt = 0
    public private(set) var takeoffsNight: UInt = 0
    public private(set) var landingsNightFullStop: UInt = 0
    public private(set) var landingsAll: UInt = 0
    
    public private(set) var actualInstrumentTime = 0.0
    public private(set) var simulatedInstrumentTime = 0.0
    
    public private(set) var hobbsStart: Double?
    public private(set) var hobbsEnd: Double?
    public private(set) var tachStart: Double?
    public private(set) var tachEnd: Double?
    
    public private(set) var holds: UInt = 0
    public private(set) var approaches = Array<Approach>()
    
    public private(set) var dualGiven = 0.0
    public private(set) var dualReceived = 0.0
    public private(set) var simulatorTime = 0.0
    public private(set) var groundTime = 0.0
    
    public private(set) var people = Array<Member>()
    
    public private(set) var flightReview = false
    public private(set) var checkride = false
    public private(set) var IPC = false
    public private(set) var NVGProficiency = false
    public private(set) var recurrent = false
    
    public private(set) var remarks: String?
    
    var dateFormatted: DateOnly { .init(date) }
    var outFormatted: TimeOnly? {
        guard let out = out else { return nil }
        return .init(out)
    }
    var offFormatted: TimeOnly? {
        guard let off = off else { return nil }
        return .init(off)
    }
    var onFormatted: TimeOnly? {
        guard let on = on else { return nil }
        return .init(on)
    }
    var inFormatted: TimeOnly? {
        guard let `in` = `in` else { return nil }
        return .init(`in`)
    }
    var onDutyFormatted: TimeOnly? {
        guard let onDuty = onDuty else { return nil }
        return .init(onDuty)
    }
    var offDutyFormatted: TimeOnly? {
        guard let offDuty = offDuty else { return nil }
        return .init(offDuty)
    }
    
    static let fieldMapping: Dictionary<String, PartialKeyPath<Self>?> = [
        "Date": \.dateFormatted,
        "AircraftID": \.aircraftID,
        "From": \.from,
        "To": \.to,
        "Route": \.route,
        "TimeOut": \.outFormatted,
        "TimeOff": \.offFormatted,
        "TimeOn": \.onFormatted,
        "TimeIn": \.inFormatted,
        "OnDuty": \.onDutyFormatted,
        "OffDuty": \.offDutyFormatted,
        "TotalTime": \.totalTime,
        "PIC": \.PICTime,
        "SIC": \.SICTime,
        "Night": \.nightTime,
        "Solo": \.soloTime,
        "CrossCountry": \.crossCountryTime,
        "NVG": \.NVGTime,
        "NVGOps": \.NVGOps,
        "Distance": \.distance,
        "DayTakeoffs": \.takeoffsDay,
        "DayLandingsFullStop": \.landingsDayFullStop,
        "NightTakeoffs": \.takeoffsNight,
        "NightLandingsFullStop": \.landingsNightFullStop,
        "AllLandings": \.landingsAll,
        "ActualInstrument": \.actualInstrumentTime,
        "SimulatedInstrument": \.simulatedInstrumentTime,
        "HobbsStart": \.hobbsStart,
        "HobbsEnd": \.hobbsEnd,
        "TachStart": \.tachStart,
        "TachEnd": \.tachEnd,
        "Holds": \.holds,
        "Approach1": \.approaches.first,
        "Approach2": \.approaches.second,
        "Approach3": \.approaches.third,
        "Approach4": \.approaches.fourth,
        "Approach5": \.approaches.fifth,
        "Approach6": \.approaches.sixth,
        "DualGiven": \.dualGiven,
        "DualReceived": \.dualReceived,
        "SimulatedFlight": \.simulatorTime,
        "GroundTraining": \.groundTime,
        "InstructorName": nil,
        "InstructorComments": nil,
        "Person1": \.people.first,
        "Person2": \.people.second,
        "Person3": \.people.third,
        "Person4": \.people.fourth,
        "Person5": \.people.fifth,
        "Person6": \.people.sixth,
        "FlightReview": \.flightReview,
        "Checkride": \.checkride,
        "IPC": \.IPC,
        "NVGProficiency": \.NVGProficiency,
        "FAA6158": \.recurrent,
        "[Text]CustomFieldName": nil,
        "[Numeric]CustomFieldName": nil,
        "[Hours]CustomFieldName": nil,
        "[Counter]CustomFieldName": nil,
        "[Date]CustomFieldName": nil,
        "[DateTime]CustomFieldName": nil,
        "[Toggle]CustomFieldName": nil,
        "PilotComments": \.remarks
    ]
    
    public init(date: Date,
                aircraftID: String? = nil,
                from: String? = nil,
                to: String? = nil,
                route: String? = nil,
                out: Date? = nil,
                off: Date? = nil,
                on: Date? = nil,
                in: Date? = nil,
                onDuty: Date? = nil,
                offDuty: Date? = nil,
                totalTime: Double = 0.0,
                PICTime: Double = 0.0,
                SICTime: Double = 0.0,
                nightTime: Double = 0.0,
                soloTime: Double = 0.0,
                crossCountryTime: Double = 0.0,
                NVGTime: Double = 0.0,
                NVGOps: UInt = 0,
                distance: Double? = nil,
                takeoffsDay: UInt = 0,
                landingsDayFullStop: UInt = 0,
                takeoffsNight: UInt = 0,
                landingsNightFullStop: UInt = 0,
                landingsAll: UInt = 0,
                actualInstrumentTime: Double = 0.0,
                simulatedInstrumentTime: Double = 0.0,
                hobbsStart: Double? = nil,
                hobbsEnd: Double? = nil,
                tachStart: Double? = nil,
                tachEnd: Double? = nil,
                holds: UInt = 0,
                approaches: [Entry.Approach] = Array<Approach>(),
                dualGiven: Double = 0.0,
                dualReceived: Double = 0.0,
                simulatorTime: Double = 0.0,
                groundTime: Double = 0.0,
                people: [Entry.Member] = Array<Member>(),
                flightReview: Bool = false,
                checkride: Bool = false,
                IPC: Bool = false,
                NVGProficiency: Bool = false,
                recurrent: Bool = false,
                remarks: String? = nil) {
        self.date = date
        self.aircraftID = aircraftID
        self.from = from
        self.to = to
        self.route = route
        self.out = out
        self.off = off
        self.on = on
        self.in = `in`
        self.onDuty = onDuty
        self.offDuty = offDuty
        self.totalTime = totalTime
        self.PICTime = PICTime
        self.SICTime = SICTime
        self.nightTime = nightTime
        self.soloTime = soloTime
        self.crossCountryTime = crossCountryTime
        self.NVGTime = NVGTime
        self.NVGOps = NVGOps
        self.distance = distance
        self.takeoffsDay = takeoffsDay
        self.landingsDayFullStop = landingsDayFullStop
        self.takeoffsNight = takeoffsNight
        self.landingsNightFullStop = landingsNightFullStop
        self.landingsAll = landingsAll
        self.actualInstrumentTime = actualInstrumentTime
        self.simulatedInstrumentTime = simulatedInstrumentTime
        self.hobbsStart = hobbsStart
        self.hobbsEnd = hobbsEnd
        self.tachStart = tachStart
        self.tachEnd = tachEnd
        self.holds = holds
        self.approaches = approaches
        self.dualGiven = dualGiven
        self.dualReceived = dualReceived
        self.simulatorTime = simulatorTime
        self.groundTime = groundTime
        self.people = people
        self.flightReview = flightReview
        self.checkride = checkride
        self.IPC = IPC
        self.NVGProficiency = NVGProficiency
        self.recurrent = recurrent
        self.remarks = remarks
    }
    
    public struct Approach {
        public private(set) var count: UInt
        public private(set) var type: ApproachType
        public private(set) var runway: String?
        public private(set) var airport: String
        public private(set) var comments: String?
        
        public init(count: UInt,
                    type: Entry.ApproachType,
                    runway: String? = nil,
                    airport: String,
                    comments: String? = nil) {
            self.count = count
            self.type = type
            self.runway = runway
            self.airport = airport
            self.comments = comments
        }
    }
    
    public enum ApproachType: String {
        case ASR_SRA = "ASR/SRA"
        case GCA
        case GLS
        case ILS
        case ILS_CAT2 = "ILS CAT II"
        case ILS_CAT3 = "ILS CAT III"
        case LDA
        case LOC
        case LOC_BC = "LOC BC"
        case MLS
        case NDB
        case PAR
        case RNAV_GPS = "RNAV (GPS)"
        case RNAV_RNP = "RNAV (RNP)"
        case SDF
        case TACAN
        case VOR
    }
    
    public struct Member {
        public private(set) var person: Person
        public private(set) var role: Role
        
        public init(person: Person, role: Entry.Role) {
            self.person = person
            self.role = role
        }
    }
    
    public enum Role: String {
        case PIC
        case SIC
        case instructor = "Instructor"
        case student = "Student"
        case safetyPilot = "Safety Pilot"
        case examiner = "Examiner"
        case passenger = "Passenger"
    }
}
