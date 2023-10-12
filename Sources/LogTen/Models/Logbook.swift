import Foundation

public struct Logbook {
    package private(set) var entries = Array<Entry>()
    package private(set) var aircraft = Array<Aircraft>()
    package private(set) var people = Array<Person>()
}
