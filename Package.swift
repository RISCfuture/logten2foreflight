// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LogTenToForeFlight",
    platforms: [.macOS(.v14)],

    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "libLogTenToForeFlight", targets: ["libLogTenToForeFlight"]),
        .executable(name: "logten-to-foreflight", targets: ["LogTenToForeFlight"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apple/swift-argument-parser.git", branch: "main"),
        .package(url: "https://github.com/apple/swift-log.git", branch: "main"),
        .package(url: "https://github.com/groue/GRDB.swift.git", branch: "master"),
        .package(url: "https://github.com/dehesa/CodableCSV.git", branch: "master")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "libLogTenToForeFlight",
            dependencies: [
                "LogTen", "ForeFlight",
            ]),
        .target(
            name: "LogTen",
            dependencies: [
                .product(name: "GRDB", package: "GRDB.swift"),
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

    swiftLanguageVersions: [.v5]
)
