import CoreData
import Foundation

@objc(CNPlace)
final class CNPlace: NSManagedObject {

  // MARK: Managed Columns

  @NSManaged var place_identifier: String
  @NSManaged var place_icaoid: String?

  @NSManaged var place_customAttribute1: String?
  @NSManaged var place_customAttribute2: String?
  @NSManaged var place_customAttribute3: String?
  @NSManaged var place_customAttribute4: String?
  @NSManaged var place_customAttribute5: String?
  @NSManaged var place_customAttribute6: String?
  @NSManaged var place_customAttribute7: String?
  @NSManaged var place_customAttribute8: String?
  @NSManaged var place_customAttribute9: String?
  @NSManaged var place_customAttribute10: String?
}
