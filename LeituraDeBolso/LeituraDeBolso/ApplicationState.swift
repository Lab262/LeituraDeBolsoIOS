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
    
    var allReadings = [Reading]()
    var favoriteReads = [Reading]()
    var unreadReadings = [Reading]()
    
    static let sharedInstance : ApplicationState = {
        let instance = ApplicationState(singleton: true)
        return instance
    }()
    
    
    private init(singleton: Bool) {
        super.init()
        
       
    }
    

    
   }
