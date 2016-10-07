//
//  Reading.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 29/08/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Reading: Object {
    
    dynamic var id: String?
    dynamic var title: String?
    dynamic var isFavorite = false
    dynamic var isReading = false
    dynamic var author: String?
    let emojis = List<Emoji>()
    dynamic var duration: String?
    dynamic var content: String?
    
    
    convenience init(data: (Dictionary<String, AnyObject>)) {
        self.init()
        
        print(data)
        self.setDataFromWS(data: data)
    }
    
    
    func setDataFromWS(data: (Dictionary<String, AnyObject>)) {
        
        if let id = data["-id"] as? String { self.id = id }
        
        if let title = data["title"] as? String { self.title = title }
        
        if let content = data["content"] as? String { self.content = content }
        
        if let author = data["author-name"] as? String { self.author = author }
        
        if let emojis = data["emojis"] as? Array<String> {
            
            for emoji in emojis {
                let emojiObject = Emoji()
                emojiObject.cod = emoji
                self.emojis.append(emojiObject)
                DBManager.addObjc(emojiObject)
            }
        }
        
    }
    
    
    func getAllSelectIdProperty (propertyName: String) -> [Any] {
        
        let allReadings: [Reading] = DBManager.getAll()
        
        let allReadingsId = allReadings.map { (object) -> Any in
            
            return object.value(forKey: propertyName)
            
        }
        
        
        return allReadingsId
    }
    
  

}
