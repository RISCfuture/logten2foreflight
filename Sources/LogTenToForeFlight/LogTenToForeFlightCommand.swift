public import ArgumentParser
public import ForeFlight
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
struct LogTenToForeFlightCommand: AsyncParsableCommand {
  private static let logtenGroupContainerPath =
    "Library/Group Containers/group.com.coradine.LogTenPro"
  private static let dataDirectoryPrefix = "LogTenProData_"
  private static let dataStoreFilename = "LogTenCoreDataStore.sql"
  private static let managedObjectModelPath = "LogTen.app/Contents/Resources/CNLogBookDocument.momd"

  private static var logtenGroupContainerURL: URL {
    FileManager.default.homeDirectoryForCurrentUser.appending(path: logtenGroupContainerPath)
  }

  private static var managedObjectModelURL: URL {
    .applicationDirectory.appending(path: managedObjectModelPath)
  }

  /// Path to the LogTen Pro Core Data store. When omitted, the most recently
  /// modified logbook in the LogTen Pro group container is used.
  @Option(
    help:
      "The LogTenCoreDataStore.sql file containing the logbook entries. Defaults to the most recently modified LogTen Pro logbook.",
    completion: .file(extensions: ["sql"]),
    transform: { .init(filePath: $0, directoryHint: .notDirectory) }
  )
  var logtenFile: URL?

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

  /// LogTen Pro suffixes its data directory with an installation-specific
  /// identifier, so the logbook is located by searching the group container
  /// rather than by assuming a fixed path.
  private static func locateDataStore() throws -> URL {
    guard let dataStore = dataStoresByRecency().first else {
      throw LogTen.Error.couldntFindDataStore(directory: logtenGroupContainerURL)
    }
    return dataStore
  }

  private static func dataStoresByRecency() -> [URL] {
    let dataDirectories =
      (try? FileManager.default.contentsOfDirectory(
        at: logtenGroupContainerURL,
        includingPropertiesForKeys: nil
      )) ?? []

    return
      dataDirectories
      .filter { $0.lastPathComponent.hasPrefix(dataDirectoryPrefix) }
      .map { $0.appending(path: dataStoreFilename) }
      .filter { FileManager.default.fileExists(atPath: $0.path(percentEncoded: false)) }
      .sorted { modificationDate(of: $0) > modificationDate(of: $1) }
  }

  private static func modificationDate(of url: URL) -> Date {
    (try? url.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate)
      ?? .distantPast
  }

  /// Executes the conversion process.
  ///
  /// This method:
  /// 1. Reads the LogTen Pro logbook using the LogTen Reader
  /// 2. Converts it to ForeFlight format using the Converter
  /// 3. Writes the CSV output using the ForeFlight Writer
  mutating func run() async throws {
    var logger = Logger(label: "codes.tim.LogTenToForeFlight")
    logger.logLevel = verbose ? .info : .warning

    let storeURL = try logtenFile ?? Self.locateDataStore()
    let LTPLogbook = try await LogTen.Reader(
      storeURL: storeURL,
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
