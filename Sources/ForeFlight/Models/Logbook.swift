import Foundation

public struct Logbook {
    package var entries = Array<Entry>()
    package var aircraft = Array<Aircraft>()
    package var people = Array<Person>()
    
    package init() {}
}
