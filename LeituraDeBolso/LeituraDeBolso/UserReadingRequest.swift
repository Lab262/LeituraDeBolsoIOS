//
//  UserReadingRequest.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 27/09/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit
import Alamofire

let URL_WS_USER_READING = "\(URL_WS_LOCAL)users/57f461e8c4e3f46697831a86/readings"

let URL_WS_USER_READING_UPDATE = "\(URL_WS_LOCAL)users/57f461e8c4e3f46697831a86/readings/57ec1d762755e3667920b168"

class UserReadingRequest: NSObject {
    
    static func createUserReading (readingId: String, isFavorite: Bool, alreadyRead: Bool, completionHandler: @escaping (_ success: Bool, _ msg: String) -> Void) {
        
        var dic = Dictionary <String, AnyObject>()
        dic["readingId"] = readingId as AnyObject
        dic["already_read"] = alreadyRead as AnyObject?
        dic["is_favorite"] = isFavorite as AnyObject?
        
        let body = [
            "data": [
                "attributes": dic
            ]
        ]
        
        var token = Dictionary<String, String>()
        
        token["x-access-token"] = ApplicationState.sharedInstance.currentUser!.token!
        
        let url = "\(URL_WS_LOCAL)users/\(ApplicationState.sharedInstance.currentUser!.id!)/readings"
        
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: token).responseJSON { (response: DataResponse<Any>) in
          
            switch response.result {
                
                case .success:
                
                    let data = response.result.value as! Dictionary<String, AnyObject>
                    
                    switch response.response!.statusCode {
                
                    case 201:

                        if let msg = data["msg"] as? String {
                            print ("MESSAGE: \(msg)")
                        }
                    
                        completionHandler(true, data["message"] as! String)
                    
                    case 403:
                
                    completionHandler(false, data["message"] as! String)
                    
                    default:
                        completionHandler(false, data["message"] as! String)
                    }
                
            case .failure(_):
                
                completionHandler(false, "NETWORK ERROR")
                
            }
        }
    }
    
    static func getAllUserReading (completionHandler: @escaping (_ success: Bool, _ msg: String, _ userReadings: [UserReading]?) -> Void) {
        
        var token = Dictionary<String, String>()
        
        token ["x-access-token"] = ApplicationState.sharedInstance.currentUser!.token
        
        let url = "\(URL_WS_LOCAL)users/\(ApplicationState.sharedInstance.currentUser!.id!)/readings/"
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: token).responseJSON { (response: DataResponse<Any>) in
            
            switch response.result {
                
            case .success:
                
                let dataResponse = response.result.value as! Dictionary<String, AnyObject>
                
                switch response.response!.statusCode {
                    
                case 200:
                    
                    var userReadings = [UserReading]()
                    
                    if let data = dataResponse ["data"] as? Dictionary<String, AnyObject> {
                        
                    
                    if let attributes = data["attributes"] as? Dictionary<String, AnyObject> {
                        
                        if let userReadingsData = attributes["readings"] as? Array<Dictionary<String, AnyObject>> {
                            
                            for userReading in userReadingsData {
                                let userReadingObject = UserReading(data: userReading)
                                userReadings.append(userReadingObject)
                            }
                        }
                        
                        completionHandler(true, "msg", userReadings)
                    } else {
                        
                        
                    }
                    }
       
                    
                default:
         
                    var errorMessage: ErrorMessage?
                    
                    if let errors = dataResponse["errors"] as? Array<Dictionary<String, AnyObject>> {
                        
                        for error in errors {
                            errorMessage = ErrorMessage(data: error)
                        }
                        
                        completionHandler(false, errorMessage!.detail!, nil)
                    }

                }
                
            case .failure(_):
                
                completionHandler(false, "NETWORK ERROR", nil)
                
            }
        }
    }
    
    static func updateUserReading (readingId: String, isFavorite: Bool?, alreadyRead: Bool?, completionHandler: @escaping (_ success: Bool, _ msg: String) -> Void) {
        
        
        var dic = Dictionary <String, AnyObject>()
        
        if isFavorite != nil {
            dic["is_favorite"] = isFavorite as AnyObject?
        }
        
        dic["readingId"] = readingId as AnyObject
        
        if alreadyRead != nil {
            dic["already_read"] = alreadyRead as AnyObject?
        }
        
        
        let body = [
            "data": [
                "attributes": dic
            ]
        ]
        
        let url = "\(URL_WS_LOCAL)users/\(ApplicationState.sharedInstance.currentUser!.id!)/readings/\(readingId)"
        
        
        var token = Dictionary<String, String>()
        token ["x-access-token"] = ApplicationState.sharedInstance.currentUser!.token
        
        Alamofire.request(url, method: .patch, parameters: body,encoding: JSONEncoding.default, headers: token).responseJSON { (response: DataResponse<Any>) in
            
            switch response.result {
            case .success:
                
                let data = response.result.value as! Dictionary<String, AnyObject>
                
                switch response.response!.statusCode {
                    
                case 200:
                    
                    if let msg = data["msg"] as? String {
                        print ("MESSAGE: \(msg)")
                    }
                    
                    completionHandler(true, "Update User Reading Sucesso")
                    
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
                
                completionHandler(false, "NETWORK ERROR")
                
            }
        }
    }

}
