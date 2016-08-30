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
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    
    @IBAction func likeReading(sender: AnyObject) {
        
        if !self.likeButton.selected {
            self.likeButton.selected = true
            
        } else {
            self.likeButton.selected = false
        }
        
    }

}

