// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "LogTenToForeFlight",
    platforms: [.macOS(.v15)],

    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "LogTenToForeFlightMacros", targets: ["LogTenToForeFlightMacros"]),
        .library(name: "libLogTenToForeFlight", targets: ["libLogTenToForeFlight"]),
        .executable(name: "logten-to-foreflight", targets: ["LogTenToForeFlight"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.5.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.6.1"),
        .package(url: "https://github.com/groue/GRDB.swift.git", from: "6.29.3"),
        .package(url: "https://github.com/dehesa/CodableCSV.git", from: "0.6.7"),
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.0-latest"),
        .package(url: "https://github.com/stackotter/swift-macro-toolkit.git", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .macro(
            name: "Macros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                .product(name: "MacroToolkit", package: "swift-macro-toolkit")
            ]
        ),
        .target(
            name: "LogTenToForeFlightMacros",
            dependencies: ["Macros"]
        ),
        .target(
            name: "libLogTenToForeFlight",
            dependencies: ["LogTen", "ForeFlight"]),
        .target(
            name: "LogTen",
            dependencies: [
                .product(name: "GRDB", package: "GRDB.swift"),
                "LogTenToForeFlightMacros"
            ]),
        .target(
            name: "ForeFlight",
            dependencies: [
                "CodableCSV"
            ],
            resources: [
                .process("Resources")
            ]),
        .executableTarget(
            name: "LogTenToForeFlight",
            dependencies: [
                .target(name: "libLogTenToForeFlight"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Logging", package: "swift-log")
            ]),
        .testTarget(
            name: "LogTenToForeFlightTests",
            dependencies: ["libLogTenToForeFlight"])
    ],

    swiftLanguageModes: [.v6]
)
