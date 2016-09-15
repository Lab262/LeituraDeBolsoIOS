//
//  StepSlider.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 11/09/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit


@IBDesignable

open class StepSlider: UISlider {

    // Inspectables
    @IBInspectable open var steps: Int = 5 {
        didSet { maximumValue = Float(steps - 1) }
    }
    @IBInspectable open var minValue: Float = 0.0 {
        didSet { minimumValue = minValue }
    }
    @IBInspectable open var maxValue: Float = 4.0 {
        didSet { maximumValue = maxValue }
    }
    @IBInspectable open var customTrack: Bool = false
    @IBInspectable open var trackHeight: Int = 1
    @IBInspectable open var trackColor: UIColor = UIColor.colorWithHexString("BFBFBF")
    @IBInspectable open var stepTickWidth: Int = 1
    @IBInspectable open var stepTickHeight: Double = 12
    @IBInspectable open var stepTickColor: UIColor = UIColor.colorWithHexString("BFBFBF")
    @IBInspectable open var stepTickRounded: Bool = false
    
    // Computeds
    var stepWidth: Double {
        return Double(trackWidth) / (Double(steps - 1))
    }
    var thumbRect: CGRect {
        let trackRect = self.trackRect(forBounds: bounds)
        return self.thumbRect(forBounds: bounds, trackRect: trackRect, value: value)
    }
    var trackWidth: CGFloat {
        return self.bounds.size.width - thumbRect.width
    }
    var trackOffset: CGFloat {
        return (self.bounds.size.width - self.trackWidth) / 2
    }
    
    // Properties for handling touch
    var previousLocation = CGPoint.zero
    var dragging = false
    var originalValue: Int = 0
    
    // Methods
    override open func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        drawTrack()
    }
    
    func drawTrack() {
        
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.saveGState()
        
        // Remove the original track if custom
        if customTrack {
            
            // Clear original track using a transparent pixel
            UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0.0)
            let transparentImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            setMaximumTrackImage(transparentImage, for: UIControlState())
            setMinimumTrackImage(transparentImage, for: UIControlState())
            
            // Draw custom track
            ctx?.setFillColor(trackColor.cgColor)
            let x = trackOffset
            let y = Int((bounds.height / 2)) - (trackHeight / 2)
            let trackPath = UIBezierPath(rect: CGRect(x: Int(x), y: y, width: Int(bounds.width - (trackOffset * 2)), height: trackHeight))
            
            ctx?.addPath(trackPath.cgPath)
            ctx?.fillPath()
        }
        
        
        // Draw ticks
        ctx?.setFillColor(stepTickColor.cgColor)
        
        for index in 0..<steps {
            
            let x = Double(trackOffset) + (Double(index) * stepWidth) - Double(stepTickWidth / 2)
            let y = Double(bounds.midY) - (stepTickHeight / 2)
            
            // Create rounded/squared tick bezier
            let stepPath: UIBezierPath
            if customTrack && stepTickRounded {
                stepPath = UIBezierPath(roundedRect: CGRect(x: x, y: y, width: Double(stepTickWidth), height: stepTickHeight), cornerRadius: 5)
            } else {
                stepPath = UIBezierPath(rect: CGRect(x: x, y: y, width: Double(stepTickWidth), height: stepTickHeight))
            }
            
            ctx?.addPath(stepPath.cgPath)
            ctx?.fillPath()
        }
        
        ctx?.restoreGState()
    }
}


// MARK: - Touch Handling
extension StepSlider {
    
    override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        originalValue = Int(value)
        
        if thumbRect.contains(location) {
            dragging = true
        } else {
            dragging = false
        }
        
        previousLocation = location
        
        return dragging
    }
    
    override open func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        
        let deltaLocation = Double(location.x) - Double(previousLocation.x)
        let deltaValue = Int(round(fabs(deltaLocation) / stepWidth))
        
        func clipValue(_ value: Int) -> Int {
            return min(max(value, Int(minimumValue)), Int(maximumValue))
        }
        
        if deltaLocation < 0 {
            value = Float(clipValue(originalValue - deltaValue))  // Slide left
        } else {
            value = Float(clipValue(originalValue + deltaValue))  // Slide right
        }
        
        // Update UI without animation
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        setNeedsLayout()
        CATransaction.commit()
        
        return true
    }
    
    override open func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        previousLocation = CGPoint.zero
        originalValue = 0
        dragging = false
        
        if self.isContinuous == false {
            self.sendActions(for: .valueChanged)
        }
    }
}

// MARK: - Helpers
extension StepSlider {
    func setupView() {
        minValue = 0
        maxValue = 4
    }
}


// MARK: - IB
extension StepSlider {
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
        drawTrack()
        
        value = 1
    }

}
