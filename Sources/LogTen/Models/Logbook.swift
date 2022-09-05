import Foundation

public struct Logbook {
    public private(set) var entries = Array<Entry>()
    public private(set) var aircraft = Array<Aircraft>()
    public private(set) var people = Array<Person>()
}
