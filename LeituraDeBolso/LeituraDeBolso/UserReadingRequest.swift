//
//  UserReadingRequest.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 27/09/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit
import Alamofire



let URL_WS_CREATE_USER_READING = "\(URL_WS_SERVER)users"

class UserReadingRequest: NSObject {
    
//    static func createUserReading (readingId: String, isFavorite: Bool, alreadyRead: Bool, completionHandler: @escaping (_ success: Bool, _ msg: String) -> Void) {
//        
//        var dic = Dictionary <String, AnyObject>()
//        dic["_readingId"] = readingId as AnyObject?
//        dic["alreadyRead"] = alreadyRead as AnyObject?
//        dic["isFavorite"] = isFavorite as AnyObject?
//    
//        
//        Alamofire.request(URL_WS_CREATE_USER_READING, method: .post, parameters: dic) { (response: DataResponse<Any>) in {
//            
//            
//            
//            }
////        Alamofire.request(URL_WS_CREATE_USER_READING, method: .post, parameters: dic, encoding: JSONEncoding.default) { (response: DataResponse<Any>) in {
////            
////            }
//
////        Alamofire.request(URL_WS_CREATE_USER_READING, method: .post, encoding: JSONEncoding.default, headers: TOKEN_READING).responseJSON { (response: DataResponse<Any>) in
//        
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
