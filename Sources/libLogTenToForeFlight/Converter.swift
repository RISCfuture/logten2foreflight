import Foundation
import LogTen
import ForeFlight

public class Converter {
    let LTPLogbook: LogTen.Logbook
    
    private static let dieselAircraft = ["DA42", "DA62"]
    private static let typeOverrides = [
        "2-33": "S233",
        "7ECA": "CH7A",
        "7GCBC": "CH7B",
        "8KCAB": "BL8",
        "A320-": "A320",
        "B738-": "B738",
        "C-152": "C152",
        "C-172": "C172",
        "C-182": "C182",
        "C-T182": "C82T",
        "E145-": "E145",
        "FRASCA 142": nil,
        "G-44": "G44",
        "PA-22": "PA22",
        "PA-28-": "P28A",
        "PA-28R": "P28R",
        "PA-34": "PA34",
        "SF50-": "SF50",
        "SR22-": "SR22",
        "SR22N-": "SR22",
        "SR22T-": "S22T"
    ]
    
    public init(logbook: LogTen.Logbook) {
        LTPLogbook = logbook
    }
    
    public func convert() -> ForeFlight.Logbook {
        var FFLogbook = ForeFlight.Logbook()
        
        for person in LTPLogbook.people.sorted(by: { $0.name < $1.name }) {
            FFLogbook.people.append(convert(person: person))
        }
        
        for aircraft in LTPLogbook.aircraft.sorted(by: { $0.tailNumber < $1.tailNumber }) {
            FFLogbook.aircraft.append(convert(aircraft: aircraft))
        }
        
        for entry in LTPLogbook.entries.sorted(by: { $0.date < $1.date }) {
            FFLogbook.entries.append(convert(entry: entry))
        }
        
        return FFLogbook
    }
    
    private func convert(person: LogTen.Person) -> ForeFlight.Person {
        .init(name: person.name,
              email: person.email)
    }
    
    private func convert(aircraft: LogTen.Aircraft) -> ForeFlight.Aircraft {
        .init(tailNumber: aircraft.tailNumber,
              simulatorType: simulatorType(for: aircraft),
              typeCode: typeCode(for: aircraft),
              year: aircraft.year,
              make: aircraft.make,
              model: aircraft.model,
              category: category(for: aircraft),
              class: `class`(for: aircraft),
              gearType: gearType(for: aircraft),
              engineType: engineType(for: aircraft),
              complex: aircraft.complex,
              highPerformance: aircraft.highPerformance,
              pressurized: aircraft.pressurized,
              technicallyAdvanced: aircraft.technicallyAdvanced)
    }
    
    private func convert(entry: LogTen.Entry) -> ForeFlight.Entry {
        .init(date: entry.date,
              aircraftID: entry.aircraft,
              from: entry.from,
              to: entry.to,
              route: entry.route,
              out: entry.out,
              off: entry.off,
              on: entry.on,
              in: entry.in,
              onDuty: entry.onDuty,
              offDuty: entry.offDuty,
              totalTime: entry.totalHours,
              PICTime: entry.PICHours,
              SICTime: entry.SICHours,
              nightTime: entry.nightHours,
              soloTime: entry.soloHours,
              crossCountryTime: entry.crossCountryHours,
              NVGTime: entry.NVGHours,
              NVGOps: entry.takeoffsNVG + entry.landingsNVG,
              distance: entry.distance,
              takeoffsDay: entry.takeoffsDay,
              landingsDayFullStop: entry.landingsDayFullStop,
              takeoffsNight: entry.takeoffsNight,
              landingsNightFullStop: entry.landingsNightFullStop,
              landingsAll: entry.landingsAll,
              actualInstrumentTime: entry.actualInstrumentHours,
              simulatedInstrumentTime: entry.simulatedInstrumentHours,
              hobbsStart: entry.hobbsStart,
              hobbsEnd: entry.hobbsEnd,
              tachStart: entry.tachStart,
              tachEnd: entry.tachEnd,
              holds: entry.holds,
              approaches: approaches(for: entry),
              dualGiven: entry.dualGivenHours,
              dualReceived: entry.dualReceivedHours,
              simulatorTime: entry.simulatorHours,
              groundTime: entry.groundHours,
              people: people(for: entry),
              flightReview: entry.flightReview,
              checkride: isCheckride(entry),
              IPC: entry.IPC,
              NVGProficiency: false,
              recurrent: entry.proficiencyCheck,
              remarks: entry.remarks)
    }
    
    private func typeCode(for aircraft: LogTen.Aircraft) -> String? {
        for (`prefix`, FAAType) in Self.typeOverrides {
            if aircraft.typeCode.hasPrefix(`prefix`) { return FAAType }
        }
        return aircraft.typeCode
    }
    
    private func simulatorType(for aircraft: LogTen.Aircraft) -> ForeFlight.Aircraft.SimulatorType {
        switch aircraft.simulatorType {
            case .BATD: return .BATD
            case .AATD: return .AATD
            case .FTD: return .FTD
            case .FFS: return .FFS
            default: return .aircraft
        }
    }
    
    private func category(for aircraft: LogTen.Aircraft) -> ForeFlight.Aircraft.Category {
        switch aircraft.category {
            case .airplane: return .airplane
            case .glider: return .glider
            case .simulator: return .simulator
        }
    }
    
    private func `class`(for aircraft: LogTen.Aircraft) -> ForeFlight.Aircraft.Class? {
        switch aircraft.category {
            case .airplane:
                switch aircraft.class {
                    case .airplaneSingleEngineLand: return .singleEngineLand
                    case .airplaneSingleEngineSea: return .singleEngineSea
                    case .airplaneMultiEngineLand: return .multiEngineLand
                    case .airplaneMultiEngineSea: return .multiEngineSea
                    case .none: return nil
                }
            case .glider: return .glider
            case .simulator:
                switch aircraft.simulatorType {
                    case .BATD: return .ATD
                    case .AATD: return .ATD
                    case .FTD: return .FTD
                    case .FFS: return .FFS
                    case .none: return nil
                }
        }
    }
    
    private func gearType(for aircraft: LogTen.Aircraft) -> ForeFlight.Aircraft.GearType? {
        switch aircraft.simulatorType {
            case .BATD, .AATD: return nil
            default: break
        }
        
        if aircraft.amphibious { return .amphibian }
        if aircraft.floats { return .floats }
        if aircraft.skids { return .skids }
        if aircraft.skis { return .skis }
        if aircraft.retractableGear {
            if aircraft.tailwheel { return .retractableConventional }
            else { return .retractableTricycle }
        } else {
            if aircraft.tailwheel { return .fixedConventional }
            else { return .fixedTricycle }
        }
    }
    
    private func engineType(for aircraft: LogTen.Aircraft) -> ForeFlight.Aircraft.EngineType? {
        switch aircraft.engineType {
            case .piston:
                if aircraft.radial { return .radial }
                if Self.dieselAircraft.contains(aircraft.model) { return .diesel }
                else { return .piston }
            case .nonpowered: return .nonpowered
            case .turbofan: return .turbofan
            case .none: return nil
        }
    }
    
    private func approaches(for entry: LogTen.Entry) -> Array<ForeFlight.Entry.Approach> {
        entry.approaches.compactMap {
            guard let type = approachType(for: $0) else { return nil }
            return ForeFlight.Entry.Approach(count: $0.count,
                                             type: type,
                                             runway: $0.runway,
                                             airport: $0.airport)
        }
    }
    
    private func approachType(for approach: LogTen.Entry.Approach) -> ForeFlight.Entry.ApproachType? {
        switch approach.type {
            case .GCA: return .GCA
            case .GLS: return .GLS
            case .GPS_GNSS: return .RNAV_GPS
            case .IGS: return .LDA
            case .ILS: return .ILS
            case .JPALS: return .RNAV_GPS
            case .GBAS: return .RNAV_GPS
            case .LNAV: return .RNAV_GPS
            case .LNAV_VNAV: return .RNAV_GPS
            case .LPV: return .RNAV_GPS
            case .MLS: return .MLS
            case .PAR: return .PAR
            case .WAAS: return .RNAV_GPS
            case .ARA: return .ASR_SRA
            case .contact: return nil
            case .DME: return .VOR
            case .GPS: return .RNAV_GPS
            case .IAN: return nil
            case .LDA: return .LDA
            case .LOC: return .LOC
            case .LOC_BC: return .LOC_BC
            case .LOC_DME: return .LOC
            case .LP: return .RNAV_GPS
            case .NDB: return .NDB
            case .RNAV: return .RNAV_GPS
            case .RNP: return .RNAV_RNP
            case .SDF: return .SDF
            case .SRA: return .ASR_SRA
            case .TACAN: return .TACAN
            case .visual: return nil
            case .VOR: return .VOR
            case .VOR_DME: return .VOR
        }
    }
    
    private func people(for entry: LogTen.Entry) -> Array<ForeFlight.Entry.Member> {
        var people = Array<ForeFlight.Entry.Member>()
        
        if let instructor = entry.instructor { people.append(convert(person: instructor, role: .instructor)) }
        if let student = entry.student { people.append(convert(person: student, role: .student)) }
        if let safetyPilot = entry.safetyPilot { people.append(convert(person: safetyPilot, role: .safetyPilot)) }
        if let examiner = entry.examiner { people.append(convert(person: examiner, role: .examiner)) }
        if let PIC = entry.PIC { people.append(convert(person: PIC, role: .PIC)) }
        if let SIC = entry.SIC { people.append(convert(person: SIC, role: .SIC)) }
        
        for passenger in entry.passengers {
            people.append(convert(person: passenger, role: .passenger))
        }
        
        return people
    }
    
    private func convert(person: LogTen.Person, role: ForeFlight.Entry.Role) -> ForeFlight.Entry.Member {
        .init(person: .init(name: person.name, email: person.email),
              role: role)
    }
    
    private func isCheckride(_ entry: LogTen.Entry) -> Bool {
        entry.flightReview && entry.remarks?.localizedCaseInsensitiveContains("checkride") ?? false
    }
}
