import Foundation

/// A person (crew member or passenger) in a LogTen Pro logbook.
///
/// A `Person` represents someone who appears in flight records, such as the PIC,
/// SIC, instructor, student, or passenger.
package struct Person: IdentifiableRecord {

  // MARK: Properties

  /// The unique identifier for this person (Core Data object URI).
  package let id: URL

  /// The person's name.
  package let name: String

  /// The person's email address, if available.
  package let email: String?

  /// Whether this person represents the logbook owner ("me").
  package let isMe: Bool

  // MARK: Initializers

  init?(person: CNPerson?) {
    guard let person else { return nil }
    id = person.objectID.uriRepresentation()
    name = person.person_name
    email = person.person_email
    isMe = person.person_isMe?.boolValue ?? false
  }
}
