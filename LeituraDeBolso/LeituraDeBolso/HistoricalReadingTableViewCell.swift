//
//  HistoricalReadingTableViewCell.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 30/08/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class HistoricalReadingTableViewCell: UITableViewCell {
    
    
    static let identifier = "historicalCell"
    
    var reading: Reading? {
        didSet {
            updateUI()
        }
    }
    
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var viewLine: UIView!
    
    
    @IBOutlet weak var emojiOneLabel: UILabel!
    
    @IBOutlet weak var emojiTwoLabel: UILabel!
    
    @IBOutlet weak var emojiThreeLabel: UILabel!

    @IBOutlet weak var authorLabel: UILabel!
    
    
    
    override func didMoveToWindow() {
        
        if ApplicationState.sharedInstance.currentUser!.isModeNight {
            self.setNightMode()
        }
      
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.likeButton.setImage(UIImage(named: "button_likeHistoric_inactive"), for: UIControlState())
        self.likeButton.setImage(UIImage(named: "button_likeHistoric_active"), for: .selected)
        
    }
    
    
    func setNightMode() {
        
        self.backgroundColor = UIColor.readingModeNightBackground()
        self.titleLabel.textColor = UIColor.white
        self.authorLabel.textColor = UIColor.lightGray
    
    }
    
    func updateUI() {
        
        self.titleLabel.text = self.reading?.title
        self.authorLabel.text = self.reading?.author
        
        if self.reading?.emojis.count == 1 {
            self.emojiOneLabel.text = self.reading?.emojis[0].getEmojiByUniCode()
            self.emojiTwoLabel.text = ""
            self.emojiThreeLabel.text = ""
        } else if self.reading?.emojis.count == 2 {
            self.emojiOneLabel.text = self.reading?.emojis[0].getEmojiByUniCode()
            self.emojiTwoLabel.text = self.reading?.emojis[1].getEmojiByUniCode()
            self.emojiThreeLabel.text = ""
        } else if self.reading?.emojis.count == 3 {
            self.emojiOneLabel.text = self.reading?.emojis[0].getEmojiByUniCode()
            self.emojiTwoLabel.text = self.reading?.emojis[1].getEmojiByUniCode()
            self.emojiThreeLabel.text = self.reading?.emojis[2].getEmojiByUniCode()
        } else {
            self.emojiOneLabel.text = ""
            self.emojiTwoLabel.text = ""
            self.emojiThreeLabel.text = ""
        }

        
    }
    
    @IBAction func likeReading(_ sender: AnyObject) {
        
        if !self.likeButton.isSelected {
            
            self.likeButton.isSelected = true
            
            // self.likeButton.selectedButtonWithImage(UIImage(named: "button_likeRead_active")!)
            
            self.likeButton.bouncingAnimation(true, duration: 0.2, delay: 0.0, completion: { (finished) in
                
                if finished {
                    
                    //  self.likeButton.selected = true
                    
                }
                
                }, finalAlpha: 1.0, animationOptions: UIViewAnimationOptions.curveEaseIn)
        } else {
            
            self.likeButton.isSelected = false
            self.likeButton.bouncingAnimation(true, duration: 0.2, delay: 0.0, completion: { (finished) in
                
                if finished {
                    
                    //  self.likeButton.selected = false
                }
                
                
                }, finalAlpha: 1.0, animationOptions: UIViewAnimationOptions.curveEaseIn)
            
            
        }
        
    }
    
}
