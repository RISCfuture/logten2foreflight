import Foundation
@preconcurrency import GRDB
import LogTenToForeFlightMacros

@QueryObject
package struct Flight: Model, Identifiable, Hashable, Equatable {

    // MARK: Columns

    @QueryField(column: "Z_PK") package let id: Int64
    @QueryField(column: "ZFLIGHT_AIRCRAFT") package let aircraftID: Int64?

    @QueryField(column: "ZFLIGHT_FLIGHTDATE", convert: { Self.parseDate($0)! })
    package let date: Date
    @QueryField(column: "ZFLIGHT_ACTUALDEPARTURETIME", convert: { Self.parseDate($0) })
    package let out: Date?
    @QueryField(column: "ZFLIGHT_TAKEOFFTIME", convert: { Self.parseDate($0) })
    package let off: Date?
    @QueryField(column: "ZFLIGHT_LANDINGTIME", convert: { Self.parseDate($0) })
    package let on: Date?
    @QueryField(column: "ZFLIGHT_ACTUALARRIVALTIME", convert: { Self.parseDate($0) })
    package let `in`: Date?
    @QueryField(column: "ZFLIGHT_ONDUTYTIME", convert: { Self.parseDate($0) })
    package let onDuty: Date?
    @QueryField(column: "ZFLIGHT_OFFDUTYTIME", convert: { Self.parseDate($0) })
    package let offDuty: Date?
    @QueryField(column: "ZFLIGHT_HOBBSSTART") package let hobbsStart: Double?
    @QueryField(column: "ZFLIGHT_HOBBSSTOP") package let hobbsEnd: Double?
    @QueryField(column: "ZFLIGHT_TACHSTART") package let tachStart: Double?
    @QueryField(column: "ZFLIGHT_TACHSTOP") package let tachEnd: Double?

    @QueryField(column: "ZFLIGHT_FROMPLACE") package let originID: Int64?
    @QueryField(column: "ZFLIGHT_TOPLACE") package let destinationID: Int64?
    @QueryField(column: "ZFLIGHT_ROUTE") package let route: String?
    @QueryField(column: "ZFLIGHT_DISTANCE") package let distance: Double?

    @QueryField(column: "ZFLIGHT_TOTALTIME", convert: { UInt($0 ?? 0) })
    package let totalTime: UInt // minutes
    @QueryField(column: "ZFLIGHT_PIC", convert: { UInt($0 ?? 0) })
    package let PICTime: UInt // minutes
    @QueryField(column: "ZFLIGHT_SIC", convert: { UInt($0 ?? 0) })
    package let SICTime: UInt // minutes
    @QueryField(column: "ZFLIGHT_SOLO", convert: { UInt($0 ?? 0) })
    package let soloTime: UInt // minutes
    @QueryField(column: "ZFLIGHT_NIGHT", convert: { UInt($0 ?? 0) })
    package let nightTime: UInt // minutes
    @QueryField(column: "ZFLIGHT_CROSSCOUNTRY", convert: { UInt($0 ?? 0) })
    package let crossCountryTime: UInt // minutes
    @QueryField(column: "ZFLIGHT_DUALGIVEN", convert: { UInt($0 ?? 0) })
    package let dualGivenTime: UInt // minutes
    @QueryField(column: "ZFLIGHT_DUALRECEIVED", convert: { UInt($0 ?? 0) })
    package let dualReceivedTime: UInt // minutes
    @QueryField(column: "ZFLIGHT_ACTUALINSTRUMENT", convert: { UInt($0 ?? 0) })
    package let actualInstrumentTime: UInt // minutes
    @QueryField(column: "ZFLIGHT_SIMULATEDINSTRUMENT", convert: { UInt($0 ?? 0) })
    package let simulatedInstrumentTime: UInt // minutes
    @QueryField(column: "ZFLIGHT_SIMULATOR", convert: { UInt($0 ?? 0) })
    package let simulatorTime: UInt // minutes
    @QueryField(column: "ZFLIGHT_GROUND", convert: { UInt($0 ?? 0) })
    package let groundTime: UInt // minutes
    @QueryField(column: "ZFLIGHT_NIGHTVISIONGOGGLE", convert: { UInt($0 ?? 0) })
    package let NVGTime: UInt // minutes

    @QueryField(column: "ZFLIGHT_DAYTAKEOFFS", convert: { UInt($0 ?? 0) })
    package let takeoffsDay: UInt
    @QueryField(column: "ZFLIGHT_NIGHTTAKEOFFS", convert: { UInt($0 ?? 0) })
    package let takeoffsNight: UInt
    @QueryField(column: "ZFLIGHT_DAYLANDINGS", convert: { UInt($0 ?? 0) })
    package let landingsDay: UInt
    @QueryField(column: "ZFLIGHT_NIGHTLANDINGS", convert: { UInt($0 ?? 0) })
    package let landingsNight: UInt
    @QueryField(column: "ZFLIGHT_FULLSTOPS", convert: { UInt($0 ?? 0) })
    package let landingsFullStop: UInt
    @QueryField(column: "ZFLIGHT_CUSTOMLANDING1", convert: { UInt($0 ?? 0) })
    package let landingsNightFullStop: UInt
    @QueryField(column: "ZFLIGHT_NIGHTVISIONGOGGLETAKEOFFS", convert: { UInt($0 ?? 0) })
    package let takeoffsNVG: UInt
    @QueryField(column: "ZFLIGHT_NIGHTVISIONGOGGLELANDINGS", convert: { UInt($0 ?? 0) })
    package let landingsNVG: UInt

    @QueryField(column: "ZFLIGHT_HOLDS", convert: { UInt($0 ?? 0) })
    package let holds: UInt

    @QueryField(column: "ZFLIGHT_REVIEW", convert: { $0 ?? false })
    package let flightReview: Bool
    @QueryField(column: "ZFLIGHT_INSTRUMENTPROFICIENCYCHECK", convert: { $0 ?? false })
    package let IPC: Bool
    @QueryField(column: "ZFLIGHT_CUSTOMNOTE1", convert: { $0 ?? false })
    package let proficiencyCheck: Bool

    @QueryField(column: "ZFLIGHT_REMARKS") package let remarks: String?

    // MARK: Computed properties

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

    // MARK: Database config

    static package let databaseTableName = "ZFLIGHT"
}
