//
//  ANLog.swift
//  Log
//
//  Created by 刘栋 on 2018/7/17.
//  Copyright © 2018年 anotheren.com. All rights reserved.
//

import Foundation
import os.log

public struct Log {
    
    private let _log: OSLog
    
    /// Creates a custom log object, to be passed to logging functions for sending messages to the logging system.
    ///
    /// - Parameters:
    ///   - subsystem: An identifier string, in reverse DNS notation, representing the subsystem that’s performing logging. For example, com.your_company.your_subsystem_name. The subsystem is used for categorization and filtering of related log messages, as well as for grouping related logging settings.
    ///   - category: A category within the specified subsystem. The category is used for categorization and filtering of related log messages, as well as for grouping related logging settings within the subsystem’s settings. A category’s logging settings override those of the parent subsystem.
    public init(subsystem: String, category: String) {
        let log = OSLog(subsystem: subsystem, category: category)
        self._log = log
    }
    
    public func log(message: String, level: Level) {
        os_log("%{public}@", log: _log, type: level.osType, message)
    }

    /// Default-level messages are initially stored in memory buffers. Without a configuration change, they are compressed and moved to the data store as memory buffers fill. They remain there until a storage quota is exceeded, at which point, the oldest messages are purged. Use this level to capture information about things that might result a failure.
    ///
    /// - Parameter message: message to log use **DEFAULT**
    public func `default`(_ message: String) {
        if isEnabled(for: .default) {
            log(message: message, level: .default)
        }
    }

    /// Info-level messages are initially stored in memory buffers. Without a configuration change, they are not moved to the data store and are purged as memory buffers fill. They are, however, captured in the data store when faults and, optionally, errors occur. When info-level messages are added to the data store, they remain there until a storage quota is exceeded, at which point, the oldest messages are purged. Use this level to capture information that may be helpful, but isn’t essential, for troubleshooting errors.
    ///
    /// - Parameter message: message to log use **INFO**
    public func info(_ message: String) {
        if isEnabled(for: .info) {
            log(message: message, level: .info)
        }
    }
    
    /// Debug-level messages are only captured in memory when debug logging is enabled through a configuration change. They’re purged in accordance with the configuration’s persistence setting. Messages logged at this level contain information that may be useful during development or while troubleshooting a specific problem. Debug logging is intended for use in a development environment and not in shipping software.
    ///
    /// - Parameter message: message to log use **DEBUG**
    public func debug(_ message: String) {
        if isEnabled(for: .debug) {
            log(message: message, level: .debug)
        }
    }
    
    /// Error-level messages are always saved in the data store. They remain there until a storage quota is exceeded, at which point, the oldest messages are purged. Error-level messages are intended for reporting process-level errors. If an activity object exists, logging at this level captures information for the entire process chain.
    ///
    /// - Parameter message: message to log use **ERROR**
    public func error(_ message: String) {
        if isEnabled(for: .error) {
            log(message: message, level: .error)
        }
    }
    
    /// Fault-level messages are always saved in the data store. They remain there until a storage quota is exceeded, at which point, the oldest messages are purged. Fault-level messages are intended for capturing system-level or multi-process errors only. If an activity object exists, logging at this level captures information for the entire process chain.
    ///
    /// - Parameter message: message to log use **FAULT**
    public func fault(_ message: String) {
        if isEnabled(for: .fault) {
            log(message: message, level: .fault)
        }
    }
    
    public func isEnabled(for level: Level) -> Bool {
        return _log.isEnabled(type: level.osType)
    }
}

extension Log: CustomStringConvertible {
    
    public var description: String {
        return _log.description
    }
}

extension Log {
    
    public static let standard: Log = {
        let subsystem = "com.anotheren.ANLog"
        let category = "Standard"
        let log = Log(subsystem: subsystem, category: category)
        return log
    }()
}

extension Log {
    
    public enum Level {
        case `default`
        case info
        case debug
        case error
        case fault
        
        var osType: OSLogType {
            switch self {
            case .default:
                return .default
            case .info:
                return .info
            case .debug:
                return .debug
            case .error:
                return .error
            case .fault:
                return .fault
            }
        }
    }
}
