//
//  DBManager.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 28/09/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

struct DBManager {
    
    static func addObjc(_ obj: Object){
        try! Realm().write(){
            try! Realm().add(obj)
        }
    }
    
    static func getByCondition <T: Object>(param: String, value: String) -> T {
        
        let obj: Results<T> = {
            try! Realm().objects(T.self).filter("\(param) == %@", value)
        }()
        
        if obj.isEmpty {
            return T()
        } else {
            return obj.first!
        }
    }
    
    static func getAll<T : Object>() -> [T] {
        let objs: Results<T> = {
            try! Realm().objects(T.self)
        }()
        
        return Array(objs)
    }
    
    static func deleteByCondition(param: String, value: String) {
        
        let obj = try! Realm().objects(Reading.self).filter("\(param) == %@", value)
        try! Realm().write(){
            try! Realm().delete(obj)
        }
    }
    
    static func update(_ obj: Object){
        
        try! Realm().write(){
            try! Realm().add(obj, update: true)
        }
    }
    
}

