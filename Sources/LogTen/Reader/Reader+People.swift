import Foundation
import CoreData

extension Reader {
    func fetchPeople() throws -> Array<Person> {
        let request = CNPerson.fetchRequest()
        let people = try container.viewContext.fetch(request)
        
        return people.compactMap { Person(person: $0) }
    }
}
