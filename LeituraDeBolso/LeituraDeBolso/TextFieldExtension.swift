//
//  TextFieldExtension.swift
//  FaleCondominio
//
//  Created by Huallyd Smadi on 22/08/16.
//  Copyright © 2016 mobgap. All rights reserved.
//

import UIKit

extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!])
        }
    }
}
