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
    
    func testCreateUserAccount() {
        
        
        var msg: String?
        
        let asyncExpectation = expectation(description: "User post request return")
        
        let completionBlock = { (success: Bool, message: String) -> Void  in
            msg = message
            asyncExpectation.fulfill()
        }
        
        let user = User()
        
        user.email = "huallyd.smadi@gmail.com"
        
        UserRequest.createAccountUser(user: user, pass: "123456", completionHandler: completionBlock)
        
        waitForExpectations(timeout: 10.0) { (error) in
             XCTAssert(msg == "Please confirm your email id by clicking on link in your email:huallyd.smadi@gmail.com" || msg == "This email is already in use")
        }
    }
    
    func testLoginUser() {
        
        let asyncExpectation = expectation(description: "User post request return")
        
        var msg: String?
        
        let completionBlock = { (success: Bool, message: String) -> Void  in
            
            msg = message
            
            asyncExpectation.fulfill()
        }
    
        UserRequest.loginUser(email: "huallyd.smadi@gmail.com", pass: "123456", completionHandler: completionBlock)
        
        waitForExpectations(timeout: 10.0) { (error) in
            XCTAssertNotNil(ApplicationState.sharedInstance.currentUser?.token)
            XCTAssertNotNil(ApplicationState.sharedInstance.currentUser?.email)
            
            
        }
        
    }
    
    func testForgotPass() {
        
        var msg: String?
        let asyncExpectation = expectation(description: "User post request return")
        
        let completionBlock = { (success: Bool, message: String) -> Void  in
            
            msg = message
            
            asyncExpectation.fulfill()
        }
        
        UserRequest.forgotPass(email: "huallyd@gmail.com", completionHandler: completionBlock)
        
        waitForExpectations(timeout: 10.0) { (error) in
            XCTAssertEqual(msg, "password is send to your registered email id: huallyd@gmail.com")
            
            XCTAssertNotNil(msg)
            
            
        }
        
    }


    
}
