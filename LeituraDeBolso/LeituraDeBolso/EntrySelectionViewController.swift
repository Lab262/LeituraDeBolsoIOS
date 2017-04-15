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
import Realm
import RealmSwift

class EntrySelectionViewController: UIViewController {
    
    @IBOutlet var titleLabels: [UILabel]!

    override func viewDidLoad() {
        super.viewDidLoad()
        setDynamicSizeFonts()
        configureNavigation()
    }
    
    func configureNavigation() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func setDynamicSizeFonts(){
        titleLabels.forEach {
            $0.setDynamicFont()
        }
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
                    
                    print(result as Any)
                    
                    let data:[String:AnyObject] = result as! [String : AnyObject]
           
                    UserRequest.loginUserWithFacebook(id: data["id"] as! String, email: data["email"] as! String, completionHandler: { (success, msg, user) in
                        
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
                        }                    })
                    
                }
            })
        }
    }
}

//MARK: - Requests

extension EntrySelectionViewController {
    func getReadingsIdUser (user: User) -> [String] {
        
        let allReadingsIdUser = user.getAllUserReadingIdProperty(propertyName: "idReading")
        let allReadings: [Reading] = DBManager.getAll()
        let allReadingsDataBaseId = allReadings.map { (object) -> Any in
            
            return object.value(forKey: "id")!
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

//    
//    func getReadings (readingsIds: [String], user: User) {
//        
//        if readingsIds.count > 0 {
//
//            ReadingRequest.getAllReadings(readingsAmount: user.userReadings.count, readingsIds: readingsIds, isReadingIdsToDownload: true) { (success, msg, readings) in
//            
//                if success {
//                    
//                    
//                    if readings!.count > 0 {
//                    
//                        for reading in readings! {
//                        
//                            DBManager.addObjc(reading)
//                        }
//                        self.view.unload()
//                        self.present(ViewUtil.viewControllerFromStoryboardWithIdentifier("Main")!, animated:    true, completion: nil)
//                    } else {
//                        self.view.unload()
//                        self.present(ViewUtil.viewControllerFromStoryboardWithIdentifier("Main")!, animated: true, completion: nil)
//                    }
//                
//                } else {
//                
//                print ("MSG ERROR: \(msg)")
//                
//                }
//            }
//        } else {
//            self.view.unload()
//            self.present(ViewUtil.viewControllerFromStoryboardWithIdentifier("Main")!, animated: true, completion: nil)
//        }
//    }
}

