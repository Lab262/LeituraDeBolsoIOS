//
//  UserRequestTests.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 23/09/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import XCTest


@testable import LeituraDeBolso

class UserRequestTests: XCTestCase {
        

    func testCreateUserAccount () {
        
        let asyncExpectation = expectation(description: "User post request return")
        
        let completionBlock = { (success: Bool, message: String) -> Void  in
        
            
            asyncExpectation.fulfill()
        }
        
        let user = User(_email: "huallyd@gmail.com")
        
        UserRequest.createAccountUser(user: user, pass: "12345678",completionHandler: completionBlock)
        
        
        waitForExpectations(timeout: 10.0) { (error) in
            XCTAssertNotNil(user.token)
            XCTAssertNotNil(user.id)

        }
        
    }
    
}
