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

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInsertUpdateValues() {
        var dict = OrderedDictionary<String, String>()
        
        func test(dict: OrderedDictionary<String, String>) {
            XCTAssertEqual(dict.count, 24, "the dictionary does not contain 24 elemens")
            
            for (index, element1) in dict.enumerated() {
                let element2 = dict[index]
                let element3 = dict[index]
                let areEqual = element2.key == element1.key && element2.value == element1.value && element3.key == element1.key && element3.value == element1.value
                XCTAssertTrue(areEqual, "the dictionary returns wrong element")
            }
        }
        
        for i in 0...100{
            let n = "\(i % 24)"
            dict[n] = n
        }
        
        test(dict: dict)

        for i in 0..<24{
            let n = "\(i)"
            dict.update((n, n), at: i)
        }
        
        test(dict: dict)
    }
    
    func testTwoDictionariesAreEqual() {
        var dict1 = OrderedDictionary<Int, String>()
        dict1[3] = "3"
        dict1[7] = "7"
        
        var dict2 = OrderedDictionary<Int, String>()
        dict2[3] = "3"
        dict2[7] = "7"
        
        XCTAssertTrue(dict1 == dict2, "dictionaries are not equal")
        
        dict1[7] = "77"
        
        XCTAssertFalse(dict1 == dict2, "dictionaries are equal")
        
        dict1[7] = "7"
        
        XCTAssertTrue(dict1 == dict2, "dictionaries are not equal")
        
        dict1[7] = "777"
        dict2[7] = "777"
        
        XCTAssertTrue(dict1 == dict2, "dictionaries are not equal")
        
        dict1[0] = "14"
        
        XCTAssertFalse(dict1 == dict2, "dictionaries are equal")
        
        dict2[0] = dict1[0]
        
        XCTAssertTrue(dict1 == dict2, "dictionaries are not equal")
        
        dict1.removeValue(forKey: 3)
        dict1.updateValue("3", forKey: 3)
        
        XCTAssertFalse(dict1 == dict2, "dictionaries are equal")
    }
    
    func testSort() {
        var dict = OrderedDictionary<Int, String>()
        dict[1] = "1"
        dict[2] = "2"
        dict[3] = "3"

        dict.sort(by: { $0.0.key > $0.1.key })

        XCTAssertEqual(dict.last!.key, 1)
        XCTAssertEqual(dict.last!.value, "1")
        XCTAssertEqual(dict.first!.key, 3)
        XCTAssertEqual(dict.first!.value, "3")
        
        dict = dict.sorted(by: { $0.0.key < $0.1.key })
        
        XCTAssertEqual(dict.last!.key, 3)
        XCTAssertEqual(dict.last!.value, "3")
        XCTAssertEqual(dict.first!.key, 1)
        XCTAssertEqual(dict.first!.value, "1")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
