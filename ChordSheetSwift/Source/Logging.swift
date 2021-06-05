//
//  Logging.swift
//  ChordSheetSwift
//
//  Created by Stephen O'Connor on 05.06.21.
//

import Foundation

/// if you want to consolidate this module's output with your logger,
/// have it conform to this protocol, then set
/// `ChordSheetSwift.logger = yourLoggableInstance`
/// when you launch your app, or wherever you tend to initialize those things.
public protocol Loggable {
    func info(_ message: String)
    func debug(_ message: String)
    func error(_ message: String)
}

class Logger: Loggable {
    
    func debug(_ message: String) {
        print(message)
    }
    
    func error(_ message: String) {
        print(message)
    }
    
    func info(_ message: String) {
        print(message)
    }
}

public var logger: Loggable = Logger()
