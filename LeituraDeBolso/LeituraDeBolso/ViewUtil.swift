//
//  ViewUtil.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 10/09/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class ViewUtil: NSObject {
    
    class func viewControllerFromStoryboardWithIdentifier(name: String, identifier: String = "")->UIViewController?{
        
        if let storyboard : UIStoryboard = UIStoryboard(name: name as String, bundle: nil){
            if identifier != "" {
                return storyboard.instantiateViewControllerWithIdentifier(identifier as String)
            }else{
                return storyboard.instantiateInitialViewController()!
            }
        }else{
            return nil
        }
        
    }


}
