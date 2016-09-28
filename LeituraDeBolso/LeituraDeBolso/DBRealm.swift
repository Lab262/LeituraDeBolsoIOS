//
//  DBRealm.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 27/09/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

struct DBRealm {
    
    static func addObjc(_ obj: Reading){
        
        try! Realm().write(){
            try! Realm().add(obj)
        }
    }
    
    static func getAll() -> [Reading] {
        let objs: Results<Reading> = {
            try! Realm().objects(Reading.self)
        }()
        
        return Array(objs)
    }
    
    static func deleteById(_ id: String) {
        
        let obj = try! Realm().objects(Reading.self).filter("id == %@", id)
        try! Realm().write(){
            try! Realm().delete(obj)
        }
    }
    
    static func update(_ obj: Reading){
        
        try! Realm().write(){
            try! Realm().add(obj, update: true)
        }
    }

}


