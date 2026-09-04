// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
import PackageDescription

let upcomingFeatures: [SwiftSetting] = [
  .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
  .enableUpcomingFeature("InferIsolatedConformances"),
  .enableUpcomingFeature("ImmutableWeakCaptures"),
  .enableUpcomingFeature("MemberImportVisibility"),
  .enableUpcomingFeature("ExistentialAny"),
  .enableUpcomingFeature("InternalImportsByDefault")
]

let package = Package(
  name: "LogTenToForeFlight",
  defaultLocalization: "en",
  platforms: [.macOS(.v15)],

  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .library(name: "libLogTenToForeFlight", targets: ["libLogTenToForeFlight"]),
    .executable(name: "logten-to-foreflight", targets: ["LogTenToForeFlight"])
  ],
  dependencies: [
    // Dependencies declare other packages that this package depends on.
    .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.8.2"),
    .package(url: "https://github.com/apple/swift-log.git", from: "1.15.0"),
    .package(url: "https://github.com/RISCfuture/StreamingCSV.git", from: "2.1.0"),
    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.5.0")
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .target(
      name: "LogTen",
      resources: [.process("Localizable.xcstrings")],
      swiftSettings: upcomingFeatures
    ),
    .target(
      name: "ForeFlight",
      dependencies: [
        "StreamingCSV"
      ],
      resources: [
        .process("Resources")
      ],
      swiftSettings: upcomingFeatures
    ),
    .target(
      name: "libLogTenToForeFlight",
      dependencies: [
        "LogTen",
        "ForeFlight",
        .product(name: "Logging", package: "swift-log")
      ],
      swiftSettings: upcomingFeatures
    ),
    .executableTarget(
      name: "LogTenToForeFlight",
      dependencies: [
        .target(name: "libLogTenToForeFlight"),
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        .product(name: "Logging", package: "swift-log")
      ],
      swiftSettings: upcomingFeatures
    )
  ],

  swiftLanguageModes: [.v6]
)
