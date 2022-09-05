import Foundation

public struct Person {
    public private(set) var name: String
    public private(set) var email: String?
    
    public init(name: String, email: String? = nil) {
        self.name = name
        self.email = email
    }
}
