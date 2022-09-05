import Foundation

public struct Person: Identifiable {
    public private(set) var id: Int64
    public private(set) var name: String
    public private(set) var email: String?
    public private(set) var isMe = false
}
