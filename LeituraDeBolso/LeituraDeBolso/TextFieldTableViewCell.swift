//
//  TextFieldTableViewCell.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 09/09/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {
 
    @IBOutlet weak var iconHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var iconWidthConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var textField: UITextField!
    
    static let identifier = "textFieldCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
