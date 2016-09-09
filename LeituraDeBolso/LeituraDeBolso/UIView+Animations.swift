//
//  UIView+Animations.swift
//  ThiagoBernardes
//
//  Created by Thiago-Bernardes on 3/20/16.
//  Copyright © 2016 TB. All rights reserved.
//
import UIKit

enum WipeDirection {
    
    case BottomToTop ,LeftToRight, TopToBottom, RightToLeft
    
}

enum RotationDegree {
    
    case Degree360, Degree180, Degree90, Degree45
}

enum RotationType {
    
    case ClockWize, UnClockWize
}

extension UIView {
    
    func fadeIn(duration: NSTimeInterval = 1.0, delay: NSTimeInterval = 0.0, completion: ((Bool) -> Void) = {(finished: Bool) -> Void in}, finalAlpha : CGFloat = 1.0) {
        self.alpha = 0.0
        
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.alpha = finalAlpha
            }, completion: completion)  }
    
    func fadeOut(duration: NSTimeInterval = 1.0, delay: NSTimeInterval = 0.0, completion: ((Bool) -> Void) = {(finished: Bool) -> Void in}, finalAlpha : CGFloat = 0.0) {
        
        self.alpha = 1.0
        
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.alpha = finalAlpha
            }, completion: completion)
    }
    
    func slideInFromLeft(duration: NSTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        // Create a CATransition animation
        let slideInFromLeftTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided (if any)
        if let delegate: AnyObject = completionDelegate {
            slideInFromLeftTransition.delegate = delegate
        }
        
        // Customize the animation's properties
        slideInFromLeftTransition.type = kCATransitionPush
        slideInFromLeftTransition.subtype = kCATransitionFromLeft
        slideInFromLeftTransition.duration = duration
        slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        slideInFromLeftTransition.fillMode = kCAFillModeRemoved
        
        // Add the animation to the View's layer
        self.layer.addAnimation(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")
    }
    
    func rotateInDiraction(
        direction: RotationType,andDegrees
        degrees: RotationDegree,
        duration: CFTimeInterval = 1.0,
        delay: CFTimeInterval = 1.0,
        completionBlock: (() -> Void)? = {}) {
        
        UIView.animateWithDuration(duration, delay: delay, options: [], animations: {
            
            var rotationConstant = CGFloat(M_PI * 2.0)
            
            switch degrees {
            case .Degree360:
                rotationConstant = CGFloat(M_PI * 2.0)
            case .Degree180:
                rotationConstant = CGFloat(M_PI )
            case .Degree90:
                rotationConstant = CGFloat(M_PI_2)
            case .Degree45:
                rotationConstant = CGFloat(M_PI_4)
            }
            
            switch direction {
            case .ClockWize:
                rotationConstant = 1 * rotationConstant
            case .UnClockWize:
                rotationConstant = -1 * rotationConstant
                
            }
            
            self.transform = CGAffineTransformMakeRotation(rotationConstant)
        
        }) { (finished: Bool) in
            if completionBlock != nil {
                completionBlock!()

            }
        }
        
    }
    
    func wipeInDirection(
        wipeDirection: WipeDirection,
        isOutAnimation: Bool,
        duration: NSTimeInterval,
        percentageVertical: CGFloat = 1.0,
        percentageHorizontal: CGFloat = 1.0,
        timingFunction: CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
        completionDelegate: AnyObject? = nil) {
        
        var direction = CGPoint(x: 1, y: 0)
        
        switch wipeDirection {
        case .BottomToTop:
            direction = CGPoint(x: 0, y: -1)
        case .LeftToRight:
            direction = CGPoint(x: -1, y: 0)
        case .TopToBottom:
            direction = CGPoint(x: 0, y: 1)
        case .RightToLeft:
            direction = CGPoint(x: 1, y: 0)
        }
        
        let contentView = self
        
        var startRootViewBounds = self.bounds
        
        //        self.addSubview(contentView)
        //        self.backgroundColor = UIColor.clearColor()
        
        var endingContentsRect: CGRect = CGRectMake(0, 0, 1 - abs(direction.x), 1 - abs(direction.y))
        
        
        if direction.x < 0 {
            endingContentsRect.origin.x = 1
        }
        if direction.y < 0 {
            endingContentsRect.origin.y = 1
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        //        contentView.layer.anchorPoint = CGPointMake(0.5, 0.4)
        let useLowerRight: Bool = (direction.x + direction.y < 0)
        if useLowerRight {
            
            setAnchorPoint(CGPointMake(1, 1), forView: contentView)
        }
        else {
            
            setAnchorPoint(CGPointZero, forView: contentView)
            
            
        }
        
        
        var startContentLayerRect = contentView.bounds
        var startContentLayerBounds = contentView.layer.bounds
        var endingContentsBounds = endingContentsRect
        
        if !isOutAnimation {
            
            let aux = startRootViewBounds
            startRootViewBounds = endingContentsBounds
            endingContentsBounds = aux
            
        }
        
        let t: CGAffineTransform = CGAffineTransformMakeScale(startRootViewBounds.width,startRootViewBounds.height)
        var endingBounds: CGRect = CGRectApplyAffineTransform(endingContentsBounds, t)
    
        
        //Apply percentage
        startContentLayerRect.size = CGSize(
            width: startContentLayerRect.width * percentageHorizontal,
            height: startContentLayerRect.height * percentageVertical)
        endingContentsRect.size = CGSize(
            width: endingContentsRect.width * percentageHorizontal,
            height: endingContentsRect.height * percentageVertical)
        startContentLayerBounds.size = CGSize(
            width: startContentLayerBounds.width * percentageHorizontal,
            height: startContentLayerBounds.height * percentageVertical)
        endingBounds.size = CGSize(
            width: endingBounds.width * percentageHorizontal,
            height: endingBounds.height * percentageVertical)
        
        if !isOutAnimation {
            var aux = startContentLayerRect
            startContentLayerRect = endingContentsRect
            endingContentsRect = aux
            
            aux = startContentLayerBounds
            startContentLayerBounds = endingBounds
            endingBounds = aux
        }
        
        
        let contentsRectAnim: CABasicAnimation = CABasicAnimation(keyPath: "contentsRect")
        contentsRectAnim.fromValue = NSValue(CGRect: startContentLayerRect)
        contentsRectAnim.toValue = NSValue(CGRect: endingContentsRect)
        
        let boundsAnim: CABasicAnimation = CABasicAnimation(keyPath: "bounds")
        boundsAnim.fromValue = NSValue(CGRect: startContentLayerBounds)
        boundsAnim.toValue = NSValue(CGRect: CGRectMake(endingBounds.origin.x, endingBounds.origin.y, endingBounds.width, endingBounds.height))
        let animations: CAAnimationGroup = CAAnimationGroup()
        if let delegate: AnyObject = completionDelegate {
            animations.delegate = delegate
        }
        animations.duration = duration
        animations.timingFunction = timingFunction
        animations.animations = [contentsRectAnim, boundsAnim]
        contentView.layer.addAnimation(animations, forKey: "wipeOut")
        contentView.layer.contentsRect = endingContentsRect
        contentView.layer.bounds = endingBounds
        
    }
    
    
    func clockWiseWipe(
        duration: CFTimeInterval,
        timingFunction: CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
        completionDelegate: AnyObject? = nil, theBlock : (() -> Void)?) {
        
        self.hidden = false
        
        let maskLayer = CAShapeLayer()
        let maskHeight = self.layer.bounds.size.height
        let maskWidth = self.layer.bounds.size.width
        
        let centerPoint = CGPointMake(maskWidth/2, maskHeight/2)
        
        let radius = CGFloat(sqrtf(Float(maskWidth) * Float(maskWidth) + Float(maskHeight) * Float(maskHeight))/2)
        
        maskLayer.fillColor = UIColor.clearColor().CGColor
        maskLayer.strokeColor = UIColor.blackColor().CGColor
        
        maskLayer.lineWidth = CGFloat(radius)
        
        let arcPath = CGPathCreateMutable()
        
        CGPathMoveToPoint(arcPath, nil, centerPoint.x, centerPoint.y - radius/2)
        
        CGPathAddArc(arcPath,
                     nil,
                     centerPoint.x,
                     centerPoint.y,
                     radius/2,
                     3.0 * CGFloat(M_PI/2),
                     CGFloat(-M_PI/2),
                     true)
        
        maskLayer.path = arcPath
        
        maskLayer.strokeEnd = 0.0
        
        self.layer.mask = maskLayer
        
        self.layer.mask?.frame = self.layer.bounds
        
        let swipe = CABasicAnimation(keyPath: "strokeEnd")
        
        swipe.duration = duration
        
        if let delegate: AnyObject = completionDelegate {
            swipe.delegate = delegate
        }
        swipe.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        swipe.fillMode = kCAFillModeForwards
        swipe.removedOnCompletion = false
        swipe.autoreverses = false
    
        swipe.toValue = NSNumber(float: 1)
        
        maskLayer.addAnimation(swipe, forKey: "strokeEnd")
        
    }
    
    func bouncingAnimation(isZoomIn: Bool = true,
                           duration: NSTimeInterval = 1.0,
                           delay: NSTimeInterval = 0.0,
                           completion: ((Bool) -> Void) = {_ in},
                           finalAlpha : CGFloat = 1.0 ,
                           animationOptions: UIViewAnimationOptions = []) {
        
        var initTransform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);
        var transitionTransform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        var finalTransform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        
        if !isZoomIn {
            initTransform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
            transitionTransform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);
            finalTransform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        }
        
 
        UIView.animateWithDuration(duration/1.5, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: animationOptions, animations: {
            
            self.transform = initTransform
            
            }, completion: { (finished :Bool) -> Void in
                
                UIView.animateWithDuration(duration/1.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: animationOptions, animations: {
                    
                    self.transform = transitionTransform
                    
                    }, completion: { (finished :Bool) -> Void in
                        
                        UIView.animateWithDuration(duration/2, delay: 0,  options: animationOptions, animations: {
                            
                            self.transform = finalTransform
                            
                            }, completion: { (finished :Bool) -> Void in
                                
                                UIView.animateWithDuration(duration/2, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0.5, options: animationOptions, animations: {
                                    
                                    self.transform = CGAffineTransformIdentity;
                                    
                                    }, completion: { (finished :Bool) -> Void in
                                        
                                        
                                })
                                
                        })
                        
                } )
        })
    }
    
    func shakeAnimation(duration : NSTimeInterval = 7/100, repeatCount : Float = 3, intensity: CGFloat = 5.0,
        completionDelegate: AnyObject? = nil) {
        
        let anim = CAKeyframeAnimation( keyPath:"transform" )
        anim.values = [
            NSValue( CATransform3D:CATransform3DMakeTranslation(-intensity, 0, 0 ) ),
            NSValue( CATransform3D:CATransform3DMakeTranslation( intensity, 0, 0 ) )
        ]
        anim.autoreverses = true
        anim.repeatCount = repeatCount
        anim.duration = duration
        if let delegate: AnyObject = completionDelegate {
            anim.delegate = delegate
        }
        anim.setValue("shakeAnimation", forKey: "identifier")
        self.layer.addAnimation( anim, forKey:"shakeAnimation" )
        
    }
    
    //MARK: - Helpers
    func setAnchorPoint(anchorPoint: CGPoint, forView view: UIView) {
        
        var newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = CGPointApplyAffineTransform(newPoint, view.transform)
        oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform)
        
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
