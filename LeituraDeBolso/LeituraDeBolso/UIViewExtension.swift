//
//  UIViewExtension.swift
//  Conectados
//
//  Created by Huallyd Smadi on 08/05/16.
//  Copyright © 2016 Huallyd Smadi. All rights reserved.
//

import UIKit

extension UIView {
    
    
    func loadAnimation (_ duration: TimeInterval = 0.5) {
        if let _ = viewWithTag(10) {
            //View is already loading
        } else {
            let loadView = UIView(frame: bounds)
            loadView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
            loadView.tag = 10
            loadView.alpha = 0.0
        
            let statusImage = UIImage(named: "loadingGiff1.png")
        
            let activityImageView = UIImageView(image: statusImage)
            var images = [UIImage]()
        
            for i in 1..<97 {
                
                images.append(UIImage(named: "loadingGiff\(i)")!)
            }
        
            activityImageView.center = loadView.center
            activityImageView.animationImages = images
        
            activityImageView.animationDuration = 5
            activityImageView.translatesAutoresizingMaskIntoConstraints = false
        
            activityImageView.startAnimating()
        
            loadView.addSubview(activityImageView)
        
            self.addSubview(loadView)
        
            let xCenterConstraint = NSLayoutConstraint(item: activityImageView, attribute: .centerX, relatedBy: .equal, toItem: loadView, attribute: .centerX, multiplier: 1, constant: 0)
        
            let yCenterConstraint = NSLayoutConstraint(item: activityImageView, attribute: .centerY, relatedBy: .equal, toItem: loadView, attribute: .centerY, multiplier: 1, constant: 0)
        
            NSLayoutConstraint.activate([xCenterConstraint, yCenterConstraint])
        
            UIView.animate(withDuration: duration, animations: {
            loadView.alpha = 1.0
            }) 
        }
        
    }
    
    func unload (_ duration: TimeInterval = 0.2) {
        
        if let loadView = self.viewWithTag(10) {
            
            UIView.animate(withDuration: duration, animations: { 
                loadView.alpha = 0.0
            }, completion: { finished in
                loadView.removeFromSuperview()
            }) 
        }
    }

}
