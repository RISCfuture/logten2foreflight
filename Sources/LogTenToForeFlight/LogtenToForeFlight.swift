import Foundation
import Logging
import ArgumentParser
import LogTen
import ForeFlight
import libLogTenToForeFlight

@main
struct LogtenToForeFlight: AsyncParsableCommand {
    private static let logtenDataStorePath = "Library/Group Containers/group.com.coradine.LogTenPro/LogTenProData_6583aa561ec1cc91302449b5/LogTenCoreDataStore.sql"
    
    private static var logtenDataStoreURL: URL {
        let homeDir = FileManager.default.homeDirectoryForCurrentUser
        return homeDir.appendingPathComponent(logtenDataStorePath)
    }
    
    @Option(help: "The LogTenCoreDataStore.sql file containing the logbook entries.",
            completion: .file(extensions: ["sql"]),
            transform: URL.init(fileURLWithPath:))
    var logtenFile = Self.logtenDataStoreURL
    
    @Argument(help: "The ForeFlight logbook.csv file to create.",
              completion: .file(extensions: ["csv"]),
              transform: URL.init(fileURLWithPath:))
    var foreflightFile: URL
    
    @Flag(help: "Include extra information in the output.")
    var verbose = false
    
    mutating func run() async throws {
        var logger = Logger(label: "codes.tim.LogTenToForeFlight")
        logger.logLevel = verbose ? .info : .warning
        
        let LTPLogbook = try await LogTen.Reader(url: logtenFile).read(),
            FFLogbook = await Converter(logbook: LTPLogbook).convert()
        try await Writer(logbook: FFLogbook).write(to: foreflightFile)
    }
}
