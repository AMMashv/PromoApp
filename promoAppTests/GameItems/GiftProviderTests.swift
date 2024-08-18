//
//  GiftProviderTests.swift
//  promoAppTests
//
//  Created by Artem Manyshev on 17.08.24.
//

import XCTest
import Combine
@testable import promoApp

final class GiftProviderTests: XCTestCase {
    
    private var storage: UserDefaultsMock!
    private var daysManager: InstallationDaysManagerable!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        storage = UserDefaultsMock()
        
        let storageManager = UserDefaultsStorageManager(storage: storage)
        
        daysManager = InstallationDaysManager(with: storageManager)
        cancellables = []
    }
    
    func testEmptyValueFailure() throws {
        let sut = makeSuT()
        
        let expectation = XCTestExpectation(description: "Publisher error")
        
        var expectedError: Error?
        
        sut
            .value
            .sink { completion in
                if case .failure(let error) = completion {
                    expectedError = error
                    expectation.fulfill()
                }
            } receiveValue: { value in
                XCTFail("Received unexpected value: \(value)")
            }
            .store(in: &cancellables)
            
        wait(for: [expectation], timeout: 1.0)
        
        let error = try XCTUnwrap(expectedError as? GiftProvider.GiftProviderError)
        
        guard case .unexpectedStoredDayValue(let days) = error else {
            XCTFail("Unexpected error type")
            return
        }
        
        XCTAssertEqual(days, 0)
    }
    
    func testDaysIncreasing() throws {
        let sut = makeSuT()
        let expectedGifts: [GameGift] = [.heart, .fire, .cool]
        
        try daysManager.increaseValue()
        
        var receivedValues: [GameGift] = []
        var expectedError: Error?
        
        let errorExpectation = XCTestExpectation(description: "Publisher error")
        
        sut
            .value
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    expectedError = error
                    errorExpectation.fulfill()
                }
            }, receiveValue: { value in
                receivedValues.append(value)
            })
            .store(in: &cancellables)
        
        try (0...GameGift.allCases.count).forEach { _ in
            try daysManager.increaseValue()
        }
        
        wait(for: [errorExpectation], timeout: 1.0)
        
        XCTAssertEqual(receivedValues, expectedGifts)
        let error = try XCTUnwrap(expectedError as? GiftProvider.GiftProviderError)
        
        guard case .unexpectedStoredDayValue(let days) = error else {
            XCTFail("Unexpected error type")
            return
        }
        
        XCTAssertEqual(days, expectedGifts.count + 1)
    }
}

private extension GiftProviderTests {
    func makeSuT() -> GiftProviderable {
        return GiftProvider(with: daysManager)
    }
}
