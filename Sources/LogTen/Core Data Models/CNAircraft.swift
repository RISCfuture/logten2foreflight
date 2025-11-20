import CoreData
import Foundation

@objc(CNAircraft)
final class CNAircraft: NSManagedObject {

  // MARK: Managed Properties

  @NSManaged var aircraft_aircraftType: CNAircraftType
  @NSManaged var aircraft_aircraftID: String

  @NSManaged var aircraft_year: Date?
  @NSManaged var aircraft_complex: Bool
  @NSManaged var aircraft_highPerformance: Bool
  @NSManaged var aircraft_pressurized: Bool
  @NSManaged var aircraft_technicallyAdvanced: Bool

  @NSManaged var aircraft_undercarriageRetractable: Bool
  @NSManaged var aircraft_undercarriageAmphib: Bool
  @NSManaged var aircraft_undercarriageFloats: Bool
  @NSManaged var aircraft_undercarriageSkis: Bool
  @NSManaged var aircraft_undercarriageSkids: Bool
  @NSManaged var aircraft_tailwheel: Bool

  @NSManaged var aircraft_radialEngine: Bool

  @NSManaged var aircraft_customAttribute1: Bool
  @NSManaged var aircraft_customAttribute2: Bool
  @NSManaged var aircraft_customAttribute3: Bool
  @NSManaged var aircraft_customAttribute4: Bool
  @NSManaged var aircraft_customAttribute5: Bool

  // MARK: Fetch Request

  @nonobjc
  static func fetchRequest() -> NSFetchRequest<CNAircraft> {
    let request = NSFetchRequest<CNAircraft>(entityName: "Aircraft")
    request.sortDescriptors = [
      // swiftlint:disable:next prefer_self_in_static_references
      .init(keyPath: \CNAircraft.aircraft_aircraftID, ascending: true)
    ]
    request.includesSubentities = true
    return request
  }
}
