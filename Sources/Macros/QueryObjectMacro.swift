import SwiftSyntaxMacros
import SwiftSyntax
import MacroToolkit

fileprivate struct QueryField {
    let propertyName: String
    let column: String
    let convert: Expr?

    var initializer: String {
        if let convert = convert {
            return """
                let convert_\(propertyName) = \(convert._syntax)
                `\(propertyName)` = convert_\(propertyName)(row["\(column)"])
                """
        } else {
            return """
                \(propertyName) = row["\(column)"]
                """
        }
    }

    var SQLColumn: String {
            """
            Column("\(column)"),
            """
    }
}

fileprivate struct RepeatingQueryField {
    let access: AccessModifier
    let type: Type
    let setName: String
    let count: Int
    let prefix: String
    let columnPrefix: String

    var queryFields: Array<QueryField> {
        (1...count).map { index in
                .init(propertyName: "\(prefix)\(index)",
                      column: "\(columnPrefix)\(index)",
                      convert: nil)
        }
    }

    var declarations: Array<DeclSyntax> {
        (1...count).map { index in
            """
            \(raw: access.name) let \(raw: prefix)\(raw: index): \(raw: type.normalizedDescription)?
            """
        }
    }
}

public struct QueryObjectMacro: MemberMacro {
    public static func expansion(of node: AttributeSyntax,
                                 providingMembersOf declaration: some DeclGroupSyntax,
                                 in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        let queryFields = try queryFieldProperties(declaration: declaration),
            repeatingQueryFields = try repeatingQueryFieldProperties(declaration: declaration),
            allQueryFields = queryFields + repeatingQueryFields.flatMap(\.queryFields)

        return repeatingQueryFields.flatMap(\.declarations) + [
            """
            package init(row: Row) throws {
                \(raw: allQueryFields.map(\.initializer).joined(separator: "\n"))
            }
            """,
            """
            static package let databaseSelection: Array<any SQLSelectable> = [
                \(raw: allQueryFields.map(\.SQLColumn).joined(separator: "\n"))
            ]
            """
        ]
    }

    private static func queryFieldProperties(declaration: some DeclGroupSyntax) throws -> [QueryField] {
        let decl = DeclGroup(declaration)
        return try decl.members.compactMap(\.asVariable).compactMap { (variable) -> QueryField? in
            guard let propertyName = destructureSingle(variable.identifiers),
                  let macro = variable.attributes.first(called: "QueryField") else {
                return nil
            }

            guard let attribute = macro.asMacroAttribute,
                  let column = attribute.argument(labeled: "column"),
                  let columnLiteral = column.asStringLiteral?.value else {
                throw MacroExpansionErrorMessage("'column' argument is required for @QueryField")
            }
            let convert = attribute.argument(labeled: "convert")

            return .init(propertyName: propertyName, column: columnLiteral, convert: convert)
        }
    }

    private static func repeatingQueryFieldProperties(declaration: some DeclGroupSyntax) throws -> [RepeatingQueryField] {
        let decl = DeclGroup(declaration)
        return try decl.members.compactMap(\.asVariable).compactMap { (variable) -> RepeatingQueryField? in
            guard let propertyName = destructureSingle(variable.identifiers),
                  let macro = variable.attributes.first(called: "RepeatingQueryField"),
                  let attribute = macro.asMacroAttribute else { return nil }

            guard let count = attribute.argument(labeled: "count"),
                  let prefix = attribute.argument(labeled: "prefix"),
                  let columnPrefix = attribute.argument(labeled: "columnPrefix") else {
                throw MacroExpansionErrorMessage("'count', 'columnPrefix', and 'prefix' arguments are required for @RepeatingQueryField")
            }

            guard let countLiteral = count.asIntegerLiteral?.value,
                  let prefixLiteral = prefix.asStringLiteral?.value,
                  let columnPrefixLiteral = columnPrefix.asStringLiteral?.value,
                  let elementType = variable.bindings.first?.type?.asSimpleType?.genericArguments?.first else {
                throw MacroExpansionErrorMessage("Incorrect argument type")
            }

            let accessLevel = AccessModifier(firstModifierOfKindIn: variable._syntax.modifiers)

            return .init(access: accessLevel ?? .internal,
                         type: elementType,
                         setName: propertyName,
                         count: countLiteral,
                         prefix: prefixLiteral,
                         columnPrefix: columnPrefixLiteral)
        }
    }
}
