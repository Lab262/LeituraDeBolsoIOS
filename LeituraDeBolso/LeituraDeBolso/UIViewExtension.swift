//
//  UIViewExtension.swift
//  Conectados
//
//  Created by Huallyd Smadi on 08/05/16.
//  Copyright © 2016 Huallyd Smadi. All rights reserved.
//

import UIKit

extension UIView {
    func lock(duration: NSTimeInterval = 0.2) {
        
        if let _ = viewWithTag(10) {
            //View is already locked
        }
        else {
            let lockView = UIView(frame: bounds)
            lockView.backgroundColor = UIColor(white: 0.0, alpha: 0.75)
            lockView.tag = 10
            lockView.alpha = 0.0
            let activity = UIActivityIndicatorView(activityIndicatorStyle: .White)
            activity.hidesWhenStopped = true
            
            activity.center = lockView.center
            
            activity.translatesAutoresizingMaskIntoConstraints = false
            
            lockView.addSubview(activity)
            activity.startAnimating()
            
            self.addSubview(lockView)
            
            let xCenterConstraint = NSLayoutConstraint(item: activity, attribute: .CenterX, relatedBy: .Equal, toItem: lockView, attribute: .CenterX, multiplier: 1, constant: 0)
            
            let yCenterConstraint = NSLayoutConstraint(item: activity, attribute: .CenterY, relatedBy: .Equal, toItem: lockView, attribute: .CenterY, multiplier: 1, constant: 0)
            
            
            NSLayoutConstraint.activateConstraints([xCenterConstraint, yCenterConstraint])
            
            UIView.animateWithDuration(duration) {
                lockView.alpha = 1.0
            }
        }
    }
    
    func unlock(duration: NSTimeInterval = 0.2) {
        if let lockView = self.viewWithTag(10) {
            
            UIView.animateWithDuration(duration, animations: {
                lockView.alpha = 0.0
            }) { finished in
                lockView.removeFromSuperview()
            }
        }
    }
}
