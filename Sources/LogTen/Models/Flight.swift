import Foundation

package struct Flight: Record {
    
    // MARK: Properties
    
    package let aircraft: Aircraft?
    
    package let approaches: Array<Approach>
    
    package let PIC: Person?
    package let SIC: Person?
    package let instructor: Person?
    package let student: Person?
    package let safetyPilot: Person?
    package let examiner: Person?
    package let flightEngineer: Person?
    package let flightAttendants: Array<Person>
    package let passengers: Array<Person>
    
    package let date: Date
    package let out: Date?
    package let off: Date?
    package let on: Date?
    package let `in`: Date?
    package let onDuty: Date?
    package let offDuty: Date?
    package let hobbsStart: Double?
    package let hobbsEnd: Double?
    package let tachStart: Double?
    package let tachEnd: Double?
    
    package let from: Place?
    package let to: Place?
    package let route: String?
    package let distance: Double?
    
    package let totalTime: UInt // minutes
    package let PICTime: UInt // minutes
    package let SICTime: UInt // minutes
    package let soloTime: UInt // minutes
    package let nightTime: UInt // minutes
    package let crossCountryTime: UInt // minutes
    package let dualGivenTime: UInt // minutes
    package let dualReceivedTime: UInt // minutes
    package let actualInstrumentTime: UInt // minutes
    package let simulatedInstrumentTime: UInt // minutes
    package let simulatorTime: UInt // minutes
    package let groundTime: UInt // minutes
    package let NVGTime: UInt // minutes
    
    package let takeoffsDay: UInt
    package let takeoffsNight: UInt
    package let landingsDay: UInt
    package let landingsNight: UInt
    package let landingsFullStop: UInt
    package let landingsNightFullStop: UInt
    package let takeoffsNVG: UInt
    package let landingsNVG: UInt
    
    package let holds: UInt
    
    package let flightReview: Bool
    package let IPC: Bool
    package let proficiencyCheck: Bool
    package let checkride: Bool
    
    package let remarks: String?
    
    // MARK: Computed Properties
    
    package var landingsAll: UInt { landingsDay + landingsNight }
    package var landingsDayFullStop: UInt { landingsFullStop - landingsNightFullStop }
    
    package var dutyTime: TimeInterval? {
        guard let onDuty, let offDuty else { return nil }
        return offDuty.timeIntervalSince(onDuty)
    }
    
    package var dutyHours: Double? {
        guard let dutyTime else { return nil }
        return dutyTime / 3600
    }
    
    package var blockTime: TimeInterval? {
        guard let out, let `in` else { return nil }
        return `in`.timeIntervalSince(out)
    }
    
    package var blockHours: Double? {
        guard let blockTime else { return nil }
        return blockTime / 3600
    }
    
    package var flightTime: TimeInterval? {
        guard let off, let on else { return nil }
        return on.timeIntervalSince(off)
    }
    
    package var flightHours: Double? {
        guard let flightTime else { return nil }
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
    
    // MARK: Initializers
    
    init(flight: CNFlight,
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
        flightAttendants = (flight.flight_flightCrew?.flightAttendants ?? []).compactMap { .init(person: $0) }
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
