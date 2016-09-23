//
//  User.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 22/09/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit
import ObjectMapper

class User: NSObject {
    
    
    var id: String?
    var email: String?
    var readingsFavorite: [Reading]?
    var token: String?
    
    
    override init () {
        super.init()
    }
    
    init (_id: String, _email: String, _readingsFavorite: [Reading]) {
        
        
    }
    
    init (_email: String) {
        self.email = _email
    }
    
    required init(data: (Dictionary<String, AnyObject>)) {
        super.init()
        
        print(data)
        self.setDataFromWS(data: data)
    }
    
    func setDataFromWS(data: (Dictionary<String, AnyObject>)) {
        
        if let email = data["email"] as? String { self.email = email }
    }
    
    func getAsDictionaryForWS() -> Dictionary<String, String> {
        
        var dic = Dictionary<String, String>()
        
        if let email = self.email {
            dic ["email"] = email
        }
        
        return dic
        
    }



}
