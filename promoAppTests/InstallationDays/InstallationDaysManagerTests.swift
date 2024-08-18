//
//  InstallationDaysManagerTests.swift
//  promoAppTests
//
//  Created by Artem Manyshev on 17.08.24.
//

import XCTest
import Combine
@testable import promoApp

final class InstallationDaysManagerTests: XCTestCase {
    
    private var storageMock: UserDefaultsMock!
    private var storageManager: UserDefaultsStorageManager!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        storageMock = .init()
        storageManager = .init(storage: storageMock)
        cancellables = []
    }
    
    func testInitialValue() {
        makeSuT()
        
        XCTAssertFalse(storageMock.doubleValues.isEmpty)
        XCTAssertTrue(storageMock.objectValues.isEmpty)
    }
    
    func testPublishedValues() throws {
        let sut = makeSuT()
        let expectedCount = 10
        
        var values: [Int] = []
        let expectation = XCTestExpectation(description: "Publisher values")
        
        sut
            .value
            .sink { _ in } receiveValue: { value in
                values.append(value)
                
                if values.count >= expectedCount {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        try (1..<expectedCount).forEach { _ in
            try sut.increaseValue()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        values.enumerated().forEach {
            XCTAssertEqual($0.offset, $0.element)
        }
    }
    
    func testIncreaseValue() throws {
        let sut = makeSuT()
        
        XCTAssertEqual(storageMock.doubleValues.count, 1)
        XCTAssertTrue(storageMock.objectValues.isEmpty)
        
        let currentDate = try extractedStoredDate
        
        try sut.increaseValue()
        
        XCTAssertTrue(storageMock.objectValues.isEmpty)
        
        let newDate = try extractedStoredDate
        
        let days = try XCTUnwrap(currentDate.numberOfDays(to: newDate))
        XCTAssertEqual(days, -1)
    }
    
    func testClearValue() throws {
        let sut = makeSuT()
        let testDaysDifference = 30
        
        try (0..<testDaysDifference).forEach { _ in
            try sut.increaseValue()
        }
        
        let currentDate = try extractedStoredDate
        sut.clearValue()
        
        let newDate = try extractedStoredDate
        let days = try XCTUnwrap(currentDate.numberOfDays(to: newDate))
        XCTAssertEqual(days, testDaysDifference)
    }
}

private extension InstallationDaysManagerTests {
    
    @discardableResult
    func makeSuT() -> InstallationDaysManagerable {
        return InstallationDaysManager(with: storageManager)
    }
}

private extension InstallationDaysManagerTests {
    var extractedStoredDate: Date {
        get throws {
            let timeInterval = try XCTUnwrap(storageMock.doubleValues.first).value
            return Date(timeIntervalSince1970: timeInterval)
        }
    }
}
