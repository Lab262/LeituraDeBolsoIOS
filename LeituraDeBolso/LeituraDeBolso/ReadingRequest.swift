//
//  ReadingRequest.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 26/09/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit
import Alamofire


let URL_WS_GET_ALL_READINGS = "\(URL_WS_SERVER)readings"
let URL_WS_GET_READING_BY_ID = "\(URL_WS_SERVER)auth/login"

let TOKEN_READING = ["x-access-token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InRtYjA3MTBAZ21haWwuY29tIiwiaWQiOiI1N2U2YjRiNzVjMWVhNzk3MTk0OGQ5ZTYiLCJpYXQiOjE0NzQ3NTMwNjd9.QgGJDsKl8mfYApIqKIxp5GzSyQWBxegbQATAGXi_AZU"]


class ReadingRequest: NSObject {
    
    
    static func getAllReadings (completionHandler: @escaping (_ success: Bool, _ msg: String, _ reading: [Reading]) -> Void) {
        
        
        var allReadings = [Reading]()
       
      
        Alamofire.request(URL_WS_GET_ALL_READINGS, method: .get, headers: TOKEN_READING).responseJSON { (response: DataResponse<Any>) in
            
            
            switch  response.result {
                
            case .success:
                
                switch response.response!.statusCode {
                    
                case 200:
                    
                    let data = response.result.value as! Dictionary<String, AnyObject>
                   
                    if let listDictonary = data["data"] as? Array<Dictionary<String, AnyObject>> {
                        
                        for dic in listDictonary {
                            
                            let attributes = dic["attributes"] as? Dictionary<String, AnyObject>
                            
                            let reading = Reading(data: attributes!)
                            DBManager.addObjc(reading)
                            
                            allReadings.append(reading)
                            
                        }
                        
                        completionHandler(true, "Sucesso", allReadings)
                        
                    } else {
                        
                        completionHandler(false, "No Reads", allReadings)
                    }
       
                    
                default:
                    
                    completionHandler(false, "erro", allReadings)
                }
                
            case .failure(_):
                
                completionHandler(false, "NETWORK ERROR", allReadings)
                
                break
                
                
            }
            
        }
    }

}
