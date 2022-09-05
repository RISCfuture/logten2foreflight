import Foundation
import GRDB

extension Reader {
    private static let ID = RawQueryField<Int64>(name: "Z_PK")
    private static let name = RawQueryField<String>(name: "ZPERSON_NAME")
    private static let email = OptionalQueryField<String>(name: "ZPERSON_EMAIL")
    private static let isMe = BoolQueryField(name: "ZPERSON_ISME")
    
    private static let queryFields: Array<any QueryField> = [ID, name, email, isMe]
    
    private static let query = """
    SELECT \(queryFields.map { $0.queryName }.joined(separator: ", "))
    FROM ZPERSON
    """
    
    func getPeople() throws -> Dictionary<Int64, Person> {
        var people = Dictionary<Int64, Person>()
        
        try dbQueue.read { db in
            let rows = try Row.fetchCursor(db, sql: Self.query)
            while let row = try rows.next() {
                let ID: Int64 = try Self.ID.value(from: row)
                let name: String = try Self.name.value(from: row)
                let email: String? = try Self.email.value(from: row)
                let isMe: Bool = try Self.isMe.value(from: row)
                
                people[ID] = Person(id: ID, name: name, email: email, isMe: isMe)
            }
        }
        
        return people
    }
}
