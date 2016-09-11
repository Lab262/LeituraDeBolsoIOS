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
    @IBOutlet weak var emojiOneLabel: UILabel!
    @IBOutlet weak var emojiTwoLabel: UILabel!
    @IBOutlet weak var emojiThreeLabel: UILabel!
    
    
    var reading: Reading? {
        didSet {
            self.updateUI()
        }
    }
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        if ApplicationState.sharedInstance.modeNight == true {
            self.setNightMode()
        } else {
            self.setNormalMode()
        }
    }
    
    
    func setNightMode () {
        
        self.titleLabel.textColor = UIColor.whiteColor()
        self.timeLabel.textColor = UIColor.whiteColor()
        self.backgroundColor = UIColor.colorWithHexString("190126")
        
    }
    
    func setNormalMode () {
        
        self.titleLabel.textColor = UIColor.blackColor()
        self.timeLabel.textColor = UIColor.blackColor()
        self.backgroundColor = UIColor.whiteColor()
    }


    func updateUI () {
        
        self.titleLabel.text = self.reading?.title
        self.timeLabel.text = self.reading?.duration
        
        
        self.emojiOneLabel.text = self.reading?.emojis?[0]
        self.emojiTwoLabel.text = self.reading?.emojis?[1]
        self.emojiThreeLabel.text = self.reading?.emojis?[2]
     
    }

}
