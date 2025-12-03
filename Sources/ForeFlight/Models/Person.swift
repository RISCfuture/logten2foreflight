import Foundation

/// A person (crew member or passenger) in ForeFlight's logbook format.
package struct Person {
  /// The person's name.
  package private(set) var name: String

  /// The person's email address, if available.
  package private(set) var email: String?

  /// Creates a person record.
  /// - Parameters:
  ///   - name: The person's name.
  ///   - email: The person's email address.
  package init(name: String, email: String? = nil) {
    self.name = name
    self.email = email
  }
}
