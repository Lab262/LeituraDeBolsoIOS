//
//  LoginViewController.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 24/08/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

let KEY_EMAIL = "email"
let KEY_PASS = "pass"
let KEY_CONFIRM_PASS = "confirmationPass"




class LoginViewController: UIViewController {
    
    @IBOutlet weak var bottomTableConstraint: NSLayoutConstraint!
    var dictionaryTextFields = Dictionary <String, String>()
    
    @IBOutlet weak var tableView: UITableView!
    
    var lastEditingCell: TextFieldTableViewCell?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerNibs()
        
        self.configureGestureRecognizer()
        
        self.registerObservers()
      
        
    }
    
    private func registerObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func registerNibs () {
        
        self.tableView.register(UINib(nibName: "ImageLogoTableViewCell", bundle: nil), forCellReuseIdentifier: ImageLogoTableViewCell.identifier)
        
        self.tableView.register(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: TextFieldTableViewCell.identifier)
        
        self.tableView.register(UINib(nibName: "ButtonTableViewCell", bundle: nil), forCellReuseIdentifier: ButtonTableViewCell.identifier)
        
    }
    
    func generateLogoImageCell (_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageLogoTableViewCell.identifier, for: indexPath) as! ImageLogoTableViewCell
        
        cell.titleLabel.text = "Log in"
        
        return cell
    }
    
    func generateEmailTextFieldCell (_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as! TextFieldTableViewCell
        
        cell.iconImage.image = UIImage(named: "icon_email")
        cell.textField.placeholder = "Email"
        
        cell.textField.keyboardType = .emailAddress
        cell.completionText = {(text) -> Void in
            self.dictionaryTextFields[KEY_EMAIL] = text
        }

        
        return cell
    }
    
    func generatePasswordTextFieldCell (_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as! TextFieldTableViewCell
        
        cell.iconHeightConstraint.constant = 31
        cell.iconWidthConstraint.constant = 23
        
        cell.textField.isSecureTextEntry = true
        cell.iconImage.image = UIImage(named: "icon_pass")
        cell.textField.placeholder = "Senha"
        
        cell.completionText = {(text) -> Void in
            self.dictionaryTextFields[KEY_PASS] = text
        }
        
        
        return cell
    }
    
    func generateForgotPassButtonCell (_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.identifier, for: indexPath) as! ButtonTableViewCell
        
        
        cell.button.addTarget(self, action: #selector(recoverPassword(_:)), for: .touchUpInside)
        
        cell.button.titleLabel?.font = UIFont(name: "Comfortaa", size: 15)
        cell.button.setTitle("Esqueci a senha", for: UIControlState())
        cell.button.backgroundColor = UIColor.clear
        
        
        
        return cell
    }
    
    func generateLoginButtonCell (_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.identifier, for: indexPath) as! ButtonTableViewCell
        
        cell.button.addTarget(self, action: #selector(loginUser(_:)), for: .touchUpInside)
        cell.button.titleLabel?.font = UIFont(name: "Quicksand-Bold", size: 20)
        cell.button.backgroundColor = UIColor.colorWithHexString("EE5F66")
        cell.button.setTitle("Entrar", for: UIControlState())
        
        
        return cell
    }

    
    //MARK: Para tratar eventos do teclado
    
    func configureGestureRecognizer(){
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        panGesture.delegate = self
        tableView.addGestureRecognizer(panGesture)
    }
    
    
    func didPan(_ gesture : UIGestureRecognizer) {
        tableView.endEditing(true)
      
    }
    
    func keyboardDidShow(_ notification: NSNotification){
        if let object = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue{
            let frame = object.cgRectValue
            bottomTableConstraint.constant = frame.height
            tableView.layoutIfNeeded()
         //   adjustTextFieldCell()
        }
    }
    
    func keyboardWillHide(_ notification: NSNotification){
        self.bottomTableConstraint.constant = 0
        
    }
    
    func adjustTextFieldCell(){
        if let unwrappedLastCell = lastEditingCell{
            if let index = tableView.indexPath(for: unwrappedLastCell){
                let cellRect = tableView.rectForRow(at: index)
                if !tableView.bounds.contains(cellRect){
                    UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                        self.tableView.scrollToRow(at: index, at: .bottom, animated: false)
                        }, completion: nil)
                }
            }
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    

    @IBAction func popoverView(_ sender: AnyObject) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    func recoverPassword (_ sender: UIButton) {
        
        
    }
    
    func verifyInformations() -> String? {
        
        var msgErro: String?
        
        if self.dictionaryTextFields[KEY_EMAIL] == nil || self.dictionaryTextFields[KEY_EMAIL] == "" {
            
            msgErro = "Email inválido"
            
            return msgErro
        }
        
        if self.dictionaryTextFields[KEY_PASS] == nil || self.dictionaryTextFields[KEY_PASS] == "" {
            
            msgErro = "Senha inválida"
            
            return msgErro
        }
        
        return msgErro
        
    }
        
    func saveCurrentSessionInTimeInterval (user: User) {
    
        user.lastSessionTimeInterval = NSDate().timeIntervalSince1970
        ApplicationState.sharedInstance.currentUser = user
        DBManager.addObjc(user)
        
    }
    
    func loginUser (_ sender: UIButton) {
        
        if let msgError = self.verifyInformations() {
            
             self.present(ViewUtil.alertControllerWithTitle(_title: "Erro", _withMessage: msgError), animated: true, completion: nil)
            
            return
        }
        
        UserRequest.loginUser(email: dictionaryTextFields[KEY_EMAIL]!, pass: dictionaryTextFields[KEY_PASS]!) { (success, msg, user) in
            
            if success {
                
                self.saveCurrentSessionInTimeInterval(user: user!)
                
                self.present(ViewUtil.viewControllerFromStoryboardWithIdentifier("Main")!, animated: true, completion: nil)
                
                print ("MSG SUCESSO: \(msg)")
            } else {
                
                self.present(ViewUtil.alertControllerWithTitle(_title: "Erro", _withMessage: msg), animated: true, completion: nil)
                
            }
        }
    }
}

extension LoginViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
        case 0:
            return generateLogoImageCell(tableView, indexPath: indexPath)
        case 1:
            return generateEmailTextFieldCell(tableView, indexPath: indexPath)
        case 2:
            return generatePasswordTextFieldCell(tableView, indexPath: indexPath)
        case 3:
            return generateForgotPassButtonCell(tableView, indexPath: indexPath)
        case 4:
            return generateLoginButtonCell(tableView, indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
}

extension LoginViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        switch (indexPath as NSIndexPath).row {
            
        case 0:
            return 240
        case 1, 2:
            return 70
        case 3, 4:
            return 75
        default:
            return 0
        }
    }
    
}

extension LoginViewController : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

//extension LoginViewController : TextInputWithLabelTableViewCellDelegate {
//    
//    func userDidBeginEdit(cell: TextFieldTableViewCell) {
//        lastEditingCell = cell
//    }
//    
//    func textFieldReturn(cell: TextFieldTableViewCell, text: String?) {
//        
//    }
//    
//    func textCellAtIndexBecomeFirstResponder(indexPath index: IndexPath){
//    }
//    
//    func textDidChange(cell: TextFieldTableViewCell, text: String?) {
//        fillModelWith(cell: cell, text: text)
//        lastEditingCell = nil
//        
//    }
//    
//    func userDidEndEdit(cell: TextFieldTableViewCell, text: String?) {
//        fillModelWith(cell: cell, text: text)
//        lastEditingCell = nil
//        
//    }
//    
//    private func fillModelWith(cell: TextFieldTableViewCell, text: String?){
//        //        switch TagTextField.fromTag(tag: cell.txtFieldInput.tag) {
//        //        case .username:
//        //            viewModel.username = text ?? ""
//        //            break
//        //        case .password:
//        //            viewModel.password = text ?? ""
//        //            break
//        //        default:
//        //            break
//        //        }
//    }
//}
//
//
//
