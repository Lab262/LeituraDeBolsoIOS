//
//  UIDeviceExtension.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 10/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import Foundation
import UIKit




public extension UIDevice {
    
    public enum DeviceType {
        case iPhone5
        case iPhoneSE
        case iPhone6
        case iPhonePlus
    }
    
    var modelName: DeviceType {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier
        }
        
        switch identifier {
            
            
        case "iPod5,1":                                 return .iPhone5
        case "iPod7,1":                                 return .iPhone5
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return .iPhone5
        case "iPhone4,1":                               return .iPhone5
        case "iPhone5,1", "iPhone5,2":                  return .iPhone5
        case "iPhone5,3", "iPhone5,4":                  return .iPhone5
        case "iPhone6,1", "iPhone6,2":                  return .iPhone5
        case "iPhone7,2":                               return .iPhone6
        case "iPhone7,1":                               return .iPhonePlus
        case "iPhone8,1":                               return .iPhone6
        case "iPhone8,2":                               return .iPhonePlus
        case "iPhone9,1", "iPhone9,3":                  return .iPhone6
        case "iPhone9,2", "iPhone9,4":                  return .iPhonePlus
        case "iPhone8,4":                               return .iPhone5
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return .iPhonePlus
        case "iPad3,1", "iPad3,2", "iPad3,3":           return .iPhonePlus
        case "iPad3,4", "iPad3,5", "iPad3,6":           return .iPhonePlus
        case "iPad4,1", "iPad4,2", "iPad4,3":           return .iPhonePlus
        case "iPad5,3", "iPad5,4":                      return .iPhonePlus
        case "iPad2,5", "iPad2,6", "iPad2,7":           return .iPhonePlus
        case "iPad4,4", "iPad4,5", "iPad4,6":           return .iPhonePlus
        case "iPad4,7", "iPad4,8", "iPad4,9":           return .iPhonePlus
        case "iPad5,1", "iPad5,2":                      return .iPhonePlus
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return .iPhonePlus
        case "AppleTV5,3":                              return .iPhonePlus       
        default:                                        return .iPhone6
        }
    }
}

extension UIView {
    
    static func heightScaleProportion() -> CGFloat {
        return UIScreen.main.bounds.height / 667.0
    }
    
    static func widthScaleProportion() -> CGFloat {
        return UIScreen.main.bounds.width / 375.0
    }
}
