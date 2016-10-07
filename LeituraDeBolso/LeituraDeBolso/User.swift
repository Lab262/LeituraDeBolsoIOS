//
//  User.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 22/09/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class User: Object {
    
    dynamic var id: String?
    dynamic var email: String?
    let readings = List<Reading>()
    dynamic var token: String?
    dynamic var lastSessionTimeInterval:Double = 0
    
    
    convenience init(data: (Dictionary<String, AnyObject>)) {
        self.init()
        
        print(data)
        self.setDataFromWS(data: data)
        
    }
    
    func setDataFromWS(data: (Dictionary<String, AnyObject>)) {
        
        if let id = data ["_id"] as? String { self.id = id }
        if let email = data ["email"] as? String { self.email = email }
        if let token = data ["token"] as? String { self.token = token }
    }
    
    
    func getAsDictionaryForWS() -> Dictionary<String, String> {
        
        var dic = Dictionary<String, String>()
        
        if let email = self.email {
            dic ["email"] = email
        }
        
        return dic
        
    }



}
