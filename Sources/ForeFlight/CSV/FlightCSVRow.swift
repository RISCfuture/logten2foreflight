import Foundation
import StreamingCSV

@CSVRowBuilder
package struct FlightCSVRow {
  @Field package var date: DateOnly
  @Field package var aircraftID: String?
  @Field package var from: String?
  @Field package var to: String?
  @Field package var route: String?
  @Field package var timeOut: TimeOnly?
  @Field package var timeOff: TimeOnly?
  @Field package var timeOn: TimeOnly?
  @Field package var timeIn: TimeOnly?
  @Field package var onDuty: TimeOnly?
  @Field package var offDuty: TimeOnly?
  @Field package var totalTime: Double
  @Field package var pic: Double
  @Field package var sic: Double
  @Field package var night: Double
  @Field package var solo: Double
  @Field package var crossCountry: Double
  @Field package var picus: Double
  @Field package var multiPilot: Double
  @Field package var ifr: Double
  @Field package var examiner: Double
  @Field package var nvg: Double
  @Field package var nvgOps: UInt
  @Field package var distance: Double?
  @Field package var dayTakeoffs: UInt
  @Field package var dayLandingsFullStop: UInt
  @Field package var nightTakeoffs: UInt
  @Field package var nightLandingsFullStop: UInt
  @Field package var allLandings: UInt
  @Field package var actualInstrument: Double
  @Field package var simulatedInstrument: Double
  @Field package var groundTraining: Double
  @Field package var groundTrainingGiven: Double
  @Field package var hobbsStart: Double?
  @Field package var hobbsEnd: Double?
  @Field package var tachStart: Double?
  @Field package var tachEnd: Double?
  @Field package var holds: UInt
  @Field package var approach1: Flight.Approach?
  @Field package var approach2: Flight.Approach?
  @Field package var approach3: Flight.Approach?
  @Field package var approach4: Flight.Approach?
  @Field package var approach5: Flight.Approach?
  @Field package var approach6: Flight.Approach?
  @Field package var dualGiven: Double
  @Field package var dualReceived: Double
  @Field package var simulatedFlight: Double
  @Field package var instructorName: String?
  @Field package var instructorComments: String?
  @Field package var person1: Flight.Member?
  @Field package var person2: Flight.Member?
  @Field package var person3: Flight.Member?
  @Field package var person4: Flight.Member?
  @Field package var person5: Flight.Member?
  @Field package var person6: Flight.Member?
  @Field package var pilotComments: String?
  @Field package var flightReview: CSVBool
  @Field package var ipc: CSVBool
  @Field package var checkride: CSVBool
  @Field package var faa6158: CSVBool
  @Field package var nvgProficiency: CSVBool
  @Field package var textCustomFieldName: String?
  @Field package var numericCustomFieldName: Double?
  @Field package var hoursCustomFieldName: Double?
  @Field package var counterCustomFieldName: UInt?
  @Field package var dateCustomFieldName: DateOnly?
  @Field package var dateTimeCustomFieldName: DateOnly?
  @Field package var toggleCustomFieldName: CSVBool?

  package init(from flight: Flight) {
    self.date = flight.dateFormatted
    self.aircraftID = flight.aircraftID
    self.from = flight.from
    self.to = flight.to
    self.route = flight.route
    self.timeOut = flight.outFormatted
    self.timeOff = flight.offFormatted
    self.timeOn = flight.onFormatted
    self.timeIn = flight.inFormatted
    self.onDuty = flight.onDutyFormatted
    self.offDuty = flight.offDutyFormatted
    self.totalTime = flight.totalTime
    self.pic = flight.PICTime
    self.sic = flight.SICTime
    self.night = flight.nightTime
    self.solo = flight.soloTime
    self.crossCountry = flight.crossCountryTime
    self.picus = flight.PICUSTime  // Already treated as PIC in Converter
    self.multiPilot = flight.multiPilotTime  // Already calculated in Converter
    self.ifr = 0  // Not tracked in LogTen
    self.examiner = flight.examinerTime  // Already calculated in Converter
    self.nvg = flight.NVGTime
    self.nvgOps = flight.NVGOps
    self.distance = flight.distance
    self.dayTakeoffs = flight.takeoffsDay
    self.dayLandingsFullStop = flight.landingsDayFullStop
    self.nightTakeoffs = flight.takeoffsNight
    self.nightLandingsFullStop = flight.landingsNightFullStop
    self.allLandings = flight.landingsAll
    self.actualInstrument = flight.actualInstrumentTime
    self.simulatedInstrument = flight.simulatedInstrumentTime
    self.groundTraining = flight.groundTime
    self.groundTrainingGiven = 0  // Not tracked in LogTen
    self.hobbsStart = flight.hobbsStart
    self.hobbsEnd = flight.hobbsEnd
    self.tachStart = flight.tachStart
    self.tachEnd = flight.tachEnd
    self.holds = flight.holds
    self.approach1 = flight.approach1
    self.approach2 = flight.approach2
    self.approach3 = flight.approach3
    self.approach4 = flight.approach4
    self.approach5 = flight.approach5
    self.approach6 = flight.approach6
    self.dualGiven = flight.dualGiven
    self.dualReceived = flight.dualReceived
    self.simulatedFlight = flight.simulatorTime
    self.groundTraining = flight.groundTime
    self.instructorName = nil  // These fields are not in the Flight model
    self.instructorComments = nil
    self.person1 = flight.person1
    self.person2 = flight.person2
    self.person3 = flight.person3
    self.person4 = flight.person4
    self.person5 = flight.person5
    self.person6 = flight.person6
    self.flightReview = CSVBool(flight.flightReview)
    self.checkride = CSVBool(flight.checkride)
    self.ipc = CSVBool(flight.IPC)
    self.nvgProficiency = CSVBool(flight.NVGProficiency)
    self.faa6158 = CSVBool(flight.recurrent)
    self.textCustomFieldName = nil  // Custom fields not implemented
    self.numericCustomFieldName = nil
    self.hoursCustomFieldName = nil
    self.counterCustomFieldName = nil
    self.dateCustomFieldName = nil
    self.dateTimeCustomFieldName = nil
    self.toggleCustomFieldName = nil
    self.pilotComments = flight.remarks
  }
}
