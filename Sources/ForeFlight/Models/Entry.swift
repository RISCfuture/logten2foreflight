import Foundation

package struct DateOnly {
    package var date: Date
    package init(_ date: Date) { self.date = date }
}

package struct TimeOnly {
    package var date: Date
    package init(_ date: Date) { self.date = date }
}

package struct Flight {
    static var fieldMapping: [String: PartialKeyPath<Flight>?] {
        [
            "Date": nil, // TODO: Fix dateFormatted
            "AircraftID": \Flight.aircraftID,
            "From": \Flight.from,
            "To": \Flight.to,
            "Route": \Flight.route,
            "TimeOut": nil, // TODO: Fix outFormatted
            "TimeOff": nil, // TODO: Fix offFormatted
            "TimeOn": nil, // TODO: Fix onFormatted
            "TimeIn": nil, // TODO: Fix inFormatted
            "OnDuty": nil, // TODO: Fix onDutyFormatted
            "OffDuty": nil, // TODO: Fix offDutyFormatted
            "TotalTime": \Flight.totalTime,
            "PIC": \Flight.PICTime,
            "SIC": \Flight.SICTime,
            "Night": \Flight.nightTime,
            "Solo": \Flight.soloTime,
            "CrossCountry": \Flight.crossCountryTime,
            "NVG": \Flight.NVGTime,
            "NVGOps": \Flight.NVGOps,
            "Distance": \Flight.distance,
            "DayTakeoffs": \Flight.takeoffsDay,
            "DayLandingsFullStop": \Flight.landingsDayFullStop,
            "NightTakeoffs": \Flight.takeoffsNight,
            "NightLandingsFullStop": \Flight.landingsNightFullStop,
            "AllLandings": \Flight.landingsAll,
            "ActualInstrument": \Flight.actualInstrumentTime,
            "SimulatedInstrument": \Flight.simulatedInstrumentTime,
            "HobbsStart": \Flight.hobbsStart,
            "HobbsEnd": \Flight.hobbsEnd,
            "TachStart": \Flight.tachStart,
            "TachEnd": \Flight.tachEnd,
            "Holds": \Flight.holds,
            "Approach1": nil, // TODO: Fix approach1
            "Approach2": nil, // TODO: Fix approach2
            "Approach3": nil, // TODO: Fix approach3
            "Approach4": nil, // TODO: Fix approach4
            "Approach5": nil, // TODO: Fix approach5
            "Approach6": nil, // TODO: Fix approach6
            "DualGiven": \Flight.dualGiven,
            "DualReceived": \Flight.dualReceived,
            "SimulatedFlight": \Flight.simulatorTime,
            "GroundTraining": \Flight.groundTime,
            "InstructorName": nil,
            "InstructorComments": nil,
            "Person1": nil, // TODO: Fix person1
            "Person2": nil, // TODO: Fix person2
            "Person3": nil, // TODO: Fix person3
            "Person4": nil, // TODO: Fix person4
            "Person5": nil, // TODO: Fix person5
            "Person6": nil, // TODO: Fix person6
            "FlightReview": \Flight.flightReview,
            "Checkride": \Flight.checkride,
            "IPC": \Flight.IPC,
            "NVGProficiency": \Flight.NVGProficiency,
            "FAA6158": \Flight.recurrent,
            "[Text]CustomFieldName": nil,
            "[Numeric]CustomFieldName": nil,
            "[Hours]CustomFieldName": nil,
            "[Counter]CustomFieldName": nil,
            "[Date]CustomFieldName": nil,
            "[DateTime]CustomFieldName": nil,
            "[Toggle]CustomFieldName": nil,
            "PilotComments": \Flight.remarks
        ]
    }

    package private(set) var date: Date
    package private(set) var aircraftID: String?

    package private(set) var from: String?
    package private(set) var to: String?
    package private(set) var route: String?

    package private(set) var out: Date?
    package private(set) var off: Date?
    package private(set) var on: Date?
    package private(set) var `in`: Date?
    package private(set) var onDuty: Date?
    package private(set) var offDuty: Date?

    package private(set) var totalTime = 0.0
    package private(set) var PICTime = 0.0
    package private(set) var SICTime = 0.0
    package private(set) var nightTime = 0.0
    package private(set) var soloTime = 0.0
    package private(set) var crossCountryTime = 0.0
    package private(set) var NVGTime = 0.0

    package private(set) var NVGOps: UInt = 0

    package private(set) var distance: Double?

    package private(set) var takeoffsDay: UInt = 0
    package private(set) var landingsDayFullStop: UInt = 0
    package private(set) var takeoffsNight: UInt = 0
    package private(set) var landingsNightFullStop: UInt = 0
    package private(set) var landingsAll: UInt = 0

    package private(set) var actualInstrumentTime = 0.0
    package private(set) var simulatedInstrumentTime = 0.0

    package private(set) var hobbsStart: Double?
    package private(set) var hobbsEnd: Double?
    package private(set) var tachStart: Double?
    package private(set) var tachEnd: Double?

    package private(set) var holds: UInt = 0
    package private(set) var approaches = [Approach]()

    package private(set) var dualGiven = 0.0
    package private(set) var dualReceived = 0.0
    package private(set) var simulatorTime = 0.0
    package private(set) var groundTime = 0.0

    package private(set) var people = [Member]()

    package private(set) var flightReview = false
    package private(set) var checkride = false
    package private(set) var IPC = false
    package private(set) var NVGProficiency = false
    package private(set) var recurrent = false

    package private(set) var remarks: String?

    var dateFormatted: DateOnly { .init(date) }
    var outFormatted: TimeOnly? {
        guard let out else { return nil }
        return .init(out)
    }
    var offFormatted: TimeOnly? {
        guard let off else { return nil }
        return .init(off)
    }
    var onFormatted: TimeOnly? {
        guard let on else { return nil }
        return .init(on)
    }
    var inFormatted: TimeOnly? {
        guard let `in` else { return nil }
        return .init(`in`)
    }
    var onDutyFormatted: TimeOnly? {
        guard let onDuty else { return nil }
        return .init(onDuty)
    }
    var offDutyFormatted: TimeOnly? {
        guard let offDuty else { return nil }
        return .init(offDuty)
    }

    var approach1: Approach? { approaches.count > 0 ? approaches[0] : nil }
    var approach2: Approach? { approaches.count > 1 ? approaches[1] : nil }
    var approach3: Approach? { approaches.count > 2 ? approaches[2] : nil }
    var approach4: Approach? { approaches.count > 3 ? approaches[3] : nil }
    var approach5: Approach? { approaches.count > 4 ? approaches[4] : nil }
    var approach6: Approach? { approaches.count > 5 ? approaches[5] : nil }

    var person1: Member? { people.count > 0 ? people[0] : nil }
    var person2: Member? { people.count > 1 ? people[1] : nil }
    var person3: Member? { people.count > 2 ? people[2] : nil }
    var person4: Member? { people.count > 3 ? people[3] : nil }
    var person5: Member? { people.count > 4 ? people[4] : nil }
    var person6: Member? { people.count > 5 ? people[5] : nil }

    package init(date: Date,
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
                 approaches: [Self.Approach] = [Approach](),
                 dualGiven: Double = 0.0,
                 dualReceived: Double = 0.0,
                 simulatorTime: Double = 0.0,
                 groundTime: Double = 0.0,
                 people: [Self.Member] = [Member](),
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

    package struct Approach {
        package private(set) var count: UInt
        package private(set) var type: ApproachType
        package private(set) var runway: String?
        package private(set) var airport: String
        package private(set) var comments: String?

        package init(count: UInt,
                     type: Flight.ApproachType,
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

    package enum ApproachType: String {
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

    package struct Member {
        package private(set) var person: Person
        package private(set) var role: Role

        package init(person: Person, role: Flight.Role) {
            self.person = person
            self.role = role
        }
    }

    package enum Role: String {
        case PIC
        case SIC
        case instructor = "Instructor"
        case student = "Student"
        case safetyPilot = "Safety Pilot"
        case examiner = "Examiner"
        case passenger = "Passenger"
        case flightAttendant = "Flight Attendant"
        case flightEngineer = "Flight Engineer"
        case firstOfficer = "First Officer"
        case secondOfficer = "Second Officer"
    }
}
