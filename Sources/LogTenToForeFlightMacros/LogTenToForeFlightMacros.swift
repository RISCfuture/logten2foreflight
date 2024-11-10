@attached(member, names: named(init(row:)), named(databaseSelection), arbitrary)
public macro QueryObject() = #externalMacro(module: "Macros", type: "QueryObjectMacro")

@attached(peer)
public macro QueryField(column: String) = #externalMacro(module: "Macros", type: "QueryFieldMacro")

@attached(peer)
public macro QueryField<RawType, ConvertedType>(column: String, convert: (RawType) -> ConvertedType) = #externalMacro(module: "Macros", type: "QueryFieldMacro")

@attached(accessor)
public macro RepeatingQueryField(count: Int, prefix: String, columnPrefix: String) = #externalMacro(module: "Macros", type: "RepeatingQueryFieldMacro")
