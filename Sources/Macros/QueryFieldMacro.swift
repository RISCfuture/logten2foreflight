import SwiftSyntaxMacros
import SwiftSyntax

public struct QueryFieldMacro: PeerMacro {
    public static func expansion(of node: AttributeSyntax, providingPeersOf declaration: some DeclSyntaxProtocol, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        return [] // no function, just annotation for QueryObjectMacro
    }
}
