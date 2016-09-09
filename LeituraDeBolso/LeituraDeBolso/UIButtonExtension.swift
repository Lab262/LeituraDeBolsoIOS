//
//  UIButtonExtension.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 30/08/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

extension UIButton {
    
    
    func selectedButtonWithImage(imageSelected: UIImage? = nil) {
        
        if imageSelected != nil {
            self.setImage(imageSelected, forState: .Normal)

        }
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0.1, options: .CurveEaseInOut,animations: {
            self.transform = CGAffineTransformMakeScale(1.2, 1.2)
            }, completion: { (finished) in
//                self.transform = CGAffineTransformMakeScale(1.0, 1.0)
                
        })
    }

}



