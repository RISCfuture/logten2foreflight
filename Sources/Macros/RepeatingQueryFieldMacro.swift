import SwiftSyntaxMacros
import SwiftSyntax
import MacroToolkit

public struct RepeatingQueryFieldMacro: AccessorMacro {
    public static func expansion(of node: AttributeSyntax, providingAccessorsOf declaration: some DeclSyntaxProtocol, in context: some MacroExpansionContext) throws -> [AccessorDeclSyntax] {
        let arguments = try arguments(of: node)

        let members = (1...arguments.count).map { "\(arguments.prefix)\($0)" }.joined(separator: ", ")

        return ["""
            get {
            [\(raw: members)].compactMap(\\.self)
            }
            """]
    }

    private static func arguments(of node: AttributeSyntax) throws -> (count: Int, prefix: String, columnPrefix: String) {
        let attribute = MacroAttribute(node)
        guard let count = attribute.argument(labeled: "count"),
              let prefix = attribute.argument(labeled: "prefix"),
              let columnPrefix = attribute.argument(labeled: "columnPrefix") else {
            throw MacroExpansionErrorMessage("'count', 'columnPrefix', and 'prefix' arguments are required for @RepeatingQueryField")
        }
        guard let countLiteral = count.asIntegerLiteral?.value,
              let prefixLiteral = prefix.asStringLiteral?.value,
              let columnPrefixLiteral = columnPrefix.asStringLiteral?.value else {
            throw MacroExpansionErrorMessage("Incorrect argument type")
        }

        return (count: countLiteral, prefix: prefixLiteral, columnPrefix: columnPrefixLiteral)
    }
}

