//
//  CreateAccountViewController.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 09/09/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {
    
    var dictionaryTextFields = Dictionary <String, String>()
    
    @IBOutlet weak var bottomTableConstraint: NSLayoutConstraint!
    
    var lastEditingCell: TextFieldTableViewCell?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: "ImageLogoTableViewCell", bundle: nil), forCellReuseIdentifier: ImageLogoTableViewCell.identifier)
        
        self.tableView.register(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: TextFieldTableViewCell.identifier)
        
        self.tableView.register(UINib(nibName: "ButtonTableViewCell", bundle: nil), forCellReuseIdentifier: ButtonTableViewCell.identifier)
        
        self.configureGestureRecognizer()
       
        self.registerObservers()
        
    }
    
    private func registerObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @IBAction func popoverView(_ sender: AnyObject) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    func createAccount (_ sender: UIButton) {
        let user = User()
        user.email = self.dictionaryTextFields[KEY_EMAIL]!
        
        
        UserRequest.createAccountUser(user: user, pass: self.dictionaryTextFields[KEY_PASS]!) { (success, msg) in
            
            if success {
                
                print ("MENSAGEM DE SUCESSO: \(msg)")
                
            } else {
                
                self.present(ViewUtil.alertControllerWithTitle(_title: "Erro", _withMessage: msg), animated: true, completion: nil)
               
            }
            
        }
        
        
    }

    func generateLogoImageCell (_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageLogoTableViewCell.identifier, for: indexPath) as! ImageLogoTableViewCell
        
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
    
    func generateConfirmPasswordTextFieldCell (_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as! TextFieldTableViewCell
        
        
        cell.iconHeightConstraint.constant = 31
        cell.iconWidthConstraint.constant = 23
        cell.textField.isSecureTextEntry = true
        cell.iconImage.image = UIImage(named: "icon_pass")
        cell.textField.placeholder = "Confirmar Senha"
        
        cell.completionText = {(text) -> Void in
            self.dictionaryTextFields[KEY_CONFIRM_ASS] = text
        }


        
        
        return cell
    }
    
    func generateButtonCell (_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.identifier, for: indexPath) as! ButtonTableViewCell
        
        cell.button.addTarget(self, action: #selector(createAccount(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func setupKeyBoardDismiss(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,object: nil)
        self.configureGestureRecognizer()
    }
    
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

    
}

extension CreateAccountViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (indexPath as NSIndexPath).row {
            
        case 0:
            return generateLogoImageCell(tableView, indexPath: indexPath)
        case 1:
            return generateEmailTextFieldCell(tableView, indexPath: indexPath)
        case 2:
            return generatePasswordTextFieldCell(tableView, indexPath: indexPath)
        case 3:
            return generateConfirmPasswordTextFieldCell(tableView, indexPath: indexPath)
        case 4:
            return generateButtonCell(tableView, indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
}

extension CreateAccountViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        switch (indexPath as NSIndexPath).row {
            
        case 0:
            return 230
        case 1, 2, 3:
            return 70
        case 4:
            return 75
        default:
            return 0
        }
    }
    
}

extension CreateAccountViewController : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}




