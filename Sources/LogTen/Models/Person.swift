import Foundation

package struct Person: Identifiable {
    package private(set) var id: Int64
    package private(set) var name: String
    package private(set) var email: String?
    package private(set) var isMe = false
}
