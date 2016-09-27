//
//  Reading.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 29/08/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class Reading: NSObject {
    
    var id: String?
    var title: String?
    var author: String?
    var emojis: Array<String>?
    var duration: String?
    var content: String?
    
    
    override init() {
         super.init()
    }
    
    init (_title: String, _author: String, _emojis: Array<String>, _duration: String, _text: String) {
        
        self.title = _title
        self.author = _author
        self.emojis = _emojis
        self.duration = _duration
        self.content = _text
        
    }
    
    required init(data: (Dictionary<String, AnyObject>)) {
        super.init()
        
        print(data)
        self.setDataFromWS(data: data)
    }
    
    func setDataFromWS(data: (Dictionary<String, AnyObject>)) {
        
        if let id = data["-id"] as? String { self.id = id }
        
        if let title = data["title"] as? String { self.title = title }
        
        if let content = data["content"] as? String { self.content = content }
        
        if let author = data["author-name"] as? String { self.author = author }
        
        if let emojis = data["emojis"] as? Array<String> { self.emojis = emojis }
        
    }
    
    
}
