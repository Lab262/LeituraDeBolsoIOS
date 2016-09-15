//
//  UIView+Animations.swift
//  ThiagoBernardes
//
//  Created by Thiago-Bernardes on 3/20/16.
//  Copyright © 2016 TB. All rights reserved.
//
import UIKit

enum WipeDirection {
    
    case bottomToTop ,leftToRight, topToBottom, rightToLeft
    
}

enum RotationDegree {
    
    case degree360, degree180, degree90, degree45
}

enum RotationType {
    
    case clockWize, unClockWize
}

extension UIView: CAAnimationDelegate {
    
    func fadeIn(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}, finalAlpha : CGFloat = 1.0) {
        self.alpha = 0.0
        
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions(), animations: {
            self.alpha = finalAlpha
            }, completion: completion)  }
    
    func fadeOut(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}, finalAlpha : CGFloat = 0.0) {
        
        self.alpha = 1.0
        
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions(), animations: {
            self.alpha = finalAlpha
            }, completion: completion)
    }
    
   // func slideInFromLeft(_ duration: TimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        // Create a CATransition animation
     //   let slideInFromLeftTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided (if any)
       // if let delegate: AnyObject = completionDelegate {
         //   slideInFromLeftTransition.delegate = delegate
        //}
        
        // Customize the animation's properties
       // slideInFromLeftTransition.type = kCATransitionPush
        //slideInFromLeftTransition.subtype = kCATransitionFromLeft
        //slideInFromLeftTransition.duration = duration
        //slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        //slideInFromLeftTransition.fillMode = kCAFillModeRemoved
        
        // Add the animation to the View's layer
        //self.layer.add(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")
   // }
    
    func rotateInDiraction(
        _ direction: RotationType,andDegrees
        degrees: RotationDegree,
        duration: CFTimeInterval = 1.0,
        delay: CFTimeInterval = 1.0,
        completionBlock: (() -> Void)? = {}) {
        
        UIView.animate(withDuration: duration, delay: delay, options: [], animations: {
            
            var rotationConstant = CGFloat(M_PI * 2.0)
            
            switch degrees {
            case .degree360:
                rotationConstant = CGFloat(M_PI * 2.0)
            case .degree180:
                rotationConstant = CGFloat(M_PI )
            case .degree90:
                rotationConstant = CGFloat(M_PI_2)
            case .degree45:
                rotationConstant = CGFloat(M_PI_4)
            }
            
            switch direction {
            case .clockWize:
                rotationConstant = 1 * rotationConstant
            case .unClockWize:
                rotationConstant = -1 * rotationConstant
                
            }
            
            self.transform = CGAffineTransform(rotationAngle: rotationConstant)
        
        }) { (finished: Bool) in
            if completionBlock != nil {
                completionBlock!()

            }
        }
        
    }
    
    
    func bouncingAnimation(_ isZoomIn: Bool = true,
                           duration: TimeInterval = 1.0,
                           delay: TimeInterval = 0.0,
                           completion: ((Bool) -> Void) = {_ in},
                           finalAlpha : CGFloat = 1.0 ,
                           animationOptions: UIViewAnimationOptions = []) {
        
        var initTransform = CGAffineTransform.identity.scaledBy(x: 0.5, y: 0.5);
        var transitionTransform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1);
        var finalTransform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9);
        
        if !isZoomIn {
            initTransform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1);
            transitionTransform = CGAffineTransform.identity.scaledBy(x: 0.5, y: 0.5);
            finalTransform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9);
        }
        
 
        UIView.animate(withDuration: duration/1.5, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: animationOptions, animations: {
            
            self.transform = initTransform
            
            }, completion: { (finished :Bool) -> Void in
                
                UIView.animate(withDuration: duration/1.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: animationOptions, animations: {
                    
                    self.transform = transitionTransform
                    
                    }, completion: { (finished :Bool) -> Void in
                        
                        UIView.animate(withDuration: duration/2, delay: 0,  options: animationOptions, animations: {
                            
                            self.transform = finalTransform
                            
                            }, completion: { (finished :Bool) -> Void in
                                
                                UIView.animate(withDuration: duration/2, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0.5, options: animationOptions, animations: {
                                    
                                    self.transform = CGAffineTransform.identity;
                                    
                                    }, completion: { (finished :Bool) -> Void in
                                        
                                        
                                })
                                
                        })
                        
                } )
        })
    }
    
    //MARK: - Helpers
    func setAnchorPoint(_ anchorPoint: CGPoint, forView view: UIView) {
        
        var newPoint = CGPoint(x: view.bounds.size.width * anchorPoint.x, y: view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: view.bounds.size.width * view.layer.anchorPoint.x, y: view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = newPoint.applying(view.transform)
        oldPoint = oldPoint.applying(view.transform)
        
        var position = view.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        view.translatesAutoresizingMaskIntoConstraints = true     // Added to deal with auto layout constraints
        
        view.layer.position = position
        view.layer.anchorPoint = anchorPoint
    }
    
}
