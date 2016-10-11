//
//  UserReading.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 07/10/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class UserReading: Object {
    
    dynamic var idReading: String?
    dynamic var isFavorite = false
    dynamic var isReading = false
    dynamic var alreadyRead = false
    
    
    convenience init(data: (Dictionary<String, AnyObject>)) {
        self.init()
        
        print(data)
        self.setDataFromWS(data: data)
    }
    
    
    func setDataFromWS(data: (Dictionary<String, AnyObject>)) {
        
        
        if let idReading = data ["readingId"] as? String {
            self.idReading = idReading
        }
        
        if let isFavorite = data ["isFavorite"] as? Bool {
            self.isFavorite = isFavorite
        }
        
        if let alreadyRead = data ["alreadyRead"] as? Bool {
            self.alreadyRead = alreadyRead
        }

    
    }
    
    
    

}
