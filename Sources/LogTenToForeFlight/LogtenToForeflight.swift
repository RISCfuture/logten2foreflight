import Foundation
import Logging
import ArgumentParser
import LogTen
import ForeFlight
import libLogTenToForeFlight

@main
struct LogtenToForeflight: ParsableCommand {
    private static let logtenDataStorePath = "Library/Containers/com.coradine.LogTenProX/Data/Documents/LogTenProData/LogTenCoreDataStore.sql"
    
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
    var foreflightFile
    
    @Flag(help: "Include extra information in the output.")
    var verbose = false
    
    mutating func run() throws {
        var logger = Logger(label: "codes.tim.LogTenToForeFlight")
        logger.logLevel = verbose ? .info : .warning
        
        do {
            let LTPLogbook = try LogTen.Reader(url: logtenFile).read()
            let FFLogbook = Converter(logbook: LTPLogbook).convert()
            try Writer(logbook: FFLogbook).write(to: foreflightFile)
        } catch {
            logger.critical("\(error.localizedDescription)")
        }
    }
}
