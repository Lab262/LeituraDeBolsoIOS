//
//  UserReadingTests.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 04/10/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import XCTest
@testable import LeituraDeBolso

class UserReadingTests: XCTestCase {
    
    
    func testCreateUserReading () {
 
        var msg: String?
        let asyncExpectation = expectation(description: "User post request return")
        
        let completionBlock = { (success: Bool, message: String) -> Void  in
            msg = message
            asyncExpectation.fulfill()
        }
        
        UserReadingRequest.createUserReading(readingId: "57ec1d762755e3667920b168", isFavorite: false, alreadyRead: false, completionHandler: completionBlock)
        
        
        waitForExpectations(timeout: 10.0) { (error) in
            
            XCTAssert(msg == "_readingId is already in use for this user" || msg == "user-reading successfully added")
    
        }
    }
    
    func testUpdateUserReading () {
        
        var msg: String?
        let asyncExpectation = expectation(description: "User post request return")
        
        let completionBlock = { (success: Bool, message: String) -> Void  in
            msg = message
            asyncExpectation.fulfill()
        }
        
        
        UserReadingRequest.updateUserReading(readingId: "57ec1d762755e3667920b168", isFavorite: true, alreadyRead: true, completionHandler: completionBlock)
        
        
        
        waitForExpectations(timeout: 10.0) { (error) in
            
            XCTAssert(msg == "user-reading successfully updated")
            
        }
    }
    

}
