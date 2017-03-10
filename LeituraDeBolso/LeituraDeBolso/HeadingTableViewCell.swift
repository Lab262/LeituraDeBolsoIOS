//
//  HeadingTableViewCell.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 29/08/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class HeadingTableViewCell: UITableViewCell {
    
    
    static let identifier = "headingCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
   
    
    
    var reading: Reading? {
        didSet {
            self.updateUI()
        }
    }
    
    
    override func didMoveToWindow() {
        
        if ApplicationState.sharedInstance.currentUser!.isModeNight {
            self.setNightMode()
        } else {
            self.setNormalMode()
        }
        
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
//        if ApplicationState.sharedInstance.modeNight == true {
//            self.setNightMode()
//        } else {
//            self.setNormalMode()
//        }
    }
    
    
    func setNightMode () {
        
        self.titleLabel.textColor = UIColor.white
        self.timeLabel.textColor = UIColor.white
        self.backgroundColor = UIColor.colorWithHexString("190126")
        
    }
    
    func setNormalMode () {
        
        self.titleLabel.textColor = UIColor.black
        self.timeLabel.textColor = UIColor.colorWithHexString("9B9B9B")
        self.backgroundColor = UIColor.white
    }


    func updateUI () {
        
        self.titleLabel.attributedText = self.reading?.title?.with(characterSpacing: 1.0)
        self.timeLabel.text = ("\(self.reading!.duration.description) min")
        
        
    }

}
