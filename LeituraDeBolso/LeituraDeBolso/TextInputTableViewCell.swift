////
////  TextInputTableViewCell.swift
////  LeituraDeBolso
////
////  Created by Huallyd Smadi on 20/09/16.
////  Copyright © 2016 Lab262. All rights reserved.
////
//
//import UIKit
//
////protocol TextInputWithLabelTableViewCellDelegate{
////    func textDidChange(cell: TextFieldTableViewCell, text: String?)
////    func userDidEndEdit(cell: TextFieldTableViewCell, text: String?)
////    func textFieldReturn(cell: TextFieldTableViewCell, text: String?)
////    func userDidBeginEdit(cell: TextFieldTableViewCell)
////}
//
//class TextInputTableViewCell: UITableViewCell {
//    
//    var delegate: TextInputWithLabelTableViewCellDelegate?
//    
//    //MARK: Outlets
//    
//    @IBOutlet weak var lblTitle: UILabel!
//    @IBOutlet weak var txtFieldInput: UITextField!
//    
//    @IBOutlet weak var separatorView: UIView!
//    
//    var hideSeparatorView: Bool = false {
//        didSet{
//            separatorView?.isHidden = hideSeparatorView
//        }
//    }
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        self.txtFieldInput.isEnabled = true
//        self.txtFieldInput.delegate = self
//        setupTargets()
//    }
//    
//    func setupTargets(){
//        txtFieldInput.addTarget(self, action: #selector(myTextFieldDidChange), for: UIControlEvents.valueChanged)
//    }
//    
//    //MARK: Setup dos observers
//    //    func setupObservers(){
//    //        NotificationCenter.default.addObserver(self, selector: #selector(myTextFieldDidChange), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
//    //    }
//    //
//    //    deinit{
//    //        NotificationCenter.default.removeObserver(self)
//    //    }
//    
//    //MARK: Deixar editável ou nao o textfield
//    
//    func setEditable(status : Bool){
//        self.txtFieldInput.isEnabled = status
//    }
//    
//    func dismiss(){
//        self.textFieldDidEndEditing(self.txtFieldInput)
//    }
//    
//    func myTextFieldDidChange(){
//        delegate?.textDidChange(cell: self, text: txtFieldInput.text)
//        //self.completionText?(self.txtFieldInput.text!)
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        //        self.endEditing(true)
//        self.txtFieldInput.resignFirstResponder()
//    }
//    
//    
//    //MARK: Prepare For Reuse
//    override func prepareForReuse() {
//        self.txtFieldInput.text = ""
//        self.txtFieldInput.isSecureTextEntry = false
//    }
//}
//
//
////MARK: TextFieldDelegate
//extension TextInputTableViewCell : UITextFieldDelegate{
//    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        delegate?.userDidBeginEdit(cell: self)
//    }
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        delegate?.userDidEndEdit(cell: self, text: txtFieldInput.text)
//        
//    }
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        //        self.txtFieldInput.resignFirstResponder()
//        delegate?.textFieldReturn(cell: self, text: txtFieldInput.text)
//        return true
//    }
//}
//
