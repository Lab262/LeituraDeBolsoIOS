//
//  ErrorMessage.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 17/10/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class ErrorMessage: NSObject {
    
    var detail: String?
    var pointer: String?
    
    convenience init(data: (Dictionary<String, AnyObject>)) {
        self.init()
        
        print(data)
        self.setDataFromWS(data: data)
    }
    
    func setDataFromWS(data: (Dictionary<String, AnyObject>)) {
        
        if let detail = data["detail"] as? String {
            self.detail = detail
        }
        
        if let source = data["source"] as? Dictionary<String, AnyObject> {
            if let pointer = source["pointer"] as? String {
                self.pointer = pointer
            }
        }
    }
}
