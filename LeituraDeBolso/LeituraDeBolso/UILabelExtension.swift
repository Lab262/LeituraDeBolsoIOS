//
//  UILabelExtension.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 11/09/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

extension UILabel {
    func setSizeFont (_ sizeFont: CGFloat) {
        self.font =  UIFont(name: self.font.fontName, size: sizeFont)!
        self.sizeToFit()
    }
}
