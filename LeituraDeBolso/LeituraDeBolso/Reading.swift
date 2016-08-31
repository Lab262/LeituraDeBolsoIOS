//
//  Reading.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 29/08/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class Reading: NSObject {
    
    var title: String?
    var author: String?
    var emojis: Array<String>?
    var duration: String?
    var text: String?
    
    
    override init() {
         super.init()
    }
    
    init (_title: String, _author: String, _emojis: Array<String>, _duration: String, _text: String) {
        self.title = _title
        self.author = _author
        self.emojis = _emojis
        self.duration = _duration
        self.text = _text
    }
}
