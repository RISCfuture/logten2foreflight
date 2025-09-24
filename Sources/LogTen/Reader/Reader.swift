import CoreData
import Foundation

package actor Reader {
  let container: NSPersistentContainer

  package init(storeURL: URL, modelURL: URL) async throws {
    guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
      throw Error.couldntCreateStore(path: modelURL)
    }
    container = NSPersistentContainer(name: "LogTen Pro", managedObjectModel: managedObjectModel)

    let store = NSPersistentStoreDescription(url: storeURL)
    store.setOption(NSNumber(value: true), forKey: NSReadOnlyPersistentStoreOption)
    store.setOption(["journal_mode": "DELETE"] as NSObject, forKey: NSSQLitePragmasOption)

    try await withCheckedThrowingContinuation {
      (continuation: CheckedContinuation<Void, Swift.Error>) in
      container.persistentStoreDescriptions = [store]
      container.loadPersistentStores { _, error in
        if let error {
          continuation.resume(throwing: error)
        } else {
          continuation.resume(returning: ())
        }
      }
    }
  }

  package func read() throws -> Logbook {
    let aircraft = try fetchAircraft()
    let flights = try fetchFlights(aircraft: aircraft)
    let people = try fetchPeople()

    return .init(aircraft: aircraft, flights: flights, people: people)
  }
}
