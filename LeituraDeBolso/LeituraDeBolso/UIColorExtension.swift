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

    
    class func readingPurpleColor()->UIColor{
        return colorWithHexString("632686")
    }
    
   
    class func readingBlueColor()->UIColor{
        return colorWithHexString("1BDBAD")
        
    }
    
    class func readingWhiteColor()->UIColor{
        return colorWithHexString("F2F2F2")
        
    }
    
    
}
