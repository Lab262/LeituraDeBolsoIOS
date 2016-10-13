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
        if let token = data ["token"] as? String { self.token = token }
        
        if let readings = data ["readings"] as? Array<Dictionary<String, AnyObject>> {
            
            for reading in readings {
                let userReading = UserReading(data: reading)
                self.userReadings.append(userReading)
            }
        }
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
            
            return object.value(forKey: propertyName)
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
        return nil
    }
    
    func readingAlreadyRead (id:String) -> Bool? {
        
        if let reading = self.getUserReadingById(id: id) {
            if reading.alreadyRead {
                return true
            } else {
                return false
            }
        }
        
        return nil
        
    }
    
    func getUserReadingById (id: String) -> UserReading? {
        
        var userReadingsById = [UserReading]()
        userReadingsById = self.userReadings.filter() {
            $0.idReading!.localizedCaseInsensitiveContains(id)
        }
        
        if !userReadingsById.isEmpty {
            let userReading = userReadingsById.first
            return userReading!
        }
        
        return nil
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
