import ForeFlight
import Foundation
import Logging
import LogTen

/// Converts a LogTen Pro logbook to a ForeFlight logbook.
public class Converter {
    private static let logger = Logger(label: "codes.tim.LogTenToForeFlight.Converter")

    let LTPLogbook: LogTen.Logbook

    /**
     Creates an instance.

     - Parameter logbook: The LogTen Pro logbook.
     */
    public init(logbook: LogTen.Logbook) {
        LTPLogbook = logbook
    }

    /**
     Converts the logbook to ForeFlight format.

     - Returns: The ForeFlight logbook.
     */
    public func convert() async throws -> ForeFlight.Logbook {
        let FFLogbook = ForeFlight.Logbook()

        for person in await LTPLogbook.people.sorted(by: { $0.name < $1.name }) {
            await FFLogbook.add(person: convert(person: person))
        }

        for aircraft in await LTPLogbook.aircraft.sorted(by: { $0.tailNumber < $1.tailNumber }) {
            try await FFLogbook.add(aircraft: convert(aircraft: aircraft))
        }

        for entry in await LTPLogbook.flights.sorted(by: { $0.date < $1.date }) {
            guard let converted = convert(entry: entry) else { continue }
            await FFLogbook.add(entry: converted)
        }

        return FFLogbook
    }

    private func convert(person: LogTen.Person) -> ForeFlight.Person {
        .init(name: person.name,
              email: person.email)
    }

    private func convert(aircraft: LogTen.Aircraft) throws -> ForeFlight.Aircraft {
        return .init(tailNumber: aircraft.tailNumber,
                     simulatorType: simulatorType(for: aircraft.type),
                     typeCode: aircraft.type.simulatorAwareTypeCode,
                     year: aircraft.year,
                     make: aircraft.type.make,
                     model: aircraft.type.model,
                     category: try category(for: aircraft.type),
                     class: try `class`(for: aircraft.type),
                     gearType: gearType(for: aircraft),
                     engineType: try engineType(for: aircraft),
                     complex: aircraft.complex,
                     highPerformance: aircraft.highPerformance,
                     pressurized: aircraft.pressurized,
                     technicallyAdvanced: aircraft.technicallyAdvanced)
    }

    private func convert(entry: LogTen.Flight) -> ForeFlight.Flight? {
        guard let aircraft = entry.aircraft else { return nil }

        return .init(date: entry.date,
                     aircraftID: aircraft.tailNumber,
                     from: entry.from?.ICAO_or_LID,
                     to: entry.to?.ICAO_or_LID,
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
                     approaches: entry.approaches.compactMap(convertApproach),
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

    private func simulatorType(for type: LogTen.AircraftType) -> ForeFlight.Aircraft.SimulatorType {
        switch type.simulatorType {
            case .BATD: return .BATD
            case .AATD: return .AATD
            case .FTD: return .FTD
            case .FFS: return .FFS
            default: return .aircraft
        }
    }

    private func category(for type: LogTen.AircraftType) throws -> ForeFlight.Aircraft.Category {
        switch type.category {
            case .airplane: return .airplane
            case .rotorcraft: return .rotorcraft
            case .glider: return .glider
            case .lighterThanAir: return .lighterThanAir
            case .poweredLift: return .poweredLift
            case .poweredParachute: return .poweredParachute
            case .weightShiftControl: return .weightShiftControl
            case .simulator: return .simulator
            case .PC_ATD: return .simulator
            case .trainingDevice: return .simulator
            default: throw Error.unsupportedCategory(type.category)
        }
    }

    private func `class`(for type: LogTen.AircraftType) throws -> ForeFlight.Aircraft.Class? {
        switch type.category {
            case .airplane:
                guard let `class` = type.class else { throw Error.missingClass(type: type.typeCode) }
                switch `class` {
                    case .multiEngineLand: return .multiEngineLand
                    case .singleEngineLand: return .singleEngineLand
                    case .multiEngineSea: return .multiEngineSea
                    case .singleEngineSea: return .singleEngineSea
                    default: throw Error.invalidClass(`class`, forCategory: type.category)
                }
            case .rotorcraft:
                guard let `class` = type.class else { throw Error.missingClass(type: type.typeCode) }
                switch `class` {
                    case .helicopter: return .helicopter
                    case .gyroplane: return .gyroplane
                    default: throw Error.invalidClass(`class`, forCategory: type.category)
                }
            case .poweredLift: return .poweredLift
            case .glider: return .glider
            case .lighterThanAir:
                guard let `class` = type.class else { throw Error.missingClass(type: type.typeCode) }
                switch `class` {
                    case .airship: return .airship
                    case .freeBalloon: return .freeBalloon
                    default: throw Error.invalidClass(`class`, forCategory: type.category)
                }
            case .simulator, .trainingDevice, .PC_ATD:
                switch type.simulatorType {
                    case .BATD, .AATD: return .ATD
                    case .FTD: return .FTD
                    case .FFS: return .FFS
                    case .none: throw Error.missingSimulatorType(type: type.typeCode)
                }
            case .poweredParachute:
                Self.logger.notice("Assuming Powered Parachute land class for Powered Parachute type", metadata: [
                    "aircraftType": "\(type.typeCode)"
                ])
                return .poweredParachuteLand
            case .weightShiftControl:
                Self.logger.notice("Assuming Weight-Shift-Control land class for Weight-Shift-Control type", metadata: [
                    "aircraftType": "\(type.typeCode)"
                ])
                return .weightShiftControlLand
            default: throw Error.unsupportedCategory(type.category)
        }
    }

    private func gearType(for aircraft: LogTen.Aircraft) -> ForeFlight.Aircraft.GearType? {
        switch aircraft.type.simulatorType {
            case .BATD, .AATD: return nil
            default: break
        }

        if aircraft.amphibious { return .amphibian }
        if aircraft.floats { return .floats }
        if aircraft.skids { return .skids }
        if aircraft.skis { return .skis }
        if aircraft.retractableGear {
            if aircraft.tailwheel { return .retractableConventional }
            return .retractableTricycle
        }
        if aircraft.tailwheel { return .fixedConventional }
        return .fixedTricycle
    }

    private func engineType(for aircraft: LogTen.Aircraft) throws -> ForeFlight.Aircraft.EngineType? {
        switch aircraft.type.engineType {
            case .reciprocating:
                if aircraft.radial { return .radial }
                if aircraft.diesel { return .diesel }
                return .piston
            case .electric: return .electric
            case .jet: return .turbojet
            case .nonpowered: return .nonpowered
            case .turbofan: return .turbofan
            case .turboprop: return .turboprop
            case .turboshaft: return .turboshaft
            case .none: return nil
            default: throw Error.unsupportedEngineType(aircraft.type.engineType!)
        }
    }

    private func convertApproach(_ approach: LogTen.Approach) -> ForeFlight.Flight.Approach? {
        guard let type = approachType(for: approach),
              let place = approach.place,
              let count = approach.count else { return nil }
        return .init(count: count, type: type, runway: approach.runway, airport: place.ICAO_or_LID)
    }

    private func approachType(for approach: LogTen.Approach) -> ForeFlight.Flight.ApproachType? {
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
            case .none: return nil
        }
    }

    private func people(for entry: LogTen.Flight) -> [ForeFlight.Flight.Member] {
        var people = [ForeFlight.Flight.Member]()

        if let safetyPilot = entry.safetyPilot {
            people.append(convert(person: safetyPilot, role: .safetyPilot))
        }
        if let examiner = entry.examiner {
            people.append(convert(person: examiner, role: .examiner))
        }
        if let instructor = entry.instructor {
            people.append(convert(person: instructor, role: .instructor))
        }
        if let student = entry.student {
            people.append(convert(person: student, role: .student))
        }
        if let engineer = entry.flightEngineer {
            people.append(convert(person: engineer, role: .flightEngineer))
        }
        if let PIC = entry.PIC {
            let instructor = entry.instructor
            if !PIC.isMe && PIC != instructor {
                people.append(convert(person: PIC, role: .PIC))
            }
        }
        if let SIC = entry.SIC {
            let safetyPilot = entry.safetyPilot
            if SIC != safetyPilot {
                people.append(convert(person: SIC, role: .SIC))
            }
        }

        for attendant in entry.flightAttendants {
            people.append(convert(person: attendant, role: .flightAttendant))
        }

        for passenger in entry.passengers {
            people.append(convert(person: passenger, role: .passenger))
        }

        return people
    }

    private func convert(person: LogTen.Person, role: ForeFlight.Flight.Role) -> ForeFlight.Flight.Member {
        .init(person: .init(name: person.name, email: person.email),
              role: role)
    }

    private func isCheckride(_ entry: LogTen.Flight) -> Bool {
        entry.flightReview && entry.remarks?.localizedCaseInsensitiveContains("checkride") ?? false
    }
}
