import Foundation

/// A single flight record from a LogTen Pro logbook.
///
/// A `Flight` contains all information about a single flight, including timing,
/// crew assignments, approaches, takeoffs and landings, and remarks.
package struct Flight: Record {

  // MARK: Properties

  /// The aircraft used for this flight, or `nil` if not specified.
  package let aircraft: Aircraft?

  /// All instrument approaches flown during this flight.
  package let approaches: [Approach]

  /// The pilot in command for this flight.
  package let PIC: Person?

  /// The second in command for this flight.
  package let SIC: Person?

  /// The instructor for this flight.
  package let instructor: Person?

  /// The student for this flight.
  package let student: Person?

  /// The safety pilot for this flight (from custom LogTen field).
  package let safetyPilot: Person?

  /// The examiner for this flight (from custom LogTen field).
  package let examiner: Person?

  /// The flight engineer for this flight.
  package let flightEngineer: Person?

  /// All flight attendants on this flight.
  package let flightAttendants: [Person]

  /// All passengers on this flight.
  package let passengers: [Person]

  /// The date of the flight.
  package let date: Date

  /// The actual departure time (block out).
  package let out: Date?

  /// The takeoff time (wheels up).
  package let off: Date?

  /// The landing time (wheels down).
  package let on: Date?

  /// The actual arrival time (block in).
  package let `in`: Date?

  /// The time duty began.
  package let onDuty: Date?

  /// The time duty ended.
  package let offDuty: Date?

  /// The Hobbs meter reading at engine start.
  package let hobbsStart: Double?

  /// The Hobbs meter reading at engine shutdown.
  package let hobbsEnd: Double?

  /// The tachometer reading at engine start.
  package let tachStart: Double?

  /// The tachometer reading at engine shutdown.
  package let tachEnd: Double?

  /// The departure airport.
  package let from: Place?

  /// The destination airport.
  package let to: Place?

  /// The route of flight (intermediate waypoints).
  package let route: String?

  /// The distance flown in nautical miles.
  package let distance: Double?

  /// Total flight time in minutes.
  package let totalTime: UInt

  /// Pilot in command time in minutes.
  package let PICTime: UInt

  /// Second in command time in minutes.
  package let SICTime: UInt

  /// Solo time in minutes.
  package let soloTime: UInt

  /// Night time in minutes.
  package let nightTime: UInt

  /// Cross-country time in minutes.
  package let crossCountryTime: UInt

  /// Dual instruction given time in minutes.
  package let dualGivenTime: UInt

  /// Dual instruction received time in minutes.
  package let dualReceivedTime: UInt

  /// Actual instrument time in minutes.
  package let actualInstrumentTime: UInt

  /// Simulated instrument time (hood) in minutes.
  package let simulatedInstrumentTime: UInt

  /// Simulator or training device time in minutes.
  package let simulatorTime: UInt

  /// Ground training time in minutes.
  package let groundTime: UInt

  /// Night vision goggle time in minutes.
  package let NVGTime: UInt

  /// Number of day takeoffs.
  package let takeoffsDay: UInt

  /// Number of night takeoffs.
  package let takeoffsNight: UInt

  /// Number of day landings.
  package let landingsDay: UInt

  /// Number of night landings.
  package let landingsNight: UInt

  /// Number of full-stop landings.
  package let landingsFullStop: UInt

  /// Number of night full-stop landings (from custom LogTen field).
  package let landingsNightFullStop: UInt

  /// Number of night vision goggle takeoffs.
  package let takeoffsNVG: UInt

  /// Number of night vision goggle landings.
  package let landingsNVG: UInt

  /// Number of holding patterns flown.
  package let holds: UInt

  /// Whether this flight was a flight review (BFR).
  package let flightReview: Bool

  /// Whether this flight included an instrument proficiency check.
  package let IPC: Bool

  /// Whether this flight was a proficiency check (from custom LogTen field).
  package let proficiencyCheck: Bool

  /// Whether this flight was a checkride (from custom LogTen field).
  package let checkride: Bool

  /// Flight remarks and notes.
  package let remarks: String?

  // MARK: Computed Properties

  /// Total landings (day + night).
  package var landingsAll: UInt { landingsDay + landingsNight }

  /// Day full-stop landings (derived from total full-stop minus night full-stop).
  package var landingsDayFullStop: UInt {
    UInt(max(Int(landingsFullStop) - Int(landingsNightFullStop), 0))
  }

  /// Total duty time as a time interval.
  package var dutyTime: TimeInterval? {
    guard let onDuty, let offDuty else { return nil }
    return offDuty.timeIntervalSince(onDuty)
  }

  /// Total duty time in hours.
  package var dutyHours: Double? {
    guard let dutyTime else { return nil }
    return dutyTime / 3600
  }

  /// Block time (out to in) as a time interval.
  package var blockTime: TimeInterval? {
    guard let out, let `in` else { return nil }
    return `in`.timeIntervalSince(out)
  }

  /// Block time in hours.
  package var blockHours: Double? {
    guard let blockTime else { return nil }
    return blockTime / 3600
  }

  /// Flight time (off to on) as a time interval.
  package var flightTime: TimeInterval? {
    guard let off, let on else { return nil }
    return on.timeIntervalSince(off)
  }

  /// Flight time in hours.
  package var flightHours: Double? {
    guard let flightTime else { return nil }
    return flightTime / 3600
  }

  /// Total time converted to hours.
  package var totalHours: Double { Double(totalTime) / 60 }

  /// PIC time converted to hours.
  package var PICHours: Double { Double(PICTime) / 60 }

  /// SIC time converted to hours.
  package var SICHours: Double { Double(SICTime) / 60 }

  /// Solo time converted to hours.
  package var soloHours: Double { Double(soloTime) / 60 }

  /// Night time converted to hours.
  package var nightHours: Double { Double(nightTime) / 60 }

  /// Cross-country time converted to hours.
  package var crossCountryHours: Double { Double(crossCountryTime) / 60 }

  /// Dual given time converted to hours.
  package var dualGivenHours: Double { Double(dualGivenTime) / 60 }

  /// Dual received time converted to hours.
  package var dualReceivedHours: Double { Double(dualReceivedTime) / 60 }

  /// Actual instrument time converted to hours.
  package var actualInstrumentHours: Double { Double(actualInstrumentTime) / 60 }

  /// Simulated instrument time converted to hours.
  package var simulatedInstrumentHours: Double { Double(simulatedInstrumentTime) / 60 }

  /// Simulator time converted to hours.
  package var simulatorHours: Double { Double(simulatorTime) / 60 }

  /// Ground training time converted to hours.
  package var groundHours: Double { Double(groundTime) / 60 }

  /// NVG time converted to hours.
  package var NVGHours: Double { Double(NVGTime) / 60 }

  // MARK: Initializers

  init(
    flight: CNFlight,
    aircraft: Aircraft,
    nightFullStopProperty: KeyPath<CNFlight, NSNumber?>,
    proficiencyProperty: KeyPath<CNFlight, String?>,
    checkrideProperty: KeyPath<CNFlight, String?>,
    safetyPilotProperty: KeyPath<CNFlightCrew, CNPerson?>,
    examinerProperty: KeyPath<CNFlightCrew, CNPerson?>
  ) {
    self.aircraft = aircraft
    approaches = (flight.flight_flightApproaches?.approaches ?? [])
      .map { .init(approach: $0) }
    PIC = .init(person: flight.flight_flightCrew?.flightCrew_PIC)
    SIC = .init(person: flight.flight_flightCrew?.flightCrew_SIC)
    instructor = .init(person: flight.flight_flightCrew?.flightCrew_instructor)
    student = .init(person: flight.flight_flightCrew?.flightCrew_student)
    safetyPilot = .init(person: flight.flight_flightCrew?[keyPath: safetyPilotProperty])
    examiner = .init(person: flight.flight_flightCrew?[keyPath: examinerProperty])
    flightEngineer = .init(person: flight.flight_flightCrew?.flightCrew_flightEngineer)
    flightAttendants = (flight.flight_flightCrew?.flightAttendants ?? []).compactMap {
      .init(person: $0)
    }
    passengers = (flight.flight_flightPassengers?.passengers ?? [])
      .compactMap { .init(person: $0) }

    date = flight.flight_flightDate
    out = flight.flight_actualDepartureTime
    off = flight.flight_takeoffTime
    on = flight.flight_landingTime
    `in` = flight.flight_actualArrivalTime
    onDuty = flight.flight_onDutyTime
    offDuty = flight.flight_offDutyTime
    hobbsStart = flight.flight_hobbsStart?.doubleValue
    hobbsEnd = flight.flight_hobbsStop?.doubleValue
    tachStart = flight.flight_tachStart?.doubleValue
    tachEnd = flight.flight_tachStop?.doubleValue

    from = .init(place: flight.flight_fromPlace)
    to = .init(place: flight.flight_toPlace)
    route = flight.flight_route
    distance = flight.flight_distance?.doubleValue

    totalTime = flight.flight_totalTime?.uintValue ?? 0
    PICTime = flight.flight_pic?.uintValue ?? 0
    SICTime = flight.flight_sic?.uintValue ?? 0
    soloTime = flight.flight_solo?.uintValue ?? 0
    nightTime = flight.flight_night?.uintValue ?? 0
    crossCountryTime = flight.flight_crossCountry?.uintValue ?? 0
    dualGivenTime = flight.flight_dualGiven?.uintValue ?? 0
    dualReceivedTime = flight.flight_dualReceived?.uintValue ?? 0
    actualInstrumentTime = flight.flight_actualInstrument?.uintValue ?? 0
    simulatedInstrumentTime = flight.flight_simulatedInstrument?.uintValue ?? 0
    simulatorTime = flight.flight_simulator?.uintValue ?? 0
    groundTime = flight.flight_ground?.uintValue ?? 0
    NVGTime = flight.flight_nightVisionGoggle?.uintValue ?? 0

    takeoffsDay = flight.flight_dayTakeoffs?.uintValue ?? 0
    takeoffsNight = flight.flight_nightTakeoffs?.uintValue ?? 0
    landingsDay = flight.flight_dayLandings?.uintValue ?? 0
    landingsNight = flight.flight_nightLandings?.uintValue ?? 0
    landingsFullStop = flight.flight_fullStops?.uintValue ?? 0
    landingsNightFullStop = flight[keyPath: nightFullStopProperty]?.uintValue ?? 0
    takeoffsNVG = flight.flight_nightVisionGoggleTakeoffs?.uintValue ?? 0
    landingsNVG = flight.flight_nightVisionGoggleLandings?.uintValue ?? 0

    holds = flight.flight_holds?.uintValue ?? 0

    flightReview = flight.flight_review?.boolValue ?? false
    IPC = flight.flight_instrumentProficiencyCheck?.boolValue ?? false
    proficiencyCheck = flight[keyPath: proficiencyProperty]?.isPresent ?? false
    checkride = flight[keyPath: checkrideProperty]?.isPresent ?? false

    remarks = flight.flight_remarks
  }
}
