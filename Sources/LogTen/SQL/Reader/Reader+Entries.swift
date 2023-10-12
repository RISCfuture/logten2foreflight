import Foundation
import GRDB

let numPaxFields = 20
let numApproachFields = 10

extension Reader {
    private static let flightID = RawQueryField<Int64>(name: "ZFLIGHT.Z_PK")
    private static let date = ConvertedQueryField<Int64, Date>(name: "ZFLIGHT_FLIGHTDATE") { Date(timeIntervalSince2001: $0) }
    private static let aircraftID = OptionalQueryField<String>(name: "ZAIRCRAFT_AIRCRAFTID")
    private static let fromICAO = OptionalQueryField<String>(name: "ZPLACE_FROM.ZPLACE_ICAOID")
    private static let fromIdent = OptionalQueryField<String>(name: "ZPLACE_FROM.ZPLACE_IDENTIFIER")
    private static let toICAO = OptionalQueryField<String>(name: "ZPLACE_TO.ZPLACE_ICAOID")
    private static let toIdent = OptionalQueryField<String>(name: "ZPLACE_TO.ZPLACE_IDENTIFIER")
    private static let route = OptionalQueryField<String>(name: "ZFLIGHT_ROUTE")
    private static let out = OptionalConvertedQueryField<Int64, Date>(name: "ZFLIGHT_ACTUALDEPARTURETIME") { Date(timeIntervalSince2001: $0) }
    private static let off = OptionalConvertedQueryField<Int64, Date>(name: "ZFLIGHT_TAKEOFFTIME") { Date(timeIntervalSince2001: $0) }
    private static let on = OptionalConvertedQueryField<Int64, Date>(name: "ZFLIGHT_LANDINGTIME") { Date(timeIntervalSince2001: $0) }
    private static let `in` = OptionalConvertedQueryField<Int64, Date>(name: "ZFLIGHT_ACTUALARRIVALTIME") { Date(timeIntervalSince2001: $0) }
    private static let onDuty = OptionalConvertedQueryField<Int64, Date>(name: "ZFLIGHT_ONDUTYTIME") { Date(timeIntervalSince2001: $0) }
    private static let offDuty = OptionalConvertedQueryField<Int64, Date>(name: "ZFLIGHT_OFFDUTYTIME") { Date(timeIntervalSince2001: $0) }
    private static let totalTime = ConvertedQueryField<Int64?, UInt>(name: "ZFLIGHT_TOTALTIME") { $0 == nil ? 0 : UInt($0!) }
    private static let PICTime = ConvertedQueryField<Int64?, UInt>(name: "ZFLIGHT_PIC") { $0 == nil ? 0 : UInt($0!) }
    private static let SICTime = ConvertedQueryField<Int64?, UInt>(name: "ZFLIGHT_SIC") { $0 == nil ? 0 : UInt($0!) }
    private static let nightTime = ConvertedQueryField<Int64?, UInt>(name: "ZFLIGHT_NIGHT") { $0 == nil ? 0 : UInt($0!) }
    private static let soloTime = ConvertedQueryField<Int64?, UInt>(name: "ZFLIGHT_SOLO") { $0 == nil ? 0 : UInt($0!) }
    private static let xcTime = ConvertedQueryField<Int64?, UInt>(name: "ZFLIGHT_CROSSCOUNTRY") { $0 == nil ? 0 : UInt($0!) }
    private static let distance = OptionalQueryField<Double>(name: "ZFLIGHT_DISTANCE")
    private static let takeoffsDay = ConvertedQueryField<Int64?, UInt>(name: "ZFLIGHT_DAYTAKEOFFS") { $0 == nil ? 0 : UInt($0!) }
    private static let landingsDay = ConvertedQueryField<Int64?, UInt>(name: "ZFLIGHT_DAYLANDINGS") { $0 == nil ? 0 : UInt($0!) }
    private static let takeoffsNight = ConvertedQueryField<Int64?, UInt>(name: "ZFLIGHT_NIGHTTAKEOFFS") { $0 == nil ? 0 : UInt($0!) }
    private static let landingsNight = ConvertedQueryField<Int64?, UInt>(name: "ZFLIGHT_NIGHTLANDINGS") { $0 == nil ? 0 : UInt($0!) }
    private static let landingsFullStop = ConvertedQueryField<Int64?, UInt>(name: "ZFLIGHT_FULLSTOPS") { $0 == nil ? 0 : UInt($0!) }
    private static let landingsNightFullStop = ConvertedQueryField<Int64?, UInt>(name: "ZFLIGHT_CUSTOMLANDING1") { $0 == nil ? 0 : UInt($0!) }
    private static let actualInstrument = ConvertedQueryField<Int64?, UInt>(name: "ZFLIGHT_ACTUALINSTRUMENT") { $0 == nil ? 0 : UInt($0!) }
    private static let simulatedInstrument = ConvertedQueryField<Int64?, UInt>(name: "ZFLIGHT_SIMULATEDINSTRUMENT") { $0 == nil ? 0 : UInt($0!) }
    private static let hobbsStart = ConvertedQueryField<Double?, Double>(name: "ZFLIGHT_HOBBSSTART") { $0 ?? 0.0 }
    private static let hobbsEnd = ConvertedQueryField<Double?, Double>(name: "ZFLIGHT_HOBBSSTOP") { $0 ?? 0.0 }
    private static let tachStart = ConvertedQueryField<Double?, Double>(name: "ZFLIGHT_TACHSTART") { $0 ?? 0.0 }
    private static let tachEnd = ConvertedQueryField<Double?, Double>(name: "ZFLIGHT_TACHSTOP") { $0 ?? 0.0 }
    private static let holds = ConvertedQueryField<Int64?, UInt>(name: "ZFLIGHT_HOLDS") { $0 == nil ? 0 : UInt($0!) }
    private static let dualGiven = ConvertedQueryField<Int64?, UInt>(name: "ZFLIGHT_DUALGIVEN") { $0 == nil ? 0 : UInt($0!) }
    private static let dualReceived = ConvertedQueryField<Int64?, UInt>(name: "ZFLIGHT_DUALRECEIVED") { $0 == nil ? 0 : UInt($0!) }
    private static let simulator = ConvertedQueryField<Int64?, UInt>(name: "ZFLIGHT_SIMULATOR") { $0 == nil ? 0 : UInt($0!) }
    private static let ground = ConvertedQueryField<Int64?, UInt>(name: "ZFLIGHT_GROUND") { $0 == nil ? 0 : UInt($0!) }
    private static let remarks = OptionalQueryField<String>(name: "ZFLIGHT_REMARKS")
    private static let flightReview = BoolQueryField(name: "ZFLIGHT_REVIEW")
    private static let IPC = BoolQueryField(name: "ZFLIGHT_INSTRUMENTPROFICIENCYCHECK")
    private static let proficiencyCheck = BoolQueryField(name: "ZFLIGHT_CUSTOMNOTE1")
    private static let PIC_ID = OptionalQueryField<Int64>(name: "ZFLIGHTCREW_PIC")
    private static let SIC_ID = OptionalQueryField<Int64>(name: "ZFLIGHTCREW_SIC")
    private static let instructorID = OptionalQueryField<Int64>(name: "ZFLIGHTCREW_INSTRUCTOR")
    private static let studentID = OptionalQueryField<Int64>(name: "ZFLIGHTCREW_STUDENT")
    private static let safetyPilotID = OptionalQueryField<Int64>(name: "ZFLIGHTCREW_CUSTOM1")
    private static let examinerID = OptionalQueryField<Int64>(name: "ZFLIGHTCREW_CUSTOM2")
    private static let NVGTime = ConvertedQueryField<Int64?, UInt>(name: "ZFLIGHT_NIGHTVISIONGOGGLE") { $0 == nil ? 0 : UInt($0!) }
    private static let landingsNVG = ConvertedQueryField<Int64?, UInt>(name: "ZFLIGHT_NIGHTVISIONGOGGLELANDINGS") { $0 == nil ? 0 : UInt($0!) }
    private static let takeoffsNVG = ConvertedQueryField<Int64?, UInt>(name: "ZFLIGHT_NIGHTVISIONGOGGLETAKEOFFS") { $0 == nil ? 0 : UInt($0!) }
    
    
    private static let baseQueryFields: Array<any QueryField> = [
        flightID, date, aircraftID, fromICAO, fromIdent, toICAO, toIdent, route,
        out, off, on, `in`, onDuty, offDuty, totalTime, PICTime, SICTime,
        nightTime, soloTime, xcTime, distance, takeoffsDay, landingsDay,
        takeoffsNight, landingsNight, landingsFullStop, landingsNightFullStop,
        actualInstrument, simulatedInstrument, hobbsStart, hobbsEnd, tachStart,
        tachEnd, holds, dualGiven, dualReceived, simulator, ground, remarks,
        flightReview, IPC, proficiencyCheck, PIC_ID, SIC_ID, instructorID,
        studentID, safetyPilotID, examinerID, NVGTime, landingsNVG, takeoffsNVG
    ]
    private static let approachFields = (1...numApproachFields).map { OptionalQueryField<Int64>(name: "ZFLIGHTAPPROACHES_APPROACH\($0)") }
    private static let paxFields = (1...numPaxFields).map { OptionalQueryField<Int64>(name: "ZFLIGHTPASSENGERS_PAX\($0)") }
    private static let queryFields = baseQueryFields + approachFields + paxFields
    
    private static let query = """
    SELECT \(queryFields.map { $0.queryName }.joined(separator: ", "))
    FROM ZFLIGHT
    LEFT OUTER JOIN ZPLACE AS ZPLACE_FROM
        ON ZPLACE_FROM.Z_PK = ZFLIGHT_FROMPLACE
    LEFT OUTER JOIN ZPLACE AS ZPLACE_TO
        ON ZPLACE_TO.Z_PK = ZFLIGHT_TOPLACE
    LEFT OUTER JOIN ZFLIGHTCREW
        ON ZFLIGHTCREW_FLIGHT = ZFLIGHT.Z_PK
    LEFT OUTER JOIN ZAIRCRAFT
        ON ZAIRCRAFT.Z_PK = ZFLIGHT_AIRCRAFT
    LEFT OUTER JOIN ZFLIGHTAPPROACHES
        ON ZFLIGHTAPPROACHES.ZFLIGHTAPPROACHES_FLIGHT = ZFLIGHT.Z_PK
    LEFT OUTER JOIN ZFLIGHTPASSENGERS
        ON ZFLIGHTPASSENGERS.ZFLIGHTPASSENGERS_FLIGHT = ZFLIGHT.Z_PK
    """
    
    package func getEntries(people: Dictionary<Int64, Person>? = nil) throws -> Array<Entry> {
        let people = try people ?? getPeople()
        var entries = Array<Entry>()
        
        try dbQueue.read { db in
            let rows = try Row.fetchCursor(db, sql: Self.query)
            while let row = try rows.next() {
                let flightID = try Self.flightID.value(from: row)
                let date = try Self.date.value(from: row)
                let aircraftID = try Self.aircraftID.value(from: row)
                let fromICAO = try Self.fromICAO.value(from: row)
                let fromIdent = try Self.fromIdent.value(from: row)
                let toICAO = try Self.toICAO.value(from: row)
                let toIdent = try Self.toIdent.value(from: row)
                let route = try Self.route.value(from: row)
                let out = try Self.out.value(from: row)
                let off = try Self.off.value(from: row)
                let on = try Self.on.value(from: row)
                let `in` = try Self.`in`.value(from: row)
                let onDuty = try Self.onDuty.value(from: row)
                let offDuty = try Self.offDuty.value(from: row)
                let totalTime = try Self.totalTime.value(from: row)
                let PICTime = try Self.PICTime.value(from: row)
                let SICTime = try Self.SICTime.value(from: row)
                let nightTime = try Self.nightTime.value(from: row)
                let soloTime = try Self.soloTime.value(from: row)
                let xcTime = try Self.xcTime.value(from: row)
                let distance = try Self.distance.value(from: row)
                let takeoffsDay = try Self.takeoffsDay.value(from: row)
                let landingsDay = try Self.landingsDay.value(from: row)
                let takeoffsNight = try Self.takeoffsNight.value(from: row)
                let landingsNight = try Self.landingsNight.value(from: row)
                let landingsFullStop = try Self.landingsFullStop.value(from: row)
                let landingsNightFullStop = try Self.landingsNightFullStop.value(from: row)
                let actualInstrument = try Self.actualInstrument.value(from: row)
                let simulatedInstrument = try Self.simulatedInstrument.value(from: row)
                let hobbsStart = try Self.hobbsStart.value(from: row)
                let hobbsEnd = try Self.hobbsEnd.value(from: row)
                let tachStart = try Self.tachStart.value(from: row)
                let tachEnd = try Self.tachEnd.value(from: row)
                let holds = try Self.holds.value(from: row)
                let dualGiven = try Self.dualGiven.value(from: row)
                let dualReceived = try Self.dualReceived.value(from: row)
                let simulator = try Self.simulator.value(from: row)
                let ground = try Self.ground.value(from: row)
                let remarks = try Self.remarks.value(from: row)
                let flightReview = try Self.flightReview.value(from: row)
                let IPC = try Self.IPC.value(from: row)
                let proficiencyCheck = try Self.proficiencyCheck.value(from: row)
                let PIC_ID = try Self.PIC_ID.value(from: row)
                let SIC_ID = try Self.SIC_ID.value(from: row)
                let instructorID = try Self.instructorID.value(from: row)
                let studentID = try Self.studentID.value(from: row)
                let safetyPilotID = try Self.safetyPilotID.value(from: row)
                let examinerID = try Self.examinerID.value(from: row)
                let NVGTime = try Self.NVGTime.value(from: row)
                let landingsNVG = try Self.landingsNVG.value(from: row)
                let takeoffsNVG = try Self.takeoffsNVG.value(from: row)
                
                var members = Array<Entry.Member>()
                if let safetyPilot = member(for: safetyPilotID, in: people, role: .safetyPilot) {
                    members.append(safetyPilot)
                }
                if let examiner = member(for: examinerID, in: people, role: .examiner) {
                    members.append(examiner)
                }
                if let instructor = member(for: instructorID, in: people, role: .instructor) {
                    members.append(instructor)
                }
                if let student = member(for: studentID, in: people, role: .student) {
                    members.append(student)
                }
                if let PIC = member(for: PIC_ID, in: people, role: .PIC) {
                    if !members.contains(where: { $0.person.id == PIC_ID }) {
                        members.append(PIC)
                    }
                }
                if let SIC = member(for: SIC_ID, in: people, role: .SIC) {
                    if !members.contains(where: { $0.person.id == SIC_ID }) {
                        members.append(SIC)
                    }
                }
                for paxID in try getPassengerIDs(in: db, for: flightID) {
                    if let pax = member(for: paxID, in: people, role: .passenger) {
                        members.append(pax)
                    }
                }
                
                let approachIDs = try Self.approachFields.compactMap { try $0.value(from: row) }
                
                entries.append(.init(date: date,
                                     out: out,
                                     off: off,
                                     on: on,
                                     in: `in`,
                                     onDuty: onDuty,
                                     offDuty: offDuty,
                                     hobbsStart: hobbsStart,
                                     hobbsEnd: hobbsEnd,
                                     tachStart: tachStart,
                                     tachEnd: tachEnd,
                                     aircraft: aircraftID,
                                     from: fromICAO ?? fromIdent,
                                     to: toICAO ?? toIdent,
                                     route: route,
                                     distance: distance,
                                     totalTime: totalTime,
                                     PICTime: PICTime,
                                     SICTime: SICTime,
                                     soloTime: soloTime,
                                     nightTime: nightTime,
                                     crossCountryTime: xcTime,
                                     dualGivenTime: dualGiven,
                                     dualReceivedTime: dualReceived,
                                     actualInstrumentTime: actualInstrument,
                                     simulatedInstrumentTime: simulatedInstrument,
                                     simulatorTime: simulator,
                                     groundTime: ground,
                                     NVGTime: NVGTime,
                                     takeoffsDay: takeoffsDay,
                                     takeoffsNight: takeoffsNight,
                                     landingsDay: landingsDay,
                                     landingsNight: landingsNight,
                                     landingsFullStop: landingsFullStop,
                                     landingsNightFullStop: landingsNightFullStop,
                                     takeoffsNVG: takeoffsNVG,
                                     landingsNVG: landingsNVG,
                                     holds: holds,
                                     approaches: try getApproaches(in: db, IDs: approachIDs),
                                     members: members,
                                     flightReview: flightReview,
                                     IPC: IPC,
                                     proficiencyCheck: proficiencyCheck,
                                     remarks: remarks))
            }
        }
        
        return entries
    }
    
    private func member(`for` personID: Int64?, in people: Dictionary<Int64, Person>, role: Entry.Role) -> Entry.Member? {
        guard let personID = personID else { return nil }
        guard let person = people[personID] else { return nil }
        if role == .PIC && person.isMe { return nil }
        
        return .init(person: person, role: role)
    }
}
