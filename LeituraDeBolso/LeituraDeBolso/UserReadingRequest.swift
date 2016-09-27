//
//  UserReadingRequest.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 27/09/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit
import Alamofire

class UserReadingRequest: NSObject {

    let URL_WS_CREATE_USER_READING = "\(URL_WS_SERVER)users"
    
    
//    static func createUserReading (readingId: String, completionHandler: @escaping (_ success: Bool, _ msg: String) -> Void) {
//        
//        var dic = user.getAsDictionaryForWS()
//        dic ["password"] = pass
//        
//        Alamofire.request(URL_WS_CREATE_USER, method: .post, parameters: dic).responseJSON { (response: DataResponse<Any>) in
//            
//            switch  response.result {
//                
//            case .success:
//                
//                switch response.response!.statusCode {
//                    
//                case 200:
//                    
//                    let data = response.result.value as! Dictionary<String, AnyObject>
//                    
//                    user.token = data["token"] as? String
//                    
//                    let userData = data["user"]?["data"] as? Dictionary<String, AnyObject>
//                    
//                    let attributes = userData?["attributes"] as? Dictionary<String, AnyObject>
//                    
//                    user.id = attributes?["-id"] as? String
//                    
//                    completionHandler(true, data["message"] as! String)
//                    
//                default:
//                    
//                    completionHandler(false, "erro")
//                }
//                
//            case .failure(_):
//                
//                completionHandler(false, "NETWORK ERROR")
//                
//            }
//            
//        }
//        
//    }
//
}
