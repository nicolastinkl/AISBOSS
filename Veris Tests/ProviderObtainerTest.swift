//
//  ProviderObtainerTest.swift
//  AIVeris
//
//  Created by admin on 15/9/25.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import XCTest

class ProviderObtainerTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        let p: ProviderDataObtainer!
        p = MockProviderDataObtainer()
       
      
        p.getOrders({ (responseData) -> Void in
            
            
            }) { (errType, errDes) -> Void in
                
        }
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
