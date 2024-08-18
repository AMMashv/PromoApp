//
//  GiftItemsProviderTests.swift
//  promoAppTests
//
//  Created by Artem Manyshev on 17.08.24.
//

import XCTest
@testable import promoApp

final class GiftItemsProviderTests: XCTestCase {
    
    func testRepeatingItems() {
        testItems(with: repeatingItems, winningChances: [.fire: .normal])
        testItems(with: repeatingItems, winningChances: [.fire: .low])
    }
    
    func testAllItems() {
        testItems(with: GameGift.allCases, winningChances: [.fire: .low, .cool: .normal, .heart: .low])
    }
}

private extension GiftItemsProviderTests {
    func makeSuT(with gifts: [GameGift], winningChances: [GameGift: GiftItemsProvider.WinningChance]) -> GiftItemsProviderable {
        return GiftItemsProvider(gifts: gifts, winningChances: winningChances)
    }
    
    func testItems(with items: [GameGift], winningChances: [GameGift: GiftItemsProvider.WinningChance]) {
        let sut = makeSuT(with: items, winningChances: winningChances)
        XCTAssertEqual(items, sut.giftItems.map(\.gift))
        
        let anglesSum = sut.giftItems.reduce(0.0, { $0 + ($1.endAngle.radians - $1.startAngle.radians) })
        
        guard !items.isEmpty else {
            return XCTAssertEqual(anglesSum, 0.0)
        }
        
        let tolerance = 1e-10
        XCTAssertEqual(anglesSum, .pi * 2.0, accuracy: tolerance)
    }
}

private extension GiftItemsProviderTests {
    var repeatingItems: [GameGift] {
        let count = Int(arc4random_uniform(25))
        return Array(repeating: .fire, count: count)
    }
}
