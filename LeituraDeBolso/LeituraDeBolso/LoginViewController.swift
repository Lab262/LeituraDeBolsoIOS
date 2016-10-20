//
//  LoginViewController.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 24/08/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

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

        cell.button.removeTarget(nil, action: nil, for: .allEvents)
        cell.button.addTarget(self, action: #selector(recoverPassword(_:)), for: .touchUpInside)
        
        cell.button.titleLabel?.font = UIFont(name: "Comfortaa", size: 15)
        
        cell.button.setTitle("Esqueci a senha", for: UIControlState())
        
        cell.button.backgroundColor = UIColor.clear
        
        
        
        return cell
    }
    
    func generateLoginButtonCell (_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.identifier, for: indexPath) as! ButtonTableViewCell
        
        cell.button.removeTarget(nil, action: nil, for: .allEvents)
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
        
        let alertController = UIAlertController(title: "Esqueci a Senha", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Enviar", style: .default, handler: {
            alert -> Void in
            
            if alertController.textFields![0].text! != "" {
                self.view.loadAnimation()
               
                
                UserRequest.forgotPass(email: alertController.textFields![0].text!, completionHandler: { (success, msg) in
                    
                    if success {
                        self.view.unload()
                        print ("DEU SUCESSO: \(msg)")
                        self.present(ViewUtil.alertControllerWithTitle(_title: "Sucesso!", _withMessage: msg), animated: true, completion: nil)
                        
                        
                    } else {
                        self.view.unload()
                        print ("DEU RUIM: \(msg)")
                        self.present(ViewUtil.alertControllerWithTitle(_title: "Erro", _withMessage: msg), animated: true, completion: nil)
                    }
                })
                
            }else {
                self.view.unload()
                self.present(ViewUtil.alertControllerWithTitle(_title: "Erro", _withMessage: "Email inválido."), animated: true, completion: nil)
                
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            
            textField.placeholder = "E-mail para recuperar conta."
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        
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
        
    func saveCurrentUser (user: User) {

        ApplicationState.sharedInstance.currentUser = user
        DBManager.update(ApplicationState.sharedInstance.currentUser!)
        
    }
    
    func verifyUserExistInDataBase (user: User) -> Bool {
        
        let user: User = DBManager.getByCondition(param: "email", value: user.email!)
            
        if user.email != nil {
            
            return true
        } else {
            return false
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

//MARK: - Requests

extension LoginViewController {
    
    func getReadingsIdUser (user: User) -> [String] {
        
        let allReadingsIdUser = user.getAllUserReadingIdProperty(propertyName: "idReading")
            
        let allReadings: [Reading] = DBManager.getAll()
            
        let allReadingsDataBaseId = allReadings.map { (object) -> Any in
                
            return object.value(forKey: "idReading")
        }
    
        let allReadingsId = allReadingsIdUser as! [String]
        let allDataBaseId = allReadingsDataBaseId as! [String]
        
        let answer = allReadingsId.filter{ item in !allDataBaseId.contains(item) }
        
            
            return answer
            
        }

    
    
    func getReadings (readingsIds: [String], user: User) {
        
        if readingsIds.count > 0 {
            
            ReadingRequest.getAllReadings(readingsAmount: user.userReadings.count, readingsIds: readingsIds, isReadingIdsToDownload: true) { (success, msg, readings) in
                
                if success {
                    self.view.unload()
                    if readings!.count > 0 {
                        
                        for reading in readings! {
                            DBManager.addObjc(reading)
                        }
                        
                        self.present(ViewUtil.viewControllerFromStoryboardWithIdentifier("Main")!, animated: true, completion: nil)
                        
                    } else {
                        self.view.unload()
                        self.present(ViewUtil.viewControllerFromStoryboardWithIdentifier("Main")!, animated: true, completion: nil)
                    }
                    
                } else {
                    
                    self.view.unload()
                    print ("MSG ERROR: \(msg)")
                    
                }
            }
        } else {
            
            self.present(ViewUtil.viewControllerFromStoryboardWithIdentifier("Main")!, animated: true, completion: nil)
        }
    }

    func loginUser (_ sender: UIButton) {
        
        if let msgError = self.verifyInformations() {
            
            self.present(ViewUtil.alertControllerWithTitle(_title: "Erro", _withMessage: msgError), animated: true, completion: nil)
            
            return
        }
        
        self.view.loadAnimation()
        
        UserRequest.loginUser(email: dictionaryTextFields[KEY_EMAIL]!, pass: dictionaryTextFields[KEY_PASS]!) { (success, msg, user) in
            
            if success {
                
                if !self.verifyUserExistInDataBase(user: user!) {
                    DBManager.deleteAllDatas()
                }
                
                UserReadingRequest.getAllUserReading(user: user!, completionHandler: { (success, msg, userReadings) in
                    
                    if success {
                        
                        if userReadings!.count > 0 {
                            
                            for userReading in userReadings! {
                                try! Realm().write {                                            user?.userReadings.append(userReading)
                                }
                            }
                        }
                    
                        self.saveCurrentUser(user: user!)
                        DBManager.addObjc(user!)
                        
                        self.getReadings(readingsIds: self.getReadingsIdUser(user: user!), user: user!)
                        
                        print ("MSG SUCESSO: \(msg)")
                    }
                })
            } else {
                self.view.unload()
                self.present(ViewUtil.alertControllerWithTitle(_title: "Erro", _withMessage: msg), animated: true, completion: nil)
            }
        }
    }
    
}
