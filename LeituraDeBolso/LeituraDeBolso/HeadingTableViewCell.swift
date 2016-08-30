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
    
    @IBOutlet weak var emojiOneImage: UIImageView!
    @IBOutlet weak var emojiTwoImage: UIImageView!
    @IBOutlet weak var emojiThreeImage: UIImageView!
    
    
    var reading: Reading? {
        didSet {
            self.updateUI()
        }
    }
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateUI () {
        
        self.titleLabel.text = self.reading?.title
        self.timeLabel.text = self.reading?.duration
        
      //  self.emojiOneImage.image = self.reading?.emojis![0]
        //self.emojiTwoImage.image = self.reading?.emojis![1]
        //self.emojiThreeImage.image = self.reading?.emojis![2]
        
    }

}
