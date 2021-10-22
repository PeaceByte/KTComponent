//
//  AnalysisManager.swift
//  photo retouch
//
//  Created by Hi on 2020/10/7.
//  Copyright © 2020 magician. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseAnalytics
import KTFoundationKit









@objc public class AnalysisManager: NSObject {
   
    
    private override init() {
        super.init()
    }
    
    @objc public static let sharedInstance: AnalysisManager = {
        AnalysisManager()
    }()
    
    
    @objc public func startService(){
        startFirebaseService()
    }
    
    private func startFirebaseService(){
        
        LogManager.debug("started")
        FirebaseApp.configure()
        LogManager.debug("finished")
       
    }
    
   
}
