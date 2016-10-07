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
//        
//        ReadingRequest.getAllReadings(completionHandler: completionBlock)
//        waitForExpectations(timeout: 10.0) { (error) in
//            XCTAssertNotNil(readings)
//            
//            let inteiro = 0x1f601
//            print ("INT: \(inteiro.description)")
//            let inteiro2 = 128513
//            
//            print ("INT 2: \(inteiro2.description)")
//
//        }
    }
    
    func testParseQueryParams() {
        
        let urlParams = [
            "limit":"0",
            "skip":"0",
            "$where":"this._id != '57f2e00aa993e78e70babcb5'",
            ]
        
        let queryParam = urlParams.stringFromHttpParameters()
        
        XCTAssertEqual(queryParam, "skip=0&%24where=this._id%20%21%3D%20%2757f2e00aa993e78e70babcb5%27&limit=0")
        
        
    }
    
    func testParseIdsInQueryWhereParam() {
        
        "this._id != '57f2e00aa993e78e70babcb5' || "
        
        let reading = Reading()
        let readingIds = reading.getAllSelectIdProperty(propertyName: "id")
        
        let idIncluded = false
        
        let allIdQuerys = readingIds.map { (readingId) -> String in
            
            var queryWhereString = "this._id "
            let comparator = idIncluded ? "== " : "!= "
            let idString = "'\(readingId as! String)'"
            queryWhereString += comparator + idString
            
            return queryWhereString
        
            
        }.joined(separator: " || ")
        
        
        XCTAssertTrue(allIdQuerys.contains(" || "), "erro")
        

        
        
        
        
    }
    
    func testGetReadingIds() {
        
       let reading = Reading()
       let readingIds = reading.getAllSelectIdProperty(propertyName: "id")
        
        XCTAssertNotNil(readingIds)
    
    }
    


}
