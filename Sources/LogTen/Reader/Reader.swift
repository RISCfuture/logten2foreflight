import CoreData
import Foundation

/// Reads a LogTen Pro logbook from its Core Data store.
///
/// The `Reader` actor loads a LogTen Pro Core Data SQLite store and fetches all
/// flights, aircraft, and people records. It requires access to both the data store
/// file and the managed object model from the LogTen Pro application bundle.
///
/// ## Usage
///
/// ```swift
/// let reader = try await Reader(
///     storeURL: URL(filePath: "path/to/LogTenCoreDataStore.sql"),
///     modelURL: URL(filePath: "/Applications/LogTen.app/Contents/Resources/CNLogBookDocument.momd")
/// )
/// let logbook = try reader.read()
/// ```
package actor Reader {
  let container: NSPersistentContainer

  /// Creates a reader for the specified LogTen Pro Core Data store.
  ///
  /// - Parameters:
  ///   - storeURL: The URL to the LogTenCoreDataStore.sql file.
  ///   - modelURL: The URL to the CNLogBookDocument.momd managed object model.
  /// - Throws: ``Error/couldntCreateStore(path:)`` if the managed object model
  ///   cannot be loaded.
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

  /// Reads all logbook data from the Core Data store.
  ///
  /// This method fetches all aircraft, flights, and people from the LogTen Pro
  /// database and returns them in a ``Logbook`` container.
  ///
  /// - Returns: A ``Logbook`` containing all aircraft, flights, and people.
  /// - Throws: ``Error`` if required properties are missing from records.
  package func read() throws -> Logbook {
    let aircraft = try fetchAircraft()
    let flights = try fetchFlights(aircraft: aircraft)
    let people = try fetchPeople()

    return .init(aircraft: aircraft, flights: flights, people: people)
  }
}
