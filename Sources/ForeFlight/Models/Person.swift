import Foundation

package struct Person {
  package private(set) var name: String
  package private(set) var email: String?

  package init(name: String, email: String? = nil) {
    self.name = name
    self.email = email
  }
}
