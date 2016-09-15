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
    
    override func didMoveToWindow() {
        
        self.contentReadingLabel.setSizeFont(ApplicationState.sharedInstance.sizeFontSelected!)
        
        if ApplicationState.sharedInstance.modeNight == true {
            self.setNightMode()
        } else {
            self.setNormalMode()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    func updateUI () {
        
        self.authorReadingLabel.text = reading?.author
        self.contentReadingLabel.text = reading?.text
        
    }
    
    func setNightMode () {
        
        self.authorReadingLabel.textColor = UIColor.white
        self.contentReadingLabel.textColor = UIColor.white
        self.backgroundColor = UIColor.colorWithHexString("190126")
        
    }
    
    func setNormalMode () {
        
        self.authorReadingLabel.textColor = UIColor.black
        self.contentReadingLabel.textColor = UIColor.black
        self.backgroundColor = UIColor.white
    }
    


}
