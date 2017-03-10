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
        
        if ApplicationState.sharedInstance.currentUser!.isModeNight {
            self.setNightMode()
        } else {
            self.setNormalMode()
        }
    }
    
     override func layoutSubviews() {
        self.contentReadingLabel.setSizeFont(ApplicationState.sharedInstance.currentUser!.sizeFont)
      
     }
    
//    func setBaseFontSize(){
//        let proportion = UIView.heightScaleProportion()
//        
//        if proportion == 1 {
//            sizeBaseLabel = 17
//        } else if proportion < 1 {
//            sizeBaseLabel = 15
//        } else {
//            sizeBaseLabel = 19
//        }
//    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
   
    }

    func updateUI () {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        
        let attrString = NSMutableAttributedString(string: reading!.content!)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        contentReadingLabel.attributedText = attrString
        self.authorReadingLabel.text = reading?.author
        //self.contentReadingLabel.text = reading?.content
    }
    
    func setNightMode () {
        
        self.authorReadingLabel.textColor = UIColor.white
        self.contentReadingLabel.textColor = UIColor.white
        self.backgroundColor = UIColor.readingModeNightBackground()
    }
    
    func setNormalMode () {
        
        self.authorReadingLabel.textColor = UIColor.black
        self.contentReadingLabel.textColor = UIColor.black
        self.backgroundColor = UIColor.white
    }
    


}
