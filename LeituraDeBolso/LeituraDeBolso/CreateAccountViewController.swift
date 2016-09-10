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
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerNib(UINib(nibName: "ImageLogoTableViewCell", bundle: nil), forCellReuseIdentifier: ImageLogoTableViewCell.identifier)
        
        self.tableView.registerNib(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: TextFieldTableViewCell.identifier)
        
        self.tableView.registerNib(UINib(nibName: "ButtonTableViewCell", bundle: nil), forCellReuseIdentifier: ButtonTableViewCell.identifier)
        
    }
    
    @IBAction func popoverView(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    
    func createAccount (sender: UIButton) {
        
        
        
        
    }

    func generateLogoImageCell (tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(ImageLogoTableViewCell.identifier, forIndexPath: indexPath) as! ImageLogoTableViewCell
        
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
    
    func generateConfirmPasswordTextFieldCell (tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(TextFieldTableViewCell.identifier, forIndexPath: indexPath) as! TextFieldTableViewCell
        
        
        cell.iconHeightConstraint.constant = 31
        cell.iconWidthConstraint.constant = 23
        
        cell.iconImage.image = UIImage(named: "icon_pass")
        cell.textField.placeholder = "Confirmar Senha"
        
        cell.completionText = {(text) -> Void in
            self.dictionaryTextFields[KEY_CONFIRM_ASS] = text
        }

        return cell
    }
    
    func generateButtonCell (tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(ButtonTableViewCell.identifier, forIndexPath: indexPath) as! ButtonTableViewCell
        
        cell.button.addTarget(self, action: #selector(createAccount(_:)), forControlEvents: .TouchUpInside)
        
        return cell
    }
    
}

extension CreateAccountViewController: UITableViewDataSource {
    
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
            return generateConfirmPasswordTextFieldCell(tableView, indexPath: indexPath)
        case 4:
            return generateButtonCell(tableView, indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
}

extension CreateAccountViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        
        switch indexPath.row {
            
        case 0:
            return 205
        case 1, 2, 3:
            return 70
        case 4:
            return 75
        default:
            return 0
        }
    }
    
}
