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
    
    var completionText: ((String) -> Void)!
    
    static let identifier = "textFieldCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.textField.delegate = self
        
        setupObserver()
    }

    
    
    //MARK: Setup dos observers
    func setupObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(myTextFieldDidChange), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    deinit{
        
        NotificationCenter.default.removeObserver(self)
    
    }
    
    //MARK: Deixar editável ou nao o textfield
    
    
    func dismiss(){
        self.textFieldDidEndEditing(self.textField)
    }
    
    func myTextFieldDidChange(){
        self.completionText(self.textField.text!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
        self.textField.resignFirstResponder()
    }
    
}


//MARK: TextFieldDelegate
extension TextFieldTableViewCell : UITextFieldDelegate{
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.completionText(textField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textField.resignFirstResponder()
        self.completionText(textField.text!)
        return true
    }
}




