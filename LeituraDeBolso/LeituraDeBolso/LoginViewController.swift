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
let KEY_CONFIRM_ASS = "confirmationPass"

class LoginViewController: UIViewController {
    
    var dictionaryTextFields = Dictionary <String, String>()
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerNibs()
        
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
        
        cell.completionText = {(text) -> Void in
            self.dictionaryTextFields[KEY_EMAIL] = text
        }

        
        return cell
    }
    
    func generatePasswordTextFieldCell (_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as! TextFieldTableViewCell
        
        cell.iconHeightConstraint.constant = 31
        cell.iconWidthConstraint.constant = 23
        
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
        
        cell.button.setTitle("Entrar", for: UIControlState())
        
        
        return cell
    }

    


    @IBAction func popoverView(_ sender: AnyObject) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    func recoverPassword (_ sender: UIButton) {
        
        
    }
    
    func loginUser (_ sender: UIButton) {
        
    }

}

extension LoginViewController: UITableViewDataSource {
    
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
            return generateForgotPassButtonCell (tableView, indexPath: indexPath)
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
            return 205
        case 1, 2:
            return 70
        case 3, 4:
            return 75
        default:
            return 0
        }
    }
    
}
