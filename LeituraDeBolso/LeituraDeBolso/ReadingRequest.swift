//
//  ReadingRequest.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 26/09/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift
import Realm


let URL_WS_GET_ALL_READINGS = "\(URL_WS_SERVER)readings"
let URL_WS_GET_DAY = "\(URL_WS_SERVER)"
let URL_WS_GET_READING_BY_ID = "\(URL_WS_SERVER)auth/login"

var TOKEN_READING = ["x-access-token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6Imh1YWxseWQuc21hZGlAZ21haWwuY29tIiwiaWQiOiI1N2U5OWJhMWYyYjRmNjAzMDA3ZjU2NTciLCJpYXQiOjE0NzU4NzQ5MDZ9.Ny1WlCtuOkBsO9E3cddGZmjERJg_fxvWDFsB-_g5XSU"]


class ReadingRequest: NSObject {
    
    
    
    static func getReadingsOfTheDay (readingsAmount: Int, completionHandler: @escaping (_ success: Bool, _ msg: String, _ reading: [Reading]?) -> Void) {
        
        var allReadings = [Reading]()
        
        let urlParams = [
            "skip":"0",
            "limit":String(readingsAmount)]
        
        
      
        let url = URL_WS_GET_DAY + "users/" + ApplicationState.sharedInstance.currentUser!.id! + "/readingsOfTheDay/" + "?" + urlParams.stringFromHttpParameters()
        
        print (" URL DOWNLOAD: \(url)")
        
        var token = Dictionary<String, String>()
        
        token ["x-access-token"] = ApplicationState.sharedInstance.currentUser!.token
        
        Alamofire.request(url, method: .get, headers: token).responseJSON { (response: DataResponse<Any>) in
            
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
                        
                        completionHandler(true, "Sucesso", allReadings)
                        
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
    
    static func getAllReadings (readingsAmount: Int, readingsIds: [String], isReadingIdsToDownload: Bool, completionHandler: @escaping (_ success: Bool, _ msg: String, _ reading: [Reading]?) -> Void) {
        
        var allReadings = [Reading]()

        var urlParams = [
            "page":"0",
            "limit":String(readingsAmount)]

        if readingsIds.count > 0 {
            urlParams["$where"] = self.parseIdsInQueryWhereParam(readingIds: readingsIds, isReadingIdsToDownload: isReadingIdsToDownload)

        }
        
        let url = URL_WS_GET_ALL_READINGS + "?" + urlParams.stringFromHttpParameters()
        
        print ("IS READING IDS TO DOWNLOAD: \(isReadingIdsToDownload)")
        
        print (" URL DOWNLOAD: \(url)")
        
        var token = Dictionary<String, String>()
        
        token ["x-access-token"] = ApplicationState.sharedInstance.currentUser!.token
    
        Alamofire.request(url, method: .get, headers: token).responseJSON { (response: DataResponse<Any>) in
            
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
                        
                        completionHandler(true, "Sucesso", allReadings)
                      
                    } else {
                        
                        completionHandler(false, data["message"] as! String, nil)
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
                
                break
                
            }
            
        }
    }
    
    static func parseIdsInQueryWhereParam(readingIds: [String], isReadingIdsToDownload: Bool) -> String {
        
        var separator: String!

        
        if isReadingIdsToDownload {
            separator = " || "
        } else {
            separator = " && "
        }
        
        let allIdQuerys = readingIds.map { (readingId) -> String in
            var queryWhereString = "this._id "
            let comparator = isReadingIdsToDownload ? "== " : "!= "
            
            let idString = "'\(readingId )'"
            queryWhereString += comparator + idString
            
            return queryWhereString
            
        }.joined(separator: separator)
        
        return allIdQuerys
        
    }

}
