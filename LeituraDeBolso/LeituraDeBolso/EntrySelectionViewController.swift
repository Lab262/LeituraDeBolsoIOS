//
//  EntrySelectionViewController.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 09/09/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class EntrySelectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBAction func loginWithFacebook(_ sender: AnyObject) {
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            if error == nil {
                self.view.loadAnimation()
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                
                if (result?.isCancelled)! {
                    self.view.unload()
                    return
                }
                
                if(fbloginresult.grantedPermissions.contains("email")) {
                    
                    self.returnUserData()
                    
                }
            } else {
                
            }

        }
    }

    
    func returnUserData(){
        
        if((FBSDKAccessToken.current()) != nil){
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                
                if (error == nil) {
                    
                    print(result)
                    
                    let data:[String:AnyObject] = result as! [String : AnyObject]
           
                    UserRequest.loginUserWithFacebook(id: data["id"] as! String, email: data["email"] as! String, completionHandler: { (success, msg, user) in
                        
                        if success {
                            self.view.unload()
                            
                            
                            if !self.verifyUserExistInDataBase(user: user!) {
                                DBManager.deleteAllDatas()
                            }
                            
                            self.saveCurrentUser(user: user!)
                            
                            self.getReadings(readingsIds: self.getReadingsIdUser(user: user!), user: user!)
                            
                        } else {
                            
                            self.view.unload()
                            self.present(ViewUtil.alertControllerWithTitle(_title: "Erro", _withMessage: msg), animated: true, completion: nil)
                        }
                    })
                    
                }
            })
        }
    }
}

//MARK: - Requests

extension EntrySelectionViewController {
    
    
    func getReadingsIdUser (user: User) -> [String] {
        
        let allReadingsIdUser = user.getAllUserReadingIdProperty(propertyName: "idReading")
            
        let allReadings: [UserReading] = DBManager.getAll()
            
        let allReadingsDataBaseId = allReadings.map { (object) -> Any in
                
            return object.value(forKey: "idReading")
        }
            
        let answer = zip(allReadingsIdUser as! [String], allReadingsDataBaseId as! [String]).filter() {
                $0 != $1
            }.map{$0.0}
            
        return answer
            
    }
    
    
    func getReadings (readingsIds: [String], user: User) {
        
        if readingsIds.count > 0 {

            ReadingRequest.getAllReadings(readingsAmount: user.userReadings.count, readingsIds: readingsIds, isReadingIdsToDownload: true) { (success, msg, readings) in
            
                if success {
                    
                    
                    if readings!.count > 0 {
                    
                        for reading in readings! {
                        
                            DBManager.addObjc(reading)
                        }
                        self.view.unload()
                        self.present(ViewUtil.viewControllerFromStoryboardWithIdentifier("Main")!, animated:    true, completion: nil)
                    } else {
                        self.view.unload()
                        self.present(ViewUtil.viewControllerFromStoryboardWithIdentifier("Main")!, animated: true, completion: nil)
                    }
                
                } else {
                
                print ("MSG ERROR: \(msg)")
                
                }
            }
        } else {
            self.view.unload()
            self.present(ViewUtil.viewControllerFromStoryboardWithIdentifier("Main")!, animated: true, completion: nil)
        }
    }
}

