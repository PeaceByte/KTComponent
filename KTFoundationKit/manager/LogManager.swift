//
//  LogManager.swift
//  player
//
//  Created by CHAN on 2020/2/10.
//  Copyright © 2020 song. All rights reserved.
//

import UIKit
import XCGLogger

@objc public class LogManager: NSObject {
    private static let log: XCGLogger = {
        let log = XCGLogger(identifier: "advancedLogger", includeDefaultDestinations: false)
        
        // Customize as needed
        // Create a destination for the system console log (via NSLog)
        let systemDestination = AppleSystemLogDestination(identifier: "advancedLogger.systemDestination")
        
        // Optionally set some configuration options
        systemDestination.outputLevel = .debug
        systemDestination.showLogIdentifier = false
        systemDestination.showFunctionName = true
        systemDestination.showThreadName = true
        systemDestination.showLevel = true
        systemDestination.showFileName = true
        systemDestination.showLineNumber = true
        systemDestination.showDate = true
        
        // Add the destination to the logger
        log.add(destination: systemDestination)
        
        return log
    }()
    
   
    
   static public func debug(_ message: Any?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line){
        #if DEBUG
        log.debug(message,functionName: functionName,fileName: fileName, lineNumber: lineNumber)
        #else
        #endif
    }
    
    static public func warning(_ message: Any?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line){
           #if DEBUG
           log.warning(message,functionName: functionName,fileName: fileName, lineNumber: lineNumber)
           #else
           #endif
       }
}
