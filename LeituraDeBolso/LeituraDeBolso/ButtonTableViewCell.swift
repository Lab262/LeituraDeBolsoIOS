//
//  ButtonTableViewCell.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 09/09/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit


class ButtonTableViewCell: UITableViewCell {
    
    static let identifier = "buttonCell"
    
    @IBOutlet weak var button: UIButton!
    
    static let cellHeight: CGFloat = 75

    override func awakeFromNib() {
        super.awakeFromNib()
        setDynamicSizeFonts()
        // Initialization code
    }
    func setDynamicSizeFonts(){
        button.titleLabel?.setDynamicFont()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
