import CoreData
import Foundation

extension Reader {
  func fetchPeople() throws -> [Person] {
    let request = CNPerson.fetchRequest()
    let people = try container.viewContext.fetch(request)

    return people.compactMap { Person(person: $0) }
  }
}
