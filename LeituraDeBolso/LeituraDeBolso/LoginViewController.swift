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
    

    override func viewWillAppear(animated: Bool) {
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerNibs()
        
    }
    
    func registerNibs () {
        
        self.tableView.registerNib(UINib(nibName: "ImageLogoTableViewCell", bundle: nil), forCellReuseIdentifier: ImageLogoTableViewCell.identifier)
        
        self.tableView.registerNib(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: TextFieldTableViewCell.identifier)
        
        self.tableView.registerNib(UINib(nibName: "ButtonTableViewCell", bundle: nil), forCellReuseIdentifier: ButtonTableViewCell.identifier)
        
    }
    
    func generateLogoImageCell (tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(ImageLogoTableViewCell.identifier, forIndexPath: indexPath) as! ImageLogoTableViewCell
        
        cell.titleLabel.text = "Log in"
        
        return cell
    }
    
    func generateEmailTextFieldCell (tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(TextFieldTableViewCell.identifier, forIndexPath: indexPath) as! TextFieldTableViewCell
        
        cell.iconImage.image = UIImage(named: "icon_email")
        cell.textField.placeholder = "Email"
        
        cell.completionText = {(text) -> Void in
            self.dictionaryTextFields[KEY_EMAIL] = text
        }

        
        return cell
    }
    
    func generatePasswordTextFieldCell (tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(TextFieldTableViewCell.identifier, forIndexPath: indexPath) as! TextFieldTableViewCell
        
        cell.iconHeightConstraint.constant = 31
        cell.iconWidthConstraint.constant = 23
        
        cell.iconImage.image = UIImage(named: "icon_pass")
        cell.textField.placeholder = "Senha"
        
        cell.completionText = {(text) -> Void in
            self.dictionaryTextFields[KEY_PASS] = text
        }
        
        
        return cell
    }
    
    func generateForgotPassButtonCell (tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(ButtonTableViewCell.identifier, forIndexPath: indexPath) as! ButtonTableViewCell
        
        
        cell.button.addTarget(self, action: #selector(recoverPassword(_:)), forControlEvents: .TouchUpInside)
        
        cell.button.titleLabel?.font = UIFont(name: "Comfortaa", size: 15)
        cell.button.setTitle("Esqueci a senha", forState: .Normal)
        cell.button.backgroundColor = UIColor.clearColor()
        
        
        return cell
    }
    
    func generateLoginButtonCell (tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(ButtonTableViewCell.identifier, forIndexPath: indexPath) as! ButtonTableViewCell
        
        cell.button.addTarget(self, action: #selector(loginUser(_:)), forControlEvents: .TouchUpInside)
        
        cell.button.setTitle("Entrar", forState: .Normal)
        
        
        return cell
    }

    


    @IBAction func popoverView(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func recoverPassword (sender: UIButton) {
        
        
    }
    
    func loginUser (sender: UIButton) {
        
    }

}

extension LoginViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        
        switch indexPath.row {
            
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
