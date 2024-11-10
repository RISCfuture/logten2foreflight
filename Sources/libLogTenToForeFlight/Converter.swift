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

    public func convert() async -> ForeFlight.Logbook {
        let FFLogbook = ForeFlight.Logbook()

        for person in await LTPLogbook.people.sorted(by: { $0.name < $1.name }) {
            await FFLogbook.add(person: convert(person: person))
        }

        for aircraft in await LTPLogbook.aircraft.sorted(by: { $0.tailNumber < $1.tailNumber }) {
            await FFLogbook.add(aircraft: convert(aircraft: aircraft))
        }

        for entry in await LTPLogbook.flights.sorted(by: { $0.date < $1.date }) {
            guard let converted = await convert(entry: entry) else { continue }
            await FFLogbook.add(entry: converted)
        }

        return FFLogbook
    }

    private func convert(person: LogTen.Person) -> ForeFlight.Person {
        .init(name: person.name,
              email: person.email)
    }

    private func convert(aircraft: LogTen.Aircraft) async -> ForeFlight.Aircraft {
        let type = await LTPLogbook.type(for: aircraft)

        return .init(tailNumber: aircraft.tailNumber,
                     simulatorType: simulatorType(for: type),
                     typeCode: typeCode(for: type),
                     year: aircraft.year,
                     make: type.make,
                     model: type.model,
                     category: category(for: type),
                     class: `class`(for: type),
                     gearType: gearType(for: aircraft, type: type),
                     engineType: engineType(for: aircraft, type: type),
                     complex: aircraft.complex,
                     highPerformance: aircraft.highPerformance,
                     pressurized: aircraft.pressurized,
                     technicallyAdvanced: aircraft.technicallyAdvanced)
    }

    private func convert(entry: LogTen.Flight) async -> ForeFlight.Flight? {
        guard let aircraft = await LTPLogbook.aircraft(for: entry) else { return nil }
        let from = await LTPLogbook.origin(for: entry),
            to = await LTPLogbook.destination(for: entry),
            approaches = await approaches(for: entry),
            people = await people(for: entry)

        return .init(date: entry.date,
                     aircraftID: aircraft.tailNumber,
                     from: from?.ICAO_or_LID,
                     to: to?.ICAO_or_LID,
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
                     approaches: approaches,
                     dualGiven: entry.dualGivenHours,
                     dualReceived: entry.dualReceivedHours,
                     simulatorTime: entry.simulatorHours,
                     groundTime: entry.groundHours,
                     people: people,
                     flightReview: entry.flightReview,
                     checkride: isCheckride(entry),
                     IPC: entry.IPC,
                     NVGProficiency: false,
                     recurrent: entry.proficiencyCheck,
                     remarks: entry.remarks)
    }

    private func typeCode(for type: LogTen.AircraftType) -> String? {
        for (`prefix`, FAAType) in Self.typeOverrides {
            if type.typeCode.hasPrefix(`prefix`) { return FAAType }
        }
        return type.typeCode
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

    private func category(for type: LogTen.AircraftType) -> ForeFlight.Aircraft.Category {
        switch type.category {
            case .airplane: return .airplane
            case .glider: return .glider
            case .simulator: return .simulator
        }
    }

    private func `class`(for type: LogTen.AircraftType) -> ForeFlight.Aircraft.Class? {
        switch type.category {
            case .airplane:
                switch type.class {
                    case .airplaneSingleEngineLand: return .singleEngineLand
                    case .airplaneSingleEngineSea: return .singleEngineSea
                    case .airplaneMultiEngineLand: return .multiEngineLand
                    case .airplaneMultiEngineSea: return .multiEngineSea
                    case .none: return nil
                }
            case .glider: return .glider
            case .simulator:
                switch type.simulatorType {
                    case .BATD: return .ATD
                    case .AATD: return .ATD
                    case .FTD: return .FTD
                    case .FFS: return .FFS
                    case .none: return nil
                }
        }
    }

    private func gearType(for aircraft: LogTen.Aircraft, type: LogTen.AircraftType) -> ForeFlight.Aircraft.GearType? {
        switch type.simulatorType {
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

    private func engineType(for aircraft: LogTen.Aircraft, type: LogTen.AircraftType) -> ForeFlight.Aircraft.EngineType? {
        switch type.engineType {
            case .piston:
                if aircraft.radial { return .radial }
                if Self.dieselAircraft.contains(type.model) { return .diesel }
                else { return .piston }
            case .nonpowered: return .nonpowered
            case .turbofan: return .turbofan
            case .none: return nil
        }
    }

    private func approaches(for entry: LogTen.Flight) async -> Array<ForeFlight.Flight.Approach> {
        let flightApproaches = await LTPLogbook.approaches(for: entry)
        var approaches = Array<ForeFlight.Flight.Approach>()
        for approach in flightApproaches {
            guard let type = approachType(for: approach),
                  let place = await LTPLogbook.place(for: approach),
                  let count = approach.count else { continue }
            approaches.append(.init(count: count,
                                    type: type,
                                    runway: approach.runway,
                                    airport: place.ICAO_or_LID))
        }
        return approaches
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

    private func people(for entry: LogTen.Flight) async -> Array<ForeFlight.Flight.Member> {
        var people = Array<ForeFlight.Flight.Member>()

        if let safetyPilot = await LTPLogbook.safetyPilot(for: entry) {
            people.append(convert(person: safetyPilot, role: .safetyPilot))
        }
        if let examiner = await LTPLogbook.examiner(for: entry) {
            people.append(convert(person: examiner, role: .examiner))
        }
        if let instructor = await LTPLogbook.instructor(for: entry) {
            people.append(convert(person: instructor, role: .instructor))
        }
        if let student = await LTPLogbook.student(for: entry) {
            people.append(convert(person: student, role: .student))
        }
        if let PIC = await LTPLogbook.PIC(for: entry) {
            let instructor = await LTPLogbook.instructor(for: entry)
            if !PIC.isMe && PIC != instructor {
                people.append(convert(person: PIC, role: .PIC))
            }
        }
        if let SIC = await LTPLogbook.SIC(for: entry) {
            let safetyPilot = await LTPLogbook.safetyPilot(for: entry)
            if SIC != safetyPilot {
                people.append(convert(person: SIC, role: .SIC))
            }
        }

        for passenger in await LTPLogbook.passengers(for: entry) {
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
