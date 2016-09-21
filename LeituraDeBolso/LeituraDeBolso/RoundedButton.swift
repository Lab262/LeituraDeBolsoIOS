//
//  RoundedButton.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 25/08/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

  
    override func willMove(toWindow newWindow: UIWindow?) {
        
        self.layoutIfNeeded()
        self.layer.cornerRadius = self.bounds.height/2

        self.clipsToBounds = true
     

    }
    
}
