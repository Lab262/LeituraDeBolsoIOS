//
//  ApplicationState.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 31/08/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class ApplicationState: NSObject {
    
    var modeNight: Bool? = false
    var sizeFontSelected: CGFloat? = 14
    
    private init(singleton: Bool) {
        super.init()
        
    }
    
    
    class var sharedInstance: ApplicationState {
        struct Static {
            static var pred: dispatch_once_t = 0
            static var _sharedInstance: ApplicationState? = nil
        }
        
        dispatch_once (&Static.pred) {
            Static._sharedInstance = ApplicationState(singleton: true)
        }
        
        return Static._sharedInstance!
        
    }


}
