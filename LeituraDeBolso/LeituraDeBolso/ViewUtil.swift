//
//  ViewUtil.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 10/09/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class ViewUtil: NSObject {
    

    
    class func viewControllerFromStoryboardWithIdentifier(_ name: String, identifier: String = "")->UIViewController?{
        
        if let storyboard : UIStoryboard = UIStoryboard(name: name as String, bundle: nil){
            if identifier != "" {
                return storyboard.instantiateViewController(withIdentifier: identifier as String)
            }else{
                return storyboard.instantiateInitialViewController()!
            }
        }else{
            return nil
        }
        
    }
    
  
    static func alertControllerWithTitle (_title: String, _withMessage _message: String) -> UIAlertController {
        
        let alert = UIAlertController(title: _title, message: _message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        return alert
    }
    

    static func imageFromColor (_ color: UIColor, forSize size: CGSize, withCornerRadius radius: CGFloat) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        UIGraphicsBeginImageContext(size)
        UIBezierPath(roundedRect: rect, cornerRadius: radius).addClip()
        image.draw(in: rect)
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
        
    }



}
