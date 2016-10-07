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
    
    
    
    static func getAllReadings (readingsAmount: Int, readingsIds: [String], isReadingIdsToDownload: Bool, completionHandler: @escaping (_ success: Bool, _ msg: String, _ reading: [Reading]) -> Void) {
        
        var allReadings = [Reading]()

        let urlParams = [
            "skip":"0",
            "$where":self.parseIdsInQueryWhereParam(readingIds: readingsIds, isReadingIdsToDownload: isReadingIdsToDownload),
            "limit":String(readingsAmount)]

        let url = URL_WS_GET_ALL_READINGS + "?" + urlParams.stringFromHttpParameters()
    
        Alamofire.request(url, method: .get, headers: TOKEN_READING).responseJSON { (response: DataResponse<Any>) in
            
            switch  response.result {
                
            case .success:
                
                
                let data = response.result.value as! Dictionary<String, AnyObject>
                
                
                switch response.response!.statusCode {
                    
                case 200:
                   
                    if let listDictonary = data["data"] as? Array<Dictionary<String, AnyObject>> {
                        
                        for dic in listDictonary {
                            
                            let attributes = dic["attributes"] as? Dictionary<String, AnyObject>
                            
                            let reading = Reading(data: attributes!)
                            
                            allReadings.append(reading)
                            
                        }
                        
                        completionHandler(true,  data["message"] as! String, allReadings)
                        
                    } else {
                        
                        completionHandler(false, data["message"] as! String, allReadings)
                    }
       
                    
                default:
                    
                    completionHandler(false, data["message"] as! String, allReadings)
                }
                
            case .failure(_):
                
                completionHandler(false, "NETWORK ERROR", allReadings)
                
                break
                
            }
            
        }
    }
    
    static func parseIdsInQueryWhereParam(readingIds: [String], isReadingIdsToDownload: Bool) -> String {
        
        let allIdQuerys = readingIds.map { (readingId) -> String in
            
            var queryWhereString = "this._id "
            let comparator = isReadingIdsToDownload ? "!= " : "== "
            let idString = "'\(readingId )'"
            queryWhereString += comparator + idString
            
            return queryWhereString
            
        }.joined(separator: " || ")
        
        return allIdQuerys
        
    }

}
