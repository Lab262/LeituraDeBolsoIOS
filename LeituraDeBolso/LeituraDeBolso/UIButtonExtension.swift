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
            UIView.animateWithDuration(0.1, delay: 0.0, options: [.Autoreverse, .CurveEaseInOut], animations: {
                self.transform = CGAffineTransformMakeScale(1.3, 1.3)
                }, completion: { (finished) in
                    self.transform = CGAffineTransformMakeScale(1.0, 1.0)
                    
            })
        }
    }



