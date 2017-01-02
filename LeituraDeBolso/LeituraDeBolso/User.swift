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
    let userReadings = List<UserReading>()
    dynamic var token: String?

    dynamic var lastSessionTimeInterval:Double = 0
    dynamic var isModeNight: Bool = false
    dynamic var isNotification: Bool = false
    dynamic var acceptsNotification: Bool = false
    dynamic var sizeFont: CGFloat = 14
    dynamic var notificationHour: Date = Date()
    dynamic var readingDayId: Int = 0
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(data: (Dictionary<String, AnyObject>)) {
        self.init()
        
        print(data)
        self.setDataFromWS(data: data)
    }
    
    func setDataFromWS(data: (Dictionary<String, AnyObject>)) {
        
        if let id = data ["_id"] as? String { self.id = id }
        
        if let email = data ["email"] as? String { self.email = email }
        
//        if let token = data ["token"] as? String { self.token = token }
        
    }
    
    
    func getAsDictionaryForWS() -> Dictionary<String, String> {
        
        var dic = Dictionary<String, String>()
        
        if let email = self.email {
            dic ["email"] = email
        }
        
        return dic
    }
    
    
    func getAllUserReadingIdProperty (propertyName: String) -> [Any] {
        
        let allReadings: [UserReading] = Array(self.userReadings)
        
        let allReadingsId = allReadings.map { (object) -> Any in
            
            return object.value(forKey: propertyName) as Any
        }
        return allReadingsId
    }
    
    func setAlreadyRead(id: String) {
        
        if let userReading = self.getUserReadingById(id: id) {
            try! Realm().write {
                userReading.alreadyRead = true
                self.userReadings.append(userReading)
                try! Realm().add(self, update: true)
                
            }
        }
    }
    
    func readingIsFavorite (id: String) -> Bool? {
        
        if let reading = self.getUserReadingById(id: id) {
            if reading.isFavorite {
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    func readingAlreadyRead (id:String) -> Bool? {
        
        if let reading = self.getUserReadingById(id: id) {
            
            if reading.alreadyRead {
                return true
            } else {
                return false
            }
        }
        
        return false
    }
    
    func createUserReading (idReading: String) {
        
        UserReadingRequest.createUserReading(readingId: idReading, isFavorite: false, alreadyRead: false) { (success, msg) in
            
            if success {
                print ("USER READING CRIADO: \(msg)")
            } else {
                print ("USER READING NÃO CRIADO: \(msg)")
                
            }
        }
    }

    func createUserReadingInDataBase (idReading: String) {
        
        let userReading = UserReading()
        userReading.idReading = idReading
        userReading.isShared = false
        userReading.isFavorite = false
        userReading.alreadyRead = false
        
        try! Realm().write {
            self.userReadings.append(userReading)
        }
        
        DBManager.addObjc(self)
    }
    
    
    func getUserReadingById (id: String) -> UserReading? {
        
        var userReadingsById = [UserReading]()
        
        userReadingsById = self.userReadings.filter() {
            
            $0.idReading!.localizedCaseInsensitiveContains(id)
        }
        
        if !userReadingsById.isEmpty {
            let userReading = userReadingsById.first
            return userReading!
        } else {
            
            self.createUserReadingInDataBase(idReading: id)
            self.createUserReading(idReading: id)
            
            return getUserReadingById(id: id)

        }
        
    }
    
    func setFavoriteReading(id: String, isFavorite: Bool) {
        
        if let userReading = self.getUserReadingById(id: id) {
            try! Realm().write {
                
                userReading.isFavorite = isFavorite
                self.userReadings.append(userReading)
                try! Realm().add(self, update: true)
                
            }
        }
        
    }
    
}
