import Foundation
import StreamingCSV

private let zulu = TimeZone(secondsFromGMT: 0)!
private let posix = Locale(identifier: "en_US_POSIX")

extension DateOnly: CSVCodable {
  package var csvString: String {
    let formatter = DateFormatter()
    formatter.locale = posix
    formatter.timeZone = zulu
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: date)
  }

  package init?(csvString: String) {
    let formatter = DateFormatter()
    formatter.locale = posix
    formatter.timeZone = zulu
    formatter.dateFormat = "yyyy-MM-dd"
    guard let date = formatter.date(from: csvString) else { return nil }
    self.init(date)
  }
}

extension TimeOnly: CSVCodable {
  package var csvString: String {
    let formatter = DateFormatter()
    formatter.locale = posix
    formatter.timeZone = zulu
    formatter.dateFormat = "HHmm"
    return formatter.string(from: date)
  }

  package init?(csvString: String) {
    let formatter = DateFormatter()
    formatter.locale = posix
    formatter.timeZone = zulu
    formatter.dateFormat = "HHmm"
    guard let date = formatter.date(from: csvString) else { return nil }
    self.init(date)
  }
}

// Custom Boolean type that encodes as "x" for true and "" for false
package struct CSVBool: CSVCodable {
  package var value: Bool

  package var csvString: String {
    value ? "x" : ""
  }

  package init(_ value: Bool) {
    self.value = value
  }

  package init?(csvString: String) {
    switch csvString.lowercased() {
      case "x", "true", "1", "yes":
        self.value = true
      case "", "false", "0", "no":
        self.value = false
      default:
        return nil
    }
  }
}

extension Aircraft.GearType: CSVCodable {
  package var csvString: String { rawValue }

  package init?(csvString: String) { self.init(rawValue: csvString) }
}

extension Aircraft.EngineType: CSVCodable {
  package var csvString: String { rawValue }

  package init?(csvString: String) { self.init(rawValue: csvString) }
}

extension Aircraft.SimulatorType: CSVCodable {
  package var csvString: String { rawValue }

  package init?(csvString: String) { self.init(rawValue: csvString) }
}

extension Aircraft.Category: CSVCodable {
  package var csvString: String { rawValue }

  package init?(csvString: String) { self.init(rawValue: csvString) }
}

extension Aircraft.Class: CSVCodable {
  package var csvString: String { rawValue }

  package init?(csvString: String) { self.init(rawValue: csvString) }
}

extension Flight.Approach: CSVCodable {
  package var csvString: String {
    var parts: [String] = []
    parts.append(String(count))
    parts.append(type.rawValue)
    if let runway {
      parts.append(runway)
    } else {
      parts.append("")
    }
    parts.append(airport)
    if let comments {
      parts.append(comments)
    } else {
      parts.append("")
    }
    return parts.joined(separator: ";")
  }

  package init?(csvString _: String) {
    // Not needed for writing only
    return nil
  }
}

extension Flight.Member: CSVCodable {
  package var csvString: String {
    var parts: [String] = []
    parts.append(person.name)
    parts.append(role.rawValue)
    if let email = person.email {
      parts.append(email)
    } else {
      parts.append("")
    }
    return parts.joined(separator: ";")
  }

  package init?(csvString _: String) {
    // Not needed for writing only
    return nil
  }
}

// Custom Double formatting for hours - max 0.1 precision
// swiftlint:disable missing_docs
extension Double {
  public var csvString: String {
    if self == 0 {
      return "0"
    }
    if self == floor(self) {
      // Whole number - no decimal point
      return String(format: "%.0f", self)
    }
    // Round to 0.1 precision
    let rounded = (self * 10).rounded() / 10
    if rounded == floor(rounded) {
      return String(format: "%.0f", rounded)
    }
    return String(format: "%.1f", rounded)
  }

  public init?(csvString: String) {
    guard let value = Double(csvString) else { return nil }
    self = value
  }
}
// swiftlint:enable missing_docs

extension Flight.ApproachType: CSVEncodable {
  package var csvString: String { rawValue }
}

extension Flight.Role: CSVEncodable {
  package var csvString: String { rawValue }
}
