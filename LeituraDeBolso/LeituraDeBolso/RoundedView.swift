//
//  RoundedView.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 09/09/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class RoundedView: UIView {
    
    

    override func willMoveToWindow(newWindow: UIWindow?) {
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.height/2
    }

}