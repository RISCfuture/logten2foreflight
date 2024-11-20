fileprivate let typeCodeField = "Type Code"
fileprivate let simTypeField = "Sim Type"
fileprivate let simCategoryField = "Sim A/C Cat"
fileprivate let dieselField = "Diesel Engine"

extension Reader {
    func fetchAircraft() throws -> Array<Aircraft> {
        let request = CNAircraft.fetchRequest()
        let aircraft = try container.viewContext.fetch(request)
        
        let typeCodeProperty = try aircraftTypeCustomAttribute(for: typeCodeField)
        let simTypeProperty = try aircraftTypeCustomAttribute(for: simTypeField)
        let simCategoryProperty = try aircraftTypeCustomAttribute(for: simCategoryField)
        let dieselProperty = try aircraftCustomAttribute(for: dieselField)
        
        return aircraft.map { aircraft in
                .init(aircraft: aircraft,
                      typeCodeProperty: typeCodeProperty,
                      simTypeProperty: simTypeProperty,
                      simCategoryProperty: simCategoryProperty,
                      dieselProperty: dieselProperty)
        }
    }
    
    private func aircraftTypeCustomAttribute(for title: String) throws -> KeyPath<CNAircraftType, String?> {
        let request = CNLogTenCustomizationProperty.fetchRequest(title: title, keyPrefix: "aircraftType_customAttribute")
        let result = try container.viewContext.fetch(request)
        guard result.count == 1, let property = result.first else {
            throw Error.missingProperty(title, model: "Aircraft Type")
        }
        switch property.logTenProperty_key {
            case "aircraftType_customAttribute1": return \.aircraftType_customAttribute1
            case "aircraftType_customAttribute2": return \.aircraftType_customAttribute2
            case "aircraftType_customAttribute3": return \.aircraftType_customAttribute3
            case "aircraftType_customAttribute4": return \.aircraftType_customAttribute4
            case "aircraftType_customAttribute5": return \.aircraftType_customAttribute5
            default: preconditionFailure("Unknown custom attribute \(property.logTenProperty_key)")
        }
    }
    
    private func aircraftCustomAttribute(for title: String) throws -> KeyPath<CNAircraft, Bool> {
        let request = CNLogTenCustomizationProperty.fetchRequest(title: title, keyPrefix: "aircraft_customAttribute")
        let result = try container.viewContext.fetch(request)
        guard result.count == 1, let property = result.first else {
            throw Error.missingProperty(title, model: "Aircraft")
        }
        switch property.logTenProperty_key {
            case "aircraft_customAttribute1": return \.aircraft_customAttribute1
            case "aircraft_customAttribute2": return \.aircraft_customAttribute2
            case "aircraft_customAttribute3": return \.aircraft_customAttribute3
            case "aircraft_customAttribute4": return \.aircraft_customAttribute4
            case "aircraft_customAttribute5": return \.aircraft_customAttribute5
            default: preconditionFailure("Unknown custom attribute \(property.logTenProperty_key)")
        }
    }
}
