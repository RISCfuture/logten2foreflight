import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct Macros: CompilerPlugin {
    var providingMacros: [Macro.Type] = [
        QueryObjectMacro.self, QueryFieldMacro.self, RepeatingQueryFieldMacro.self
    ]
}
