//
//  MainOnboardViewController.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 13/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class MainOnboardViewController: UIViewController {
    
    @IBOutlet weak var firstIndicatorButton: UIButton!
    @IBOutlet weak var secondIndicatorButton: UIButton!
    @IBOutlet weak var thirdIndicatorButton: UIButton!
    
    var segmentControlButtonDelegate: SegmentControlButtonDelegate?
    var currentSegment = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let onboardVC = segue.destination as? OnboardViewController {
            self.segmentControlButtonDelegate = onboardVC
            onboardVC.segmentControlPageDelegate = self
        }
    }
    
    
    @IBAction func skipOnboard(_ sender: Any) {
        
    }
    
    @IBAction func nextViewOnboard(_ sender: Any? = nil) {
        if currentSegment == 2 {
            print ("DONE")
        } else {
            segmentControlButtonDelegate?.segmentSelected(currentSegment+1)
        }
    }
    
    @IBAction func showFirstView(_ sender: Any? = nil) {
        segmentControlButtonDelegate?.segmentSelected(0)
    }
    
    @IBAction func showSecondView(_ sender: Any? = nil) {
        segmentControlButtonDelegate?.segmentSelected(1)
    }
    
    @IBAction func showThirdView(_ sender: Any? = nil) {
        segmentControlButtonDelegate?.segmentSelected(2)
    }
}

extension MainOnboardViewController: SegmentControlPageDelegate {
    
    func segmentScrolled(_ viewIndex: Int) {
        switch viewIndex {
        case 0:
            currentSegment = 0
            showFirstView()
        case 1:
            currentSegment = 1
            showSecondView()
        case 2:
            currentSegment = 2
            showThirdView()
        default: break
            
        }
    }
}

