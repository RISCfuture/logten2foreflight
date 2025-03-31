import Foundation

package struct Aircraft: IdentifiableRecord {

    // MARK: Properties

    package let type: AircraftType
    package let tailNumber: String
    package var id: String { tailNumber }

    package let year: UInt?
    package let complex: Bool
    package let highPerformance: Bool
    package let pressurized: Bool
    package let technicallyAdvanced: Bool

    package let retractableGear: Bool
    package let amphibious: Bool
    package let floats: Bool
    package let skis: Bool
    package let skids: Bool
    package let tailwheel: Bool

    package let radial: Bool
    package let diesel: Bool

    // MARK: Initializers

    init(aircraft: CNAircraft,
         typeCodeProperty: KeyPath<CNAircraftType, String?>,
         simTypeProperty: KeyPath<CNAircraftType, String?>,
         simCategoryProperty: KeyPath<CNAircraftType, String?>,
         dieselProperty: KeyPath<CNAircraft, Bool>) {
        type = .init(aircraftType: aircraft.aircraft_aircraftType,
                     typeCodeProperty: typeCodeProperty,
                     simTypeProperty: simTypeProperty,
                     simCategoryProperty: simCategoryProperty)
        tailNumber = aircraft.aircraft_aircraftID
        year = {
            guard let year = aircraft.aircraft_year else { return nil }
            let components = Calendar.current.dateComponents(in: zulu, from: year)
            guard let year = components.year else { return nil }
            return UInt(year)
        }()
        complex = aircraft.aircraft_complex
        highPerformance = aircraft.aircraft_highPerformance
        pressurized = aircraft.aircraft_pressurized
        technicallyAdvanced = aircraft.aircraft_technicallyAdvanced
        retractableGear = aircraft.aircraft_undercarriageRetractable
        amphibious = aircraft.aircraft_undercarriageAmphib
        floats = aircraft.aircraft_undercarriageFloats
        skis = aircraft.aircraft_undercarriageSkis
        skids = aircraft.aircraft_undercarriageSkids
        tailwheel = aircraft.aircraft_tailwheel
        radial = aircraft.aircraft_radialEngine
        diesel = aircraft[keyPath: dieselProperty]
    }
}
