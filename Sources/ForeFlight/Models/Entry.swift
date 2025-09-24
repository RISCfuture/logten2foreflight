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
  static var fieldMapping: [String: PartialKeyPath<Self>?] {
    [
      "Date": nil,  // Computed property - cannot use KeyPath
      "AircraftID": \Self.aircraftID,
      "From": \Self.from,
      "To": \Self.to,
      "Route": \Self.route,
      "TimeOut": nil,  // Computed property - cannot use KeyPath
      "TimeOff": nil,  // Computed property - cannot use KeyPath
      "TimeOn": nil,  // Computed property - cannot use KeyPath
      "TimeIn": nil,  // Computed property - cannot use KeyPath
      "OnDuty": nil,  // Computed property - cannot use KeyPath
      "OffDuty": nil,  // Computed property - cannot use KeyPath
      "TotalTime": \Self.totalTime,
      "PIC": \Self.PICTime,
      "SIC": \Self.SICTime,
      "Night": \Self.nightTime,
      "Solo": \Self.soloTime,
      "CrossCountry": \Self.crossCountryTime,
      "NVG": \Self.NVGTime,
      "NVGOps": \Self.NVGOps,
      "Distance": \Self.distance,
      "DayTakeoffs": \Self.takeoffsDay,
      "DayLandingsFullStop": \Self.landingsDayFullStop,
      "NightTakeoffs": \Self.takeoffsNight,
      "NightLandingsFullStop": \Self.landingsNightFullStop,
      "AllLandings": \Self.landingsAll,
      "ActualInstrument": \Self.actualInstrumentTime,
      "SimulatedInstrument": \Self.simulatedInstrumentTime,
      "HobbsStart": \Self.hobbsStart,
      "HobbsEnd": \Self.hobbsEnd,
      "TachStart": \Self.tachStart,
      "TachEnd": \Self.tachEnd,
      "Holds": \Self.holds,
      "Approach1": nil,  // Computed property - cannot use KeyPath
      "Approach2": nil,  // Computed property - cannot use KeyPath
      "Approach3": nil,  // Computed property - cannot use KeyPath
      "Approach4": nil,  // Computed property - cannot use KeyPath
      "Approach5": nil,  // Computed property - cannot use KeyPath
      "Approach6": nil,  // Computed property - cannot use KeyPath
      "DualGiven": \Self.dualGiven,
      "DualReceived": \Self.dualReceived,
      "SimulatedFlight": \Self.simulatorTime,
      "GroundTraining": \Self.groundTime,
      "InstructorName": nil,
      "InstructorComments": nil,
      "Person1": nil,  // Computed property - cannot use KeyPath
      "Person2": nil,  // Computed property - cannot use KeyPath
      "Person3": nil,  // Computed property - cannot use KeyPath
      "Person4": nil,  // Computed property - cannot use KeyPath
      "Person5": nil,  // Computed property - cannot use KeyPath
      "Person6": nil,  // Computed property - cannot use KeyPath
      "FlightReview": \Self.flightReview,
      "Checkride": \Self.checkride,
      "IPC": \Self.IPC,
      "NVGProficiency": \Self.NVGProficiency,
      "FAA6158": \Self.recurrent,
      "[Text]CustomFieldName": nil,
      "[Numeric]CustomFieldName": nil,
      "[Hours]CustomFieldName": nil,
      "[Counter]CustomFieldName": nil,
      "[Date]CustomFieldName": nil,
      "[DateTime]CustomFieldName": nil,
      "[Toggle]CustomFieldName": nil,
      "PilotComments": \Self.remarks
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

  // Additional fields for ForeFlight export
  package private(set) var PICUSTime = 0.0  // PICUS time (treated as PIC for ForeFlight)
  package private(set) var multiPilotTime = 0.0  // Multi-pilot time for multi-engine aircraft
  package private(set) var examinerTime = 0.0  // Time when examiner was present

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

  var approach1: Approach? { !approaches.isEmpty ? approaches[0] : nil }
  var approach2: Approach? { approaches.count > 1 ? approaches[1] : nil }
  var approach3: Approach? { approaches.count > 2 ? approaches[2] : nil }
  var approach4: Approach? { approaches.count > 3 ? approaches[3] : nil }
  var approach5: Approach? { approaches.count > 4 ? approaches[4] : nil }
  var approach6: Approach? { approaches.count > 5 ? approaches[5] : nil }

  var person1: Member? { !people.isEmpty ? people[0] : nil }
  var person2: Member? { people.count > 1 ? people[1] : nil }
  var person3: Member? { people.count > 2 ? people[2] : nil }
  var person4: Member? { people.count > 3 ? people[3] : nil }
  var person5: Member? { people.count > 4 ? people[4] : nil }
  var person6: Member? { people.count > 5 ? people[5] : nil }

  package init(
    date: Date,
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
    PICUSTime: Double = 0.0,
    multiPilotTime: Double = 0.0,
    examinerTime: Double = 0.0,
    remarks: String? = nil
  ) {
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
    self.PICUSTime = PICUSTime
    self.multiPilotTime = multiPilotTime
    self.examinerTime = examinerTime
    self.remarks = remarks
  }

  package struct Approach {
    package private(set) var count: UInt
    package private(set) var type: ApproachType
    package private(set) var runway: String?
    package private(set) var airport: String
    package private(set) var comments: String?

    package init(
      count: UInt,
      type: Flight.ApproachType,
      runway: String? = nil,
      airport: String,
      comments: String? = nil
    ) {
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
