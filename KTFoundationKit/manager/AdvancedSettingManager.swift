//
//  AdvancedSettingManager.swift
//  photo retouch
//
//  Created by Hi on 2020/10/7.
//  Copyright © 2020 song. All rights reserved.
//

import UIKit

public class AdvancedSettingManager: NSObject {
    private override init() {
        super.init()
    }

    public static let sharedInstance:AdvancedSettingManager = {
        let advancedSettingManager = AdvancedSettingManager()
        return advancedSettingManager
    }()
    
    public func setting(for key:String) -> String?{
        return nil
    }
    
    public func boolVauleSetting(for key:String) -> Bool{
        var res = false
        if let value = setting(for: key){
            res = Bool(value) ?? false
        }
        return res
    }
    
    public func intVauleSetting(for key:String) -> Int?{
          var res:Int?
          if let value = setting(for: key){
              res = Int(value)
          }
          return res
      }
    
    public func floatVauleSetting(for key:String) -> Float?{
        var res:Float?
        if let value = setting(for: key){
            res = Float(value)
        }
        return res
    }
    
    public func doubleVauleSetting(for key:String) -> Double?{
        var res:Double?
        if let value = setting(for: key){
            res = Double(value)
        }
        return res
    }
}
