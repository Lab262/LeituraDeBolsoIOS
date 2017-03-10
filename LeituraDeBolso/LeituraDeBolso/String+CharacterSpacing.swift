//
//  String+CharacterSpacing.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 10/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit


extension String {
    
    func with(characterSpacing: Double, lineSpacing: CGFloat = 0, alignment: NSTextAlignment = NSTextAlignment.left, color: UIColor = UIColor.clear) -> NSAttributedString {
        
        let att = NSMutableAttributedString(string: self)
        
        let attributeRange = NSRange(location: 0, length: att.length)
        
        att.addAttribute(NSKernAttributeName, value: characterSpacing, range: attributeRange)
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        style.alignment = alignment
        
        att.addAttribute(NSParagraphStyleAttributeName, value: style, range: attributeRange)
        
        if color != .clear {
            att.addAttribute(NSForegroundColorAttributeName, value: color, range: attributeRange)
        }
        
        
        return att
    }

}
