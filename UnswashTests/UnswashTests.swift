//
//  UnswashTests.swift
//  UnswashTests
//
//  Created by Alexandre Barbier on 20/11/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//

import XCTest

@testable import Unswash

class UnswashTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        Unswash.client.configure(clientId: "7189bfa9903c05772dd3bcb58e660f24c0f46e12b828d1807a3c6a3ccea15ce8", clientName: "UswashTest")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let expect = expectation(description:"")
        Unswash.Photos.get(page: 1, per_page: 20, order_by: .latest, completion: { (photos, errors) in
            XCTAssert(photos.count == 20)
            expect.fulfill()
        })
        waitForExpectations(timeout:5.0) { (error) in
            if error != nil {
                XCTFail(error!.localizedDescription)
            }
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
