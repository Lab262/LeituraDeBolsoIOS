//
//  ReadingRequestTests.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 26/09/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import XCTest

@testable import LeituraDeBolso

class ReadingRequestTests: XCTestCase {
    
    func testGetAllReadings() {
        
        let asyncExpectation = expectation(description: "User post request return")
        
        var readings: [Reading]?
        
        let completionBlock = { (success: Bool, message: String, allReadings: [Reading]) -> Void  in
            readings = allReadings
            asyncExpectation.fulfill()
        }
        
        ReadingRequest.getAllReadings(completionHandler: completionBlock)
        waitForExpectations(timeout: 10.0) { (error) in
            XCTAssertNotNil(readings)
            
            let inteiro = 0x1f601
            print ("INT: \(inteiro.description)")
            let inteiro2 = 128513
            
            print ("INT 2: \(inteiro2.description)")

        }
    }
}
