import Foundation
import GRDB
import Dispatch

fileprivate var instanceCounter = 0
fileprivate let instanceCounterMutex = DispatchSemaphore(value: 1)

fileprivate func names(for name: String) -> (String, String) {
    instanceCounterMutex.wait()
    let counter = instanceCounter
    instanceCounter += 1
    instanceCounterMutex.signal()
    
    let strippedName = name.split(separator: ".").last!
    let rowName = "\(strippedName)_\(counter)"
    let queryName = "\(name) AS \(rowName)"
    
    return (rowName, queryName)
}

protocol QueryField {
    associatedtype RawType
    associatedtype ConvertedType
    
    var rowName: String { get }
    var queryName: String { get }
    
    func value(from row: Row) throws -> ConvertedType
}

struct RawQueryField<RawType>: QueryField {
    let name: String
    let rowName: String
    let queryName: String
    
    init(name: String) {
        self.name = name
        (rowName, queryName) = names(for: name)
    }
    
    func value(from row: Row) throws -> RawType {
        guard let raw = row[rowName] as? RawType else {
            throw Error.missingLogTenValue(field: name)
        }
        return raw
    }
}

extension RawQueryField where RawType == Bool {
    func value(from row: Row) throws -> Bool {
        guard let raw = row[rowName] as? RawType else { return false }
        return raw
    }
}

struct ConvertedQueryField<RawType, ConvertedType>: QueryField {
    let name: String
    let rowName: String
    let queryName: String
    private let convertFunction: (RawType) -> ConvertedType
    
    init(name: String, convert: @escaping (RawType) -> ConvertedType) {
        self.name = name
        self.convertFunction = convert
        (rowName, queryName) = names(for: name)
    }
    
    func value(from row: Row) throws -> ConvertedType {
        guard let raw = row[rowName] as? RawType else {
            throw Error.missingLogTenValue(field: name)
        }
        return convertFunction(raw)
    }
}

struct OptionalQueryField<RawType>: QueryField {
    var name: String
    let rowName: String
    let queryName: String
    
    init(name: String) {
        self.name = name
        (rowName, queryName) = names(for: name)
    }
    
    func value(from row: Row) throws -> RawType? {
        guard let raw = row[rowName] as? RawType else { return nil }
        return raw
    }
}

struct OptionalConvertedQueryField<RawType, ConvertedType>: QueryField {
    var name: String
    let rowName: String
    let queryName: String
    private let convertFunction: (RawType) -> ConvertedType
    
    init(name: String, convert: @escaping (RawType) -> ConvertedType) {
        self.name = name
        self.convertFunction = convert
        (rowName, queryName) = names(for: name)
    }
    
    func value(from row: Row) throws -> ConvertedType? {
        guard let raw = row[rowName] as? RawType else { return nil }
        return convertFunction(raw)
    }
}

struct EnumQueryField<RawType, ConvertedType: RawRepresentable>: QueryField where ConvertedType.RawValue == RawType {
    var name: String
    let rowName: String
    let queryName: String
    
    init(name: String) {
        self.name = name
        (rowName, queryName) = names(for: name)
    }
    
    func value(from row: Row) throws -> ConvertedType {
        guard let raw = row[rowName] as? RawType else {
            throw Error.missingLogTenValue(field: name)
        }
        guard let converted = ConvertedType(rawValue: raw) else {
            throw Error.unknownLogTenValue(raw, field: name)
        }
        
        return converted
    }
}

struct OptionalEnumQueryField<RawType, ConvertedType: RawRepresentable>: QueryField where ConvertedType.RawValue == RawType {
    var name: String
    let rowName: String
    let queryName: String
    
    init(name: String) {
        self.name = name
        (rowName, queryName) = names(for: name)
    }
    
    func value(from row: Row) throws -> ConvertedType? {
        guard let raw = row[rowName] as? RawType else { return nil }
        guard let converted = ConvertedType(rawValue: raw) else {
            throw Error.unknownLogTenValue(raw, field: name)
        }
        
        return converted
    }
}

struct BoolQueryField: QueryField {
    typealias RawType = Int64
    typealias ConvertedType = Bool
    
    var name: String
    let rowName: String
    let queryName: String
    
    init(name: String) {
        self.name = name
        (rowName, queryName) = names(for: name)
    }
    
    func value(from row: Row) throws -> Bool {
        guard let raw = row[rowName] as? RawType else { return false }
        return raw != 0
    }
}
