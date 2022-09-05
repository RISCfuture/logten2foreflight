import Foundation

let zulu = TimeZone(secondsFromGMT: 0)!
let referenceDate = DateComponents(calendar: .current, timeZone: zulu, year: 2001, month: 1, day: 1).date!

extension Date {
    init(timeIntervalSince2001 interval: Int64) {
        self = .init(timeInterval: Double(interval), since: referenceDate)
    }
}
