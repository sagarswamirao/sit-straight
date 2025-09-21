import Foundation
import os.log

class Logger {
    static let shared = Logger()
    
    private let fileManager = FileManager.default
    private let logQueue = DispatchQueue(label: "com.sitstraight.logger", qos: .utility)
    private var logFileURL: URL?
    private var cleanupTimer: Timer?
    
    private init() {
        setupLogFile()
        startCleanupTimer()
    }
    
    private func setupLogFile() {
        guard let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("❌ Failed to get documents directory")
            return
        }
        
        let logsDirectory = documentsPath.appendingPathComponent("SitStraightLogs")
        
        // Create logs directory if it doesn't exist
        if !fileManager.fileExists(atPath: logsDirectory.path) {
            do {
                try fileManager.createDirectory(at: logsDirectory, withIntermediateDirectories: true)
            } catch {
                print("❌ Failed to create logs directory: \(error)")
                return
            }
        }
        
        // Create log file with timestamp
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        let timestamp = formatter.string(from: Date())
        logFileURL = logsDirectory.appendingPathComponent("sitstraight_\(timestamp).log")
        
        // Write initial log entry
        log("🚀 SitStraight Logger initialized at \(Date())")
    }
    
    private func startCleanupTimer() {
        // Run cleanup every minute
        cleanupTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.cleanupOldLogs()
        }
    }
    
    private func cleanupOldLogs() {
        guard let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let logsDirectory = documentsPath.appendingPathComponent("SitStraightLogs")
        
        do {
            let logFiles = try fileManager.contentsOfDirectory(at: logsDirectory, includingPropertiesForKeys: [.creationDateKey])
            let fiveMinutesAgo = Date().addingTimeInterval(-300) // 5 minutes ago
            
            for logFile in logFiles {
                if let creationDate = try logFile.resourceValues(forKeys: [.creationDateKey]).creationDate,
                   creationDate < fiveMinutesAgo {
                    try fileManager.removeItem(at: logFile)
                    print("🗑️ Cleaned up old log file: \(logFile.lastPathComponent)")
                }
            }
        } catch {
            print("❌ Failed to cleanup old logs: \(error)")
        }
    }
    
    func log(_ message: String, level: LogLevel = .info, file: String = #file, function: String = #function, line: Int = #line) {
        let timestamp = DateFormatter.logTimestamp.string(from: Date())
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        let logMessage = "[\(timestamp)] [\(level.rawValue)] [\(fileName):\(line)] \(function): \(message)"
        
        // Print to console
        print(logMessage)
        
        // Write to file asynchronously
        logQueue.async { [weak self] in
            self?.writeToFile(logMessage)
        }
    }
    
    private func writeToFile(_ message: String) {
        guard let logFileURL = logFileURL else { return }
        
        let data = (message + "\n").data(using: .utf8) ?? Data()
        
        if fileManager.fileExists(atPath: logFileURL.path) {
            // Append to existing file
            if let fileHandle = try? FileHandle(forWritingTo: logFileURL) {
                fileHandle.seekToEndOfFile()
                fileHandle.write(data)
                fileHandle.closeFile()
            }
        } else {
            // Create new file
            try? data.write(to: logFileURL)
        }
    }
    
    func getLogFilePath() -> String? {
        return logFileURL?.path
    }
    
    deinit {
        cleanupTimer?.invalidate()
    }
}

enum LogLevel: String {
    case debug = "DEBUG"
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
    case critical = "CRITICAL"
}

extension DateFormatter {
    static let logTimestamp: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return formatter
    }()
}
