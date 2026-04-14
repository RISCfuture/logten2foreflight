import ArgumentParser
import ForeFlight
import Foundation
import LogTen
import Logging
import libLogTenToForeFlight

extension ForeFlight.Regulations: ExpressibleByArgument {
  public init?(argument: String) {
    switch argument.lowercased() {
      case "faa": self = .FAA
      case "easa": self = .EASA
      default: return nil
    }
  }
}

/// Command-line tool that converts LogTen Pro logbooks to ForeFlight CSV format.
///
/// This tool reads a LogTen Pro logbook from its Core Data store and produces
/// a CSV file suitable for import into ForeFlight Logbook.
///
/// ## Usage
///
/// ```bash
/// # Basic usage with default LogTen Pro location
/// logten-to-foreflight output.csv
///
/// # Specify custom LogTen Pro data file
/// logten-to-foreflight --logten-file ~/path/to/store.sql output.csv
///
/// # Enable verbose output
/// logten-to-foreflight --verbose output.csv
/// ```
@main
struct LogtenToForeFlight: AsyncParsableCommand {
  private static let logtenGroupContainerPath =
    "Library/Group Containers/group.com.coradine.LogTenPro"
  private static let logtenDataStoreFilename = "LogTenCoreDataStore.sql"
  private static let managedObjectModelPath = "LogTen.app/Contents/Resources/CNLogBookDocument.momd"

  private static var logtenDataStoreURL: URL {
    let homeDir = FileManager.default.homeDirectoryForCurrentUser
    let groupContainer = homeDir.appendingPathComponent(logtenGroupContainerPath)
    let dataDirectory =
      (try? FileManager.default.contentsOfDirectory(
        at: groupContainer,
        includingPropertiesForKeys: nil
      ))?.first { $0.lastPathComponent.hasPrefix("LogTenProData_") }
      ?? groupContainer.appendingPathComponent("LogTenProData")
    return dataDirectory.appendingPathComponent(logtenDataStoreFilename)
  }

  private static var managedObjectModelURL: URL {
    .applicationDirectory.appending(path: managedObjectModelPath)
  }

  /// Path to the LogTen Pro Core Data store.
  @Option(
    help: "The LogTenCoreDataStore.sql file containing the logbook entries.",
    completion: .file(extensions: ["sql"]),
    transform: { .init(filePath: $0, directoryHint: .notDirectory) }
  )
  var logtenFile = Self.logtenDataStoreURL

  /// Path to the LogTen Pro managed object model.
  @Option(
    help: "The location of the LogTen Pro managed object model file.",
    completion: .file(extensions: ["momd"]),
    transform: { .init(filePath: $0, directoryHint: .isDirectory) }
  )
  var logtenManagedObjectModel = Self.managedObjectModelURL

  /// Path where the ForeFlight CSV file will be created.
  @Argument(
    help: "The ForeFlight logbook.csv file to create.",
    completion: .file(extensions: ["csv"]),
    transform: { .init(filePath: $0, directoryHint: .notDirectory) }
  )
  var foreflightFile: URL

  /// Regulatory regime to apply when a flight's departure airport ICAO
  /// doesn't start with K (FAA) or E (EASA).
  @Option(
    name: .customLong("default-regulations"),
    help:
      "Regulations regime to use when the departure airport's ICAO doesn't start with K or E. (values: faa, easa)"
  )
  var defaultRegulations: ForeFlight.Regulations = .FAA

  /// Enable verbose logging output.
  @Flag(help: "Include extra information in the output.")
  var verbose = false

  /// Executes the conversion process.
  ///
  /// This method:
  /// 1. Reads the LogTen Pro logbook using the LogTen Reader
  /// 2. Converts it to ForeFlight format using the Converter
  /// 3. Writes the CSV output using the ForeFlight Writer
  mutating func run() async throws {
    var logger = Logger(label: "codes.tim.LogTenToForeFlight")
    logger.logLevel = verbose ? .info : .warning

    let LTPLogbook = try await LogTen.Reader(
      storeURL: logtenFile,
      modelURL: logtenManagedObjectModel
    )
    .read()
    let FFLogbook = try await Converter(
      logbook: LTPLogbook,
      defaultRegulations: defaultRegulations
    ).convert()
    try await Writer(logbook: FFLogbook).write(to: foreflightFile)
  }
}
