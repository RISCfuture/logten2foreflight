import ArgumentParser
import ForeFlight
import Foundation
import LogTen
import Logging
import libLogTenToForeFlight

@main
struct LogtenToForeFlight: AsyncParsableCommand {
  private static let logtenDataStorePath =
    "Library/Group Containers/group.com.coradine.LogTenPro/LogTenProData_6583aa561ec1cc91302449b5/LogTenCoreDataStore.sql"
  private static let managedObjectModelPath = "LogTen.app/Contents/Resources/CNLogBookDocument.momd"

  private static var logtenDataStoreURL: URL {
    let homeDir = FileManager.default.homeDirectoryForCurrentUser
    return homeDir.appendingPathComponent(logtenDataStorePath)
  }

  private static var managedObjectModelURL: URL {
    .applicationDirectory.appending(path: managedObjectModelPath)
  }

  @Option(
    help: "The LogTenCoreDataStore.sql file containing the logbook entries.",
    completion: .file(extensions: ["sql"]),
    transform: { .init(filePath: $0, directoryHint: .notDirectory) }
  )
  var logtenFile = Self.logtenDataStoreURL

  @Option(
    help: "The location of the LogTen Pro managed object model file.",
    completion: .file(extensions: ["momd"]),
    transform: { .init(filePath: $0, directoryHint: .isDirectory) }
  )
  var logtenManagedObjectModel = Self.managedObjectModelURL

  @Argument(
    help: "The ForeFlight logbook.csv file to create.",
    completion: .file(extensions: ["csv"]),
    transform: { .init(filePath: $0, directoryHint: .notDirectory) }
  )
  var foreflightFile: URL

  @Flag(help: "Include extra information in the output.")
  var verbose = false

  mutating func run() async throws {
    var logger = Logger(label: "codes.tim.LogTenToForeFlight")
    logger.logLevel = verbose ? .info : .warning

    let LTPLogbook = try await LogTen.Reader(
      storeURL: logtenFile,
      modelURL: logtenManagedObjectModel
    ).read()
    let FFLogbook = try await Converter(logbook: LTPLogbook).convert()
    try await Writer(logbook: FFLogbook).write(to: foreflightFile)
  }
}
