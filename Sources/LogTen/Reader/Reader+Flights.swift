import Foundation
import CoreData

fileprivate let nightFullStopField = "Night Full Stops"
fileprivate let proficiencyField = "FAR 61.58"
fileprivate let checkrideField = "Checkride"

fileprivate let safetyPilotField = "Safety Pilot"
fileprivate let examinerField = "Examiner"

extension Reader {
    func fetchFlights(aircraft: Array<Aircraft>) throws -> Array<Flight> {
        let request = CNFlight.fetchRequest()
        let flights = try container.viewContext.fetch(request)
        
        let nightFullStopProperty = try flightCustomLanding(for: nightFullStopField)
        let proficiencyProperty = try flightCustomNote(for: proficiencyField)
        let checkrideProperty = try flightCustomNote(for: checkrideField)
        let safetyPilotProperty = try flightCrewCustomPerson(for: safetyPilotField)
        let examinerProperty = try flightCrewCustomPerson(for: examinerField)
        
        return flights.compactMap { flight in
            guard let aircraft = aircraft.first(where: { $0.tailNumber == flight.flight_aircraft?.aircraft_aircraftID }) else {
                return nil
            }
            return .init(flight: flight,
                         aircraft: aircraft,
                         nightFullStopProperty: nightFullStopProperty,
                         proficiencyProperty: proficiencyProperty,
                         checkrideProperty: checkrideProperty,
                         safetyPilotProperty: safetyPilotProperty,
                         examinerProperty: examinerProperty)
        }
    }
    
    private func flightCustomLanding(for title: String) throws -> KeyPath<CNFlight, NSNumber?> {
        let request = CNLogTenCustomizationProperty.fetchRequest(title: title, keyPrefix: "flight_customLanding")
        let result = try container.viewContext.fetch(request)
        guard result.count == 1, let property = result.first else {
            throw Error.missingProperty(title, model: "Flight")
        }
        switch property.logTenProperty_key {
            case "flight_customLanding1": return \.flight_customLanding1
            case "flight_customLanding2": return \.flight_customLanding2
            case "flight_customLanding3": return \.flight_customLanding3
            case "flight_customLanding4": return \.flight_customLanding4
            case "flight_customLanding5": return \.flight_customLanding5
            case "flight_customLanding6": return \.flight_customLanding6
            case "flight_customLanding7": return \.flight_customLanding7
            case "flight_customLanding8": return \.flight_customLanding8
            case "flight_customLanding9": return \.flight_customLanding9
            case "flight_customLanding10": return \.flight_customLanding10
            default: preconditionFailure("Unknown custom attribute \(property.logTenProperty_key)")
        }
    }
    
    private func flightCustomNote(for title: String) throws -> KeyPath<CNFlight, String?> {
        let request = CNLogTenCustomizationProperty.fetchRequest(title: title, keyPrefix: "flight_customNote")
        let result = try container.viewContext.fetch(request)
        guard result.count == 1, let property = result.first else {
            throw Error.missingProperty(title, model: "Flight")
        }
        switch property.logTenProperty_key {
            case "flight_customNote1": return \.flight_customNote1
            case "flight_customNote2": return \.flight_customNote2
            case "flight_customNote3": return \.flight_customNote3
            case "flight_customNote4": return \.flight_customNote4
            case "flight_customNote5": return \.flight_customNote5
            case "flight_customNote6": return \.flight_customNote6
            case "flight_customNote7": return \.flight_customNote7
            case "flight_customNote8": return \.flight_customNote8
            case "flight_customNote9": return \.flight_customNote9
            case "flight_customNote10": return \.flight_customNote10
            default: preconditionFailure("Unknown custom attribute \(property.logTenProperty_key)")
        }
    }
    
    private func flightCrewCustomPerson(for title: String) throws -> KeyPath<CNFlightCrew, CNPerson?> {
        let request = CNLogTenCustomizationProperty.fetchRequest(title: title, keyPrefix: "flight_selectedCrewCustom")
        let result = try container.viewContext.fetch(request)
        guard result.count == 1, let property = result.first else {
            throw Error.missingProperty(title, model: "Flight")
        }
        switch property.logTenProperty_key {
            case "flight_selectedCrewCustom1": return \.flightCrew_custom1
            case "flight_selectedCrewCustom2": return \.flightCrew_custom2
            case "flight_selectedCrewCustom3": return \.flightCrew_custom3
            case "flight_selectedCrewCustom4": return \.flightCrew_custom4
            case "flight_selectedCrewCustom5": return \.flightCrew_custom5
            case "flight_selectedCrewCustom6": return \.flightCrew_custom6
            case "flight_selectedCrewCustom7": return \.flightCrew_custom7
            case "flight_selectedCrewCustom8": return \.flightCrew_custom8
            case "flight_selectedCrewCustom9": return \.flightCrew_custom9
            case "flight_selectedCrewCustom10": return \.flightCrew_custom10
            default: preconditionFailure("Unknown custom attribute \(property.logTenProperty_key)")
        }
    }
}
