//
//  ButtonsTableViewCell.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 29/08/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class ButtonsTableViewCell: UITableViewCell {
    
    static let identifier = "buttonsCell"
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.likeButton.setImage(UIImage(named: "button_likeRead_inactive"), forState: .Normal)
        self.likeButton.setImage(UIImage(named: "button_likeRead_active"), forState: .Selected)
        
        if ApplicationState.sharedInstance.modeNight == true {
            self.setNightMode()
        } else {
            self.setNormalMode()
        }
        
    }
    
    
    func setNightMode () {
        
        self.backgroundColor = UIColor.colorWithHexString("190126")
        
    }
    
    func setNormalMode () {
        
        self.backgroundColor = UIColor.whiteColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    
    @IBAction func likeReading(sender: AnyObject) {
        
        if !self.likeButton.selected {
        
            self.likeButton.selected = true

           // self.likeButton.selectedButtonWithImage(UIImage(named: "button_likeRead_active")!)
            
            self.likeButton.bouncingAnimation(true, duration: 0.2, delay: 0.0, completion: { (finished) in
                
                if finished {
                    
                  //  self.likeButton.selected = true

                }
                
                }, finalAlpha: 1.0, animationOptions: UIViewAnimationOptions.CurveEaseIn)
        } else {
            
            self.likeButton.selected = false
            self.likeButton.bouncingAnimation(true, duration: 0.2, delay: 0.0, completion: { (finished) in
                
                if finished {
                    
                  //  self.likeButton.selected = false
                }
                
                
                }, finalAlpha: 1.0, animationOptions: UIViewAnimationOptions.CurveEaseIn)
            

        }
        
    }

}


