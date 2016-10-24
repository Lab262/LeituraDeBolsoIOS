//
//  UserRequest.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 23/09/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit
import Alamofire


let URL_WS_CREATE_USER = "\(URL_WS_SERVER)users"
let URL_WS_LOGIN_USER = "\(URL_WS_SERVER)auth/login"
let URL_WS_FORGOT_PASS = "\(URL_WS_SERVER)auth/forgotPassword"
let URL_WS_LOGIN_FACEBOOK = "\(URL_WS_SERVER)auth/facebook"


class UserRequest: NSObject {
    
    
    static func createAccountUser (user: User, pass: String, completionHandler: @escaping (_ success: Bool, _ msg: String) -> Void) {
        
        var dic = user.getAsDictionaryForWS()
        dic ["password"] = pass
        
        let body = [
            "data": [
                "attributes": dic
            ]
        ]
        
        Alamofire.request(URL_WS_CREATE_USER, method: .post, parameters: body, encoding: JSONEncoding.default).responseJSON { (response: DataResponse<Any>) in
            
        
            switch response.result {
                
            case .success:
                
                let data = response.result.value as! Dictionary<String, AnyObject>
                
                switch response.response!.statusCode {
                    
                case 200:
                    
                    user.token = data["token"] as? String
                    
                    let userData = data["user"]?["data"] as? Dictionary<String, AnyObject>
                   
                    let attributes = userData?["attributes"] as? Dictionary<String, AnyObject>
                  
                    user.id = attributes?["-id"] as? String
               
                    completionHandler(true, "Um email de confirmação foi enviado para o email cadastrado. ")
                    
                default:
                    
                    var errorMessage: ErrorMessage?
                    
                    if let errors = data["errors"] as? Array<Dictionary<String, AnyObject>> {
                        for error in errors {
                            errorMessage = ErrorMessage(data: error)
                        }
                        
                        completionHandler(false, errorMessage!.detail!)
                    }
                }
                
            case .failure(_):
                
                completionHandler(false, "NETWORK ERROR  \(response.result.error)")
 
            }
             
        }
        
    }
    
    static func loginUserWithFacebook (id: String, email: String,completionHandler: @escaping (_ sucess: Bool, _ msg: String, _ user: User?) -> Void) {
        
        let body = [
        "email": email,
            "facebook": [
                "id": id,
                "password": "AQWgd$j[QGe]Bh.Ugkf>?B3y696?2$#B2xwfN3hrVhFrE348g\(id)"
            ]
        ] as [String : Any]
        
        Alamofire.request(URL_WS_LOGIN_FACEBOOK, method: .post, parameters:body, encoding: JSONEncoding.default).responseJSON { (response: DataResponse<Any>) in
            
            switch response.result {
                
            case .success:
                
                let data = response.result.value as! Dictionary<String, AnyObject>
                
                switch response.response!.statusCode {
                    
                    
                case 200:
                    
                    let userData = data ["user"]
                    let user: User = User(data: userData as! Dictionary<String, AnyObject>)
                    
                    user.token = data ["token"] as? String
                    
                    completionHandler(true, "Sucesso", user)
                    
                default:
                    
                    var errorMessage: ErrorMessage?
                    
                    if let errors = data["errors"] as? Array<Dictionary<String, AnyObject>> {
                        
                        for error in errors {
                            errorMessage = ErrorMessage(data: error)
                        }
                        
                        completionHandler(false, errorMessage!.detail!, nil)
                    }
                }
                
                
            case .failure(_):
                
                completionHandler(false, "Network erro", nil)
                
            }
        }
    }
    
    static func loginUser (email: String, pass: String, completionHandler: @escaping (_ sucess: Bool, _ msg: String, _ user: User?) -> Void) {
        
        var dic = Dictionary<String, String>()
        
        dic["email"] = email
        dic["password"] = pass
        
        Alamofire.request(URL_WS_LOGIN_USER, method: .post, parameters: dic, encoding: JSONEncoding.default).responseJSON { (response: DataResponse<Any>) in
            
            switch response.result {
                
            case .success:
                
                let data = response.result.value as! Dictionary<String, AnyObject>
                
                switch response.response!.statusCode {
                    
   
                case 200:
                    
                    let userData = data ["user"]
                    
                    let user: User = User(data: userData as! Dictionary<String, AnyObject>)
            
                    user.token = data ["token"] as? String
                    
                    completionHandler(true, "Sucesso", user)
                
                default:
                    
                    var errorMessage: ErrorMessage?
                    
                    if let errors = data["errors"] as? Array<Dictionary<String, AnyObject>> {
                        
                        for error in errors {
                            errorMessage = ErrorMessage(data: error)
                        }
                        
                        completionHandler(false, errorMessage!.detail!, nil)
                    }
                }
            
            case .failure(_):

                completionHandler(false, "Network erro", nil)
                
            }
        }
    }
    
    static func forgotPass (email: String, completionHandler: @escaping (_ sucess: Bool, _ msg: String) -> Void) {
        
        var dic = Dictionary<String, String>()
        
        dic["email"] = email
    
        
        Alamofire.request(URL_WS_FORGOT_PASS, method: .post, parameters: dic, encoding: JSONEncoding.default, headers: nil).responseJSON { (response: DataResponse<Any>) in
            
            switch response.result {
                
            case .success:
                
                let data = response.result.value as! Dictionary<String, AnyObject>
                
                switch response.response!.statusCode {
                    
                case 200:
                
                    completionHandler(true, data["message"] as! String)
                    
                case 422:
                    
                    completionHandler(false, data["message"] as! String)
                
                default:
                    
                    var errorMessage: ErrorMessage?
                    
                    if let errors = data["errors"] as? Array<Dictionary<String, AnyObject>> {
                        
                        for error in errors {
                            errorMessage = ErrorMessage(data: error)
                        }
                        
                        completionHandler(false, errorMessage!.detail!)
                    }

                }
                
            case .failure(_):
            
                completionHandler(false, "Network erro")
            }
            
        }
    }

    
    

}
