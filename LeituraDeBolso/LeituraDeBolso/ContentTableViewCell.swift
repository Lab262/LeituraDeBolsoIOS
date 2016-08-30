//
//  ContentTableViewCell.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 29/08/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class ContentTableViewCell: UITableViewCell {

    static let identifier = "contentCell"
    
    @IBOutlet weak var authorReadingLabel: UILabel!
    @IBOutlet weak var contentReadingLabel: UILabel!
    
    var reading: Reading? {
        didSet {
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateUI () {
        
        self.authorReadingLabel.text = reading?.author
        self.contentReadingLabel.text = reading?.text
        
    }

}
