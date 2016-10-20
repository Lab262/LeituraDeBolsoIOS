//
//  UserReadingRequest.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 27/09/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit
import Alamofire

let URL_WS_USER_READING = "\(URL_WS_SERVER)users/57f461e8c4e3f46697831a86/readings"

let URL_WS_USER_READING_UPDATE = "\(URL_WS_SERVER)users/57f461e8c4e3f46697831a86/readings/57ec1d762755e3667920b168"

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
        
        let url = "\(URL_WS_SERVER)users/\(ApplicationState.sharedInstance.currentUser!.id!)/readings"
        
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: token).responseJSON { (response: DataResponse<Any>) in
          
            switch response.result {
                
                case .success:
                
                    let data = response.result.value as! Dictionary<String, AnyObject>
                    
                    switch response.response!.statusCode {
                
                    case 201:

                        if let msg = data["msg"] as? String {
                            print ("MESSAGE: \(msg)")
                        }
                    
                        completionHandler(true, "SUCESSO READING DAY REQUEST")
                    
                    case 403:
                
                        completionHandler(false, "Usuario nao encontrado")
                    
                    default:
                        completionHandler(false, "Erro")
                    }
                
            case .failure(_):
                
                completionHandler(false, "NETWORK ERROR")
                
            }
        }
    }
    
    static func getAllUserReading (user: User, completionHandler: @escaping (_ success: Bool, _ msg: String, _ userReadings: [UserReading]?) -> Void) {
        
        var token = Dictionary<String, String>()
        
        token ["x-access-token"] = user.token
        
        let url = "\(URL_WS_SERVER)users/\(user.id!)/readings/"
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: token).responseJSON { (response: DataResponse<Any>) in
            
            switch response.result {
                
            case .success:
                
                let data = response.result.value as! Dictionary<String, AnyObject>
                
                switch response.response!.statusCode {
                    
                case 200:
                    
                    var userReadings = [UserReading]()
                    
                    if let listDictonary = data["data"] as? Array<Dictionary<String, AnyObject>> {
                        
                        for dic in listDictonary {
                            
                            let attributes = dic["attributes"] as? Dictionary<String, AnyObject>
                            
                            let userReading = UserReading(data: attributes!)
                            
                            userReadings.append(userReading)
                            
                        }
                        
                        completionHandler(true, "Sucesso", userReadings)
                        
                    }
                
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
                
                completionHandler(false, "NETWORK ERROR", nil)
                
            }
        }
    }
    
    static func updateUserReading (readingId: String, isFavorite: Bool?, alreadyRead: Bool?, completionHandler: @escaping (_ success: Bool, _ msg: String) -> Void) {
        
        
        var dic = Dictionary <String, AnyObject>()
        
        if isFavorite != nil {
            dic["is_favorite"] = isFavorite as AnyObject?
        }
        
        
        if alreadyRead != nil {
            dic["already_read"] = alreadyRead as AnyObject?
        }
        
        
        let body = [
            "data": [
                "attributes": dic
            ]
        ]
        
        let url = "\(URL_WS_SERVER)users/\(ApplicationState.sharedInstance.currentUser!.id!)/readings/\(readingId)"
        
        
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
