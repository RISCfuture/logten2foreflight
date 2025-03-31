// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "LogTenToForeFlight",
    defaultLocalization: "en",
    platforms: [.macOS(.v13)],

    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "libLogTenToForeFlight", targets: ["libLogTenToForeFlight"]),
        .executable(name: "logten-to-foreflight", targets: ["LogTenToForeFlight"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.5.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.6.1"),
        .package(url: "https://github.com/dehesa/CodableCSV.git", from: "0.6.7")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(name: "LogTen",
                resources: [.process("Localizable.xcstrings")]),
        .target(
            name: "ForeFlight",
            dependencies: [
                "CodableCSV"
            ],
            resources: [
                .process("Resources")
            ]),
        .target(
            name: "libLogTenToForeFlight",
            dependencies: ["LogTen", "ForeFlight"]),
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
