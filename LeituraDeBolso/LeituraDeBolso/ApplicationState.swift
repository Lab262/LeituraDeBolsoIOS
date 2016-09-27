//
//  ApplicationState.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 31/08/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit
import Alamofire


let URL_WS_SERVER = "https://leituradebolso.herokuapp.com/api/v0/"
let TOKEN = ["token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbW"]



class ApplicationState: NSObject {
    
    var modeNight: Bool? = false
    var sizeFontSelected: CGFloat? = 14
    
    var allReadings = [Reading]()
    var favoriteReads = [Reading]()
    var unreadReadings = [Reading]()
    var currentUser: User?
    
    static let sharedInstance : ApplicationState = {
        let instance = ApplicationState(singleton: true)
        
        return instance
    }()
    
    
    private init(singleton: Bool) {
        super.init()
        
    }
    
    
    
    
//    
//    Alamofire.request(.POST, URL_WS_SET_USER_REGISTER, parameters:dic).validate().responseJSON { response in debugPrint(response)
//    
//    switch response.result {
//    
//    
//    case .Success:
//    
//    let data = response.result.value as! Dictionary<String, AnyObject>
//    
//    if let ret = data["retorno"] {
//    
//    if let msg = data["msg"] {
//    print ("MSG \(msg)")
//    }
//    
//    if ret as? String == "true" {
//    
//    returnFunction(success: true, msg: data["msg"] as! String)
//    
//    } else {
//    
//    returnFunction(success: false, msg: data["msg"] as! String)
//    }
//    }
//    
//    case .Failure(_):
//    
//    returnFunction(success: false, msg: NETWORK_ERROR)
//    }
//    
//    }
//}





   }
