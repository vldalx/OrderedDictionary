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

    // ======================================================= //
    // MARK: - Initialization
    // ======================================================= //
    
    func testInitializationUsingArrayLiteral() {
        let expected = OrderedDictionary<String, Int>([
            (key: "A", value: 1),
            (key: "B", value: 2),
            (key: "C", value: 3)
            ])
        let actual: OrderedDictionary<String, Int> = [("A", 1), ("B", 2), ("C", 3)]
        
        XCTAssertTrue(expected == actual)
    }
    
    func testInitializationUsingDictionaryLiteral() {
        let expected = OrderedDictionary<String, Int>([
            (key: "A", value: 1),
            (key: "B", value: 2),
            (key: "C", value: 3)
            ])
        let actual: OrderedDictionary<String, Int> = ["A": 1, "B": 2, "C": 3]
        
        XCTAssertTrue(expected == actual)
    }
    
    // ======================================================= //
    // MARK: - Content Access
    // ======================================================= //
    
    func testAccessingContent() {
        let orderedDictionary: OrderedDictionary<String, Int> = ["A": 1, "B": 2, "C": 3]
        
        XCTAssertEqual(orderedDictionary.count, 3)
        
        XCTAssertEqual(orderedDictionary["A"], 1)
        XCTAssertEqual(orderedDictionary.index(forKey: "A"), 0)
        XCTAssertTrue(orderedDictionary.contains(key: "A"))
        XCTAssertTrue(orderedDictionary[0] == ("A", 1))
        
        XCTAssertEqual(orderedDictionary["B"], 2)
        XCTAssertEqual(orderedDictionary.index(forKey: "B"), 1)
        XCTAssertTrue(orderedDictionary.contains(key: "B"))
        XCTAssertTrue(orderedDictionary[1] == ("B", 2))
        
        XCTAssertEqual(orderedDictionary["C"], 3)
        XCTAssertEqual(orderedDictionary.index(forKey: "C"), 2)
        XCTAssertTrue(orderedDictionary.contains(key: "C"))
        XCTAssertTrue(orderedDictionary[2] == ("C", 3))
    }
    
    func testIterator() {
        let orderedDictionary: OrderedDictionary<String, Int> = ["A": 1, "B": 2, "C": 3]
        var iterator = orderedDictionary.makeIterator()
        
        let indexes = [0, 1, 2]
        var indexesIterator = indexes.makeIterator()
        
        while let (actualKey, actualValue) = iterator.next() {
            let index = indexesIterator.next()
            let (expectedKey, expectedValue) = orderedDictionary[index!]
            
            XCTAssertEqual(expectedKey, actualKey)
            XCTAssertEqual(expectedValue, actualValue)
        }
        
        XCTAssertNil(iterator.next())
        XCTAssertNil(indexesIterator.next())
    }
    
    func testOrderedKeys() {
        let orderedDictionary: OrderedDictionary<String, Int> = ["A": 1, "B": 2, "C": 3]
        
        let expected = ["A", "B", "C"]
        let actual = Array(orderedDictionary.keys)
        
        XCTAssertEqual(expected, actual)
    }
    
    func testOrderedValues() {
        let orderedDictionary: OrderedDictionary<String, Int> = ["A": 1, "B": 2, "C": 3]
        
        let expected = [1, 2, 3]
        let actual = Array(orderedDictionary.values)
        
        XCTAssertEqual(expected, actual)
    }
    
    // ======================================================= //
    // MARK: - Key-based Modifications
    // ======================================================= //
    
    func testKeyBasedModifications() {
        var orderedDictionary: OrderedDictionary<String, Int> = ["A": 1, "B": 2, "C": 3]
        
        orderedDictionary["A"] = 5
        orderedDictionary["D"] = 10
        orderedDictionary["B"] = nil
        
        XCTAssertEqual(orderedDictionary.count, 3)
        
        XCTAssertEqual(orderedDictionary["A"], 5)
        XCTAssertEqual(orderedDictionary.index(forKey: "A"), 0)
        XCTAssertTrue(orderedDictionary.contains(key: "A"))
        
        XCTAssertNil(orderedDictionary["B"])
        XCTAssertNil(orderedDictionary.index(forKey: "B"))
        XCTAssertFalse(orderedDictionary.contains(key: "B"))
        
        XCTAssertEqual(orderedDictionary["C"], 3)
        XCTAssertEqual(orderedDictionary.index(forKey: "C"), 1)
        XCTAssertTrue(orderedDictionary.contains(key: "C"))
        
        XCTAssertEqual(orderedDictionary["D"], 10)
        XCTAssertEqual(orderedDictionary.index(forKey: "D"), 2)
        XCTAssertTrue(orderedDictionary.contains(key: "D"))
    }
    
    // ======================================================= //
    // MARK: - Index-based Insertions
    // ======================================================= //
    
    func testIndexBasedInsertionsWithUniqueKeys() {
        var orderedDictionary: OrderedDictionary<String, Int> = ["A": 1, "B": 2, "C": 3]
        orderedDictionary.insert((key: "T", value: 15), at: 0)
        orderedDictionary.insert((key: "U", value: 16), at: 2)
        orderedDictionary.insert((key: "V", value: 17), at: 5)
        orderedDictionary.insert((key: "W", value: 18), at: 2)
        
        let expected: OrderedDictionary<String, Int> = ["T": 15, "A": 1, "W": 18, "U": 16, "B": 2, "C": 3, "V": 17]
        let actual = orderedDictionary
        
        for i in 0..<orderedDictionary.count {
            XCTAssertTrue(orderedDictionary[i].key == expected[i].key)
            XCTAssertTrue(orderedDictionary[i].value == expected[i].value)
//            XCTAssertTrue(orderedDictionary[i] == expected[i].key)
        }
        
        XCTAssertTrue(expected == actual)
    }

    
    // ======================================================= //
    // MARK: - Index-based Updates
    // ======================================================= //
    
    func testIndexBasedUpdateMethodWithNewUniqueKey() {
        var orderedDictionary: OrderedDictionary<String, Int> = ["A": 1, "B": 2, "C": 3]
        let previousElement = orderedDictionary.update((key: "D", value: 4), at: 1)
        
        XCTAssertEqual(orderedDictionary.count, 3)
        XCTAssertTrue(previousElement! == ("B", 2))
        
        let expected: OrderedDictionary<String, Int> = ["A": 1, "D": 4, "C": 3]
        let actual = orderedDictionary
        
        XCTAssertTrue(expected == actual)
    }
    
    func testIndexBasedUpdateMethodByReplacingSameKey() {
        var orderedDictionary: OrderedDictionary<String, Int> = ["A": 1, "B": 2, "C": 3]
        let previousElement = orderedDictionary.update((key: "B", value: 42), at: 1)
        
        XCTAssertEqual(orderedDictionary.count, 3)
        XCTAssertTrue(previousElement! == ("B", 2))
        
        let expected: OrderedDictionary<String, Int> = ["A": 1, "B": 42, "C": 3]
        let actual = orderedDictionary
        
        XCTAssertTrue(expected == actual)
    }

    
//    func testRetrievingElementAtNonExistentIndex() {
//        let orderedDictionary: OrderedDictionary<String, Int> = ["A": 1, "B": 2, "C": 3]
//        XCTAssertThrowsError(orderedDictionary.element(at: 42))
////        XCTAssert
////        XCTAssertNil(orderedDictionary.element(at: 42))
//    }
    
    // ======================================================= //
    // MARK: - Content Removal
    // ======================================================= //
    
    func testRemoveAll() {
        var orderedDictionary: OrderedDictionary<String, Int> = ["A": 1, "B": 2, "C": 3]
        
        orderedDictionary.removeAll()
        
        XCTAssertEqual(orderedDictionary.count, 0)
    }
    
    func testKeyBasedRemoval() {
        var orderedDictionary: OrderedDictionary<String, Int> = ["A": 1, "B": 2, "C": 3]
        
        let removedValue1 = orderedDictionary.removeValue(forKey: "A")
        let removedValue2 = orderedDictionary.removeValue(forKey: "K")
        
        XCTAssertEqual(removedValue1, 1)
        XCTAssertNil(removedValue2)
        
        XCTAssertEqual(orderedDictionary.count, 2)
        
        XCTAssertNil(orderedDictionary["A"])
        XCTAssertNil(orderedDictionary.index(forKey: "A"))
        
        XCTAssertEqual(orderedDictionary["B"], 2)
        XCTAssertEqual(orderedDictionary.index(forKey: "B"), 0)
        
        XCTAssertEqual(orderedDictionary["C"], 3)
        XCTAssertEqual(orderedDictionary.index(forKey: "C"), 1)
    }
    
    func testIndexBasedRemoval() {
        var orderedDictionary: OrderedDictionary<String, Int> = ["A": 1, "B": 2, "C": 3, "D": 4]
        
        let (expectedKey1, expectedValue1) = ("A", 1)
        let (actualKey1, actualValue1) = orderedDictionary.remove(at: 0)
        
        XCTAssertEqual(expectedKey1, actualKey1)
        XCTAssertEqual(expectedValue1, actualValue1)
        
        let (expectedKey2, expectedValue2) = ("D", 4)
        let (actualKey2, actualValue2) = orderedDictionary.remove(at: 2)
        
        XCTAssertEqual(expectedKey2, actualKey2)
        XCTAssertEqual(expectedValue2, actualValue2)
        
//        let nonExistentElement = orderedDictionary.remove(at: 42)
        
//        XCTAssertNil(nonExistentElement)
        
        let expected: OrderedDictionary<String, Int> = ["B": 2, "C": 3]
        let actual = orderedDictionary
        
        XCTAssertTrue(expected == actual)
    }
    
    // ======================================================= //
    // MARK: - Sorting
    // ======================================================= //
    
    private let areInIncreasingOrder: (OrderedDictionary<String, Int>.Element, OrderedDictionary<String, Int>.Element) -> Bool = { element1, element2 in
        if element1.value == element2.value {
            return element1.key < element2.key
        } else {
            return element1.value < element2.value
        }
    }
    
    func testSortingWithMutation() {
        var orderedDictionary: OrderedDictionary<String, Int> = ["E": 4, "G": 3, "A": 3, "D": 1, "B": 4]
        orderedDictionary.sort(by: areInIncreasingOrder)
        let actual = orderedDictionary
        
        let expected: OrderedDictionary<String, Int> = ["D": 1, "A": 3, "G": 3, "B": 4, "E": 4]
        
        XCTAssertTrue(actual == expected)
    }
    
    func testSortingWithoutMutation() {
        let orderedDictionary: OrderedDictionary<String, Int> = ["E": 4, "G": 3, "A": 3, "D": 1, "B": 4]
        let actual: OrderedDictionary<String, Int> = orderedDictionary.sorted(by: areInIncreasingOrder)
        
        let expected: OrderedDictionary<String, Int> = ["D": 1, "A": 3, "G": 3, "B": 4, "E": 4]
        
        XCTAssertTrue(actual.elementsEqual(expected, by: ==))
    }
    
    // ======================================================= //
    // MARK: - Slices
    // ======================================================= //
    
    func testSliceAccess() {
        let orderedDictionary: OrderedDictionary<String, Int> = ["A": 1, "B": 2, "C": 3, "D": 4]
        let slice = orderedDictionary[2..<4]
        
        XCTAssertEqual(slice.count, 2)
        XCTAssertEqual(slice.startIndex, 2)
        XCTAssertEqual(slice.endIndex, 4)
        XCTAssertEqual(Array(slice.indices), [2, 3])
        XCTAssert(slice[2] == (key: "C", value: 3))
        XCTAssert(slice[3] == (key: "D", value: 4))
    }
}
