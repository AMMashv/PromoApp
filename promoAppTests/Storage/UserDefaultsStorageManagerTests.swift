//
//  UserDefaultsStorageManagerTests.swift
//  promoAppTests
//
//  Created by Artem Manyshev on 17.08.24.
//

import XCTest
@testable import promoApp

final class UserDefaultsStorageManagerTests: XCTestCase {
    
    private var defaultsMock: UserDefaultsMock!
    
    override func setUp() {
        super.setUp()
        defaultsMock = .init()
    }
    
    func testValueSaving() {
        let doubleValue = 10.0
        let floatValue: Float = 10.0
        let testKey = "testKey"
        
        let sut = makeSuT()
        sut.save(value: doubleValue, for: testKey)
        
        XCTAssertTrue(defaultsMock.objectValues.isEmpty)
        XCTAssertEqual(doubleValue, sut.value(for: testKey))
        
        sut.save(value: floatValue, for: testKey)
        
        XCTAssertTrue(defaultsMock.doubleValues.isEmpty)
        XCTAssertEqual(floatValue, sut.value(for: testKey))
    }
     
     func testRemoveValues() {
         let doubleValue = 10.0
         let floatValue: Float = 10.0
         let testKey = "testKey"
         let testFloatKey = "testFloatKey"
         
         let sut = makeSuT()
         sut.save(value: doubleValue, for: testKey)
         sut.save(value: floatValue, for: testFloatKey)
         
         XCTAssertFalse(defaultsMock.doubleValues.isEmpty)
         XCTAssertFalse(defaultsMock.objectValues.isEmpty)
         
         sut.removeValue(for: testKey)
         XCTAssertTrue(defaultsMock.doubleValues.isEmpty)
         XCTAssertFalse(defaultsMock.objectValues.isEmpty)
         
         sut.removeValue(for: testFloatKey)
         XCTAssertTrue(defaultsMock.doubleValues.isEmpty)
         XCTAssertTrue(defaultsMock.objectValues.isEmpty)
     }
}

private extension UserDefaultsStorageManagerTests {
    func makeSuT() -> StorageManagerable {
        return UserDefaultsStorageManager(storage: defaultsMock)
    }
}
