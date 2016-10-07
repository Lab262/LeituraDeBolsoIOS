//
//  Dictionary+HttpParameters.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 05/10/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import Foundation

extension Dictionary {
    
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).stringByAddingPercentEncodingForURLQueryValue()!
            let percentEscapedValue = (value as! String).stringByAddingPercentEncodingForURLQueryValue()!
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        
        return parameterArray.joined(separator: "&")
    }
    
}
