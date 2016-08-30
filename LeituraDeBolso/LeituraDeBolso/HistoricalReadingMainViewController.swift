//
//  HistoricalReadingMainViewController.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 30/08/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit


protocol SegmentControlButtonDelegate {
    func segmentSelected(viewIndex: Int)
}

class HistoricalReadingMainViewController: UIViewController {
    
    var segmentControlButtonDelegate: SegmentControlButtonDelegate?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func showAllHistorical(sender: AnyObject? = nil) {
        setSelectionIndication(true, center: false, trailing: false)
        segmentControlButtonDelegate?.segmentSelected(0)

        
    }
    
    @IBAction func showFavoriteHistorical(sender: AnyObject? = nil) {
        setSelectionIndication(false, center: true, trailing: false)
        segmentControlButtonDelegate?.segmentSelected(1)
    }
    
    
    @IBAction func showUnreadHistorical(sender: AnyObject? = nil) {
        setSelectionIndication(false, center: false, trailing: true)
        segmentControlButtonDelegate?.segmentSelected(2)

        
    }
    
    func setSelectionIndication(leading: Bool, center:Bool, trailing: Bool) {
//        self.segmentSelectionIndicatorLeding.active = false
//        self.segmentSelectionIndicatorCenterX.active = false
//        self.segmentSelectionIndicatorTrailing.active = false
//        
//        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .CurveEaseInOut, animations: {
//            self.segmentSelectionIndicatorLeding.active = leading
//            self.segmentSelectionIndicatorCenterX.active = center
//            self.segmentSelectionIndicatorTrailing.active = trailing
//            self.view.layoutIfNeeded()
//            }, completion: nil)
        
    }

    
}


extension HistoricalReadingMainViewController: SegmentControlPageDelegate {
    
    func segmentScrolled(viewIndex: Int) {
        switch viewIndex {
        case 0:
            showAllHistorical()
            break
        case 1:
            showFavoriteHistorical()
            break
        case 2:
            showUnreadHistorical()
            break
            
        default: break
        }
    }
    
}

