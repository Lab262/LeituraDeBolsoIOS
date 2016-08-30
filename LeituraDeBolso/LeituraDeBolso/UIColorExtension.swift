//
//  UIColorExtension.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 29/08/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import Foundation

import UIKit

extension UIColor {
    //Pragma MARK : - Functions
    class func colorWithHexString(hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.grayColor()
        }
        
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
    public func hexString(includeAlpha: Bool) -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        if (includeAlpha) {
            return String(format: "#%02X%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255), Int(a * 255))
        } else {
            return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
        }
    }
    
    class func getColorWithNameFromUserDefaults(colorName: String) -> UIColor {
        
        if let color = NSUserDefaults.standardUserDefaults().objectForKey(colorName) as? UIColor{
            return color
        } else {
            return .whiteColor()
        }
    }
    

    //Pragma MARK : - Constants

    
    class func readingPurpleColor()->UIColor{
        return colorWithHexString("632686")
    }
    
   
    class func readingBlueColor()->UIColor{
        return colorWithHexString("1BDBAD")
        
    }

    class var backgroundColor: UIColor {
        get {
            return getColorWithNameFromUserDefaults("backgroundColor")
        }
        set {
            let hexString = newValue.hexString(true)
             NSUserDefaults.standardUserDefaults().setObject(hexString, forKey: "backgroundColor")
        }
    }
    
    
    
    
    
}
