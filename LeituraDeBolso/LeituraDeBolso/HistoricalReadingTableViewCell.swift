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
    
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emojiOneImage: UIImageView!
    @IBOutlet weak var emojiTwoImage: UIImageView!
    @IBOutlet weak var emojiThreeImage: UIImageView!
    
    @IBOutlet weak var authorLabel: UILabel!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    

}
