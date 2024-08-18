//
//  GameItemsProvider.swift
//  promoApp
//
//  Created by Artem Manyshev on 17.08.24.
//

import SwiftUI

protocol GiftItemsProviderable {
    var giftItems: [GiftItem] { get }
}

struct GiftItem: Hashable {
    let gift: GameGift
    let startAngle: Angle
    let endAngle: Angle
}

final class GiftItemsProvider: GiftItemsProviderable {
    enum WinningChance {
        case normal
        case low
        
        var coefficient: Double {
            switch self {
            case .normal:
                return 1.0
            case .low:
                return 0.5
            }
        }
    }
    
    private let gifts: [GameGift]
    private let winningChances: [GameGift: WinningChance]
    
    var giftItems: [GiftItem] {
        var currentOffset = 0.0
        
        let totalChances = gifts.reduce(0.0, { $0 + chanceCoefficient(for: $1) })
        
        guard totalChances != 0.0 else {
            return []
        }
        
        let chanceAngle = 2.0 * .pi / totalChances
        
        return gifts.map {
            let chanceCoefficient = chanceCoefficient(for: $0)
            
            let startAngle = currentOffset
            let endAngle = currentOffset + chanceAngle * chanceCoefficient
            
            defer {
                currentOffset = endAngle
            }
            
            return .init(gift: $0, startAngle: .radians(startAngle), endAngle: .radians(endAngle))
        }
    }
    
    init(gifts: [GameGift] = GameGift.allCases, winningChances: [GameGift: WinningChance] = [.cool: .low]) {
        self.gifts = gifts
        self.winningChances = winningChances
    }
}

private extension GiftItemsProvider {
    func chanceCoefficient(for gift: GameGift) -> Double {
        let chance = winningChances[gift] ?? .normal
        return chance.coefficient
    }
}

enum GameGift: CaseIterable {
    case heart
    case fire
    case star
    case like
    case cool
    
    var icon: String {
        switch self {
        case .heart:
            return "❤️"
        case .fire:
            return "🔥"
        case .star:
            return "⭐️"
        case .like:
            return "👍"
        case .cool:
            return "😎"
        }
    }
    
    var color: Color {
        switch self {
        case .heart:
            return .brightRed
        case .fire:
            return .fieryOrange
        case .star:
            return .golden
        case .like:
            return .emeraldGreen
        case .cool:
            return .skyBlue
        }
    }
}

private extension Color {
    static let brightRed = Color(red: 1.0, green: 0.30, blue: 0.30)
    static let fieryOrange = Color(red: 1.0, green: 0.43, blue: 0.0)
    static let golden = Color(red: 1.0, green: 0.84, blue: 0.0)
    static let emeraldGreen = Color(red: 0.29, green: 0.67, blue: 0.31)
    static let skyBlue = Color(red: 0.0, green: 0.75, blue: 1.0)
}
