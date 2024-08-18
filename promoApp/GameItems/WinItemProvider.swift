//
//  GiftProvider.swift
//  promoApp
//
//  Created by Artem Manyshev on 17.08.24.
//

import Combine

protocol GiftProviderable {
    var value: AnyPublisher<GameGift, Error> { get }
}

final class GiftProvider: GiftProviderable {
    enum GiftProviderError: Error {
        case unexpectedStoredDayValue(Int)
    }
    
    private let installationDaysProvider: InstallationDaysProviderable
    
    var value: AnyPublisher<GameGift, Error> {
        installationDaysProvider
            .value
            .tryCompactMap { [weak self] value in
                return try self?.gift(for: value)
            }
            .eraseToAnyPublisher()
    }
    
    init(with installationDaysProvider: InstallationDaysProviderable) {
        self.installationDaysProvider = installationDaysProvider
    }
}

private extension GiftProvider {
    func gift(for day: Int) throws -> GameGift {
        switch day {
        case 1:
            return .heart
        case 2:
            return .fire
        case 3:
            return .cool
        default:
            throw GiftProviderError.unexpectedStoredDayValue(day)
        }
    }
}
