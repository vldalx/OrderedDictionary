//
//  OrderedDictionaryTests.swift
//  OrderedDictionaryTests
//
//  Created by Vladimir Kushelkov on 14/05/2017.
//  Copyright © 2017 vldalx. All rights reserved.
//

import XCTest
@testable import OrderedDictionary

class OrderedDictionaryTests: XCTestCase {
    
    private var dict: OrderedDictionary<Int, String>!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        dict = OrderedDictionary<Int, String>()
        for i in 0...100
        {
            let n = i % 24
            dict[n] = "\(n)"
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        XCTAssertEqual(dict.count, 24, "the dictionary does not contain 24 elemens")
        XCTAssertEqual(dict[7], "7", "the dictionary returns wrong element")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
