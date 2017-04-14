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
    
    @IBOutlet weak var firstIndicatorView: UIView!
    @IBOutlet weak var secondIndicatorView: UIView!
    @IBOutlet weak var thirdIndicatorView: UIView!
    
    let selectedHeight: CGFloat = 8 * UIView.heightScaleProportion()
    let unselectedHeight: CGFloat = 5 * UIView.heightScaleProportion()
    
    @IBOutlet weak var firstIndicatorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondIndicatorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var thirdIndicatorHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    var indicatorViews = [UIView]()
    var heightConstraints = [NSLayoutConstraint]()
    
    var segmentControlButtonDelegate: SegmentControlButtonDelegate?
    
    var currentSegment = 0 {
        didSet{
          updateAlphaButtons()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton.isEnabled = false
        indicatorViews = [firstIndicatorView, secondIndicatorView, thirdIndicatorView]
        heightConstraints = [firstIndicatorHeightConstraint, secondIndicatorHeightConstraint, thirdIndicatorHeightConstraint]
        setSelectedViewBy(selectedIndex: 0)
    }
    
    func updateAlphaButtons(){
        if currentSegment == 2 {
            nextButton.isEnabled = false
            doneButton.isEnabled = true
            UIView.animate(withDuration: 0.2, animations: {
                self.nextButton.alpha = 0.0
                self.doneButton.alpha = 1.0
            })
        } else if doneButton.alpha == 1.0 {
            nextButton.isEnabled = true
            doneButton.isEnabled = false
            UIView.animate(withDuration: 0.2, animations: {
                self.nextButton.alpha = 1.0
                self.doneButton.alpha = 0.0
            })
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let onboardVC = segue.destination as? OnboardViewController {
            self.segmentControlButtonDelegate = onboardVC
            onboardVC.segmentControlPageDelegate = self
        }
    }
    
    @IBAction func skipOnboard(_ sender: Any) {
        goLoginView()
    }
    
    func goLoginView() {
        let loginView = ViewUtil.viewControllerFromStoryboardWithIdentifier("Login")
        
        present(loginView!, animated: true, completion: nil)
    }
    
    
    @IBAction func nextViewOnboard(_ sender: Any? = nil) {
        if currentSegment == 2 {
            goLoginView()
        } else {
            segmentControlButtonDelegate?.segmentSelected(currentSegment+1)
        }
    }
    
    @IBAction func doneViewOnboard(_ sender: Any) {
        goLoginView()
    }
    
    func setSelectedViewBy(selectedIndex: Int){
        UIView.animate(withDuration: 0.2) { 
            for (i, height) in self.heightConstraints.enumerated() {
                if i == selectedIndex {
                    self.indicatorViews[i].backgroundColor = UIColor.colorWithHexString("9142BE")
                    height.constant = self.selectedHeight
                } else {
                    self.indicatorViews[i].backgroundColor = UIColor.colorWithHexString("009CAE")
                    height.constant = self.unselectedHeight
                }
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func showFirstView(_ sender: Any? = nil) {
        setSelectedViewBy(selectedIndex: 0)
        segmentControlButtonDelegate?.segmentSelected(0)
    }
    
    @IBAction func showSecondView(_ sender: Any? = nil) {
        setSelectedViewBy(selectedIndex: 1)
        segmentControlButtonDelegate?.segmentSelected(1)
    }
    
    @IBAction func showThirdView(_ sender: Any? = nil) {
        setSelectedViewBy(selectedIndex: 2)
        segmentControlButtonDelegate?.segmentSelected(2)
    }

    
    override var prefersStatusBarHidden: Bool {
        return true
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

