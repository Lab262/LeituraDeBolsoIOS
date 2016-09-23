//
//  UserRequest.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 23/09/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit
import Alamofire


class UserRequest: NSObject {
    
    
    static func createAccountUser (user: User, pass: String, completionHandler: @escaping (_ success: Bool, _ msg: String) -> Void) {
        
        var dic = user.getAsDictionaryForWS()
        dic ["password"] = pass
        
        Alamofire.request(URL_WS_SET_USER, method: .post, parameters: dic, headers: TOKEN).responseJSON { (response: DataResponse<Any>) in
            
            switch  response.result {
                
            case .success:
                
                switch response.response!.statusCode {
                    
                case 200:
                    
                    let data = response.result.value as! Dictionary<String, AnyObject>
                    
//                    user.id = data["_id"] as? String
                    user.token = data["token"] as? String
                    completionHandler(true, data["message"] as! String)
                    
                    
                default:
                    
                    completionHandler(false, "erro")
                }
                
            case .failure(_):
                
                completionHandler(false, "NETWORK ERRO")
                
                break
                
                
            }
            
        }
        
    }
    


}
