//
//  DBManagerTest.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 28/09/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import XCTest

@testable import LeituraDeBolso

class DBManagerTest: XCTestCase {
    

    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    func testAddObject() {
        let reading = Reading()
        reading.id = "1238"
        reading.title = "Titulo3 "
        reading.content = "Contéudo 24"
        reading.duration = "12"
        DBManager.addObjc(reading)
        
        let reading2 = Reading()
        reading2.id = "12"
        reading2.title = "Titulo"
        reading2.content = "Contéudo 12"
        reading2.duration = "10"
        DBManager.addObjc(reading2)
        
        let reading3 = Reading()
        reading3.id = "01223"
        reading3.title = "Titulo title"
        reading3.content = "Contéudo 9"
        reading3.duration = "14"
        DBManager.addObjc(reading3)
    
    }
    
    func testGetAll() {
        let readings: [Reading] = DBManager.getAll()
        XCTAssertNotNil(readings.first?.title)
        XCTAssertNotNil(readings.first?.content)

    }
    
    func testGetByCondition() {
        let reading: Reading = DBManager.getByCondition(param: "title", value: "Titulo")
        XCTAssertNotNil(reading)
    }
    

}
