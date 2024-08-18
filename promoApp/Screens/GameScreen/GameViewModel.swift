//
//  GameViewModel.swift
//  promoApp
//
//  Created by Artem Manyshev on 16.08.24.
//

import Foundation
import Combine
import SwiftUI

protocol GameViewModelable: ObservableObject {
    var lastDayConfirmation: Bool { get set }
    var rotation: Angle { get set }
    var giftItems: [GiftItem] { get }
    var gameDuration: Double { get }
    
    func startGame()
    func takeGift()
    func decline()
    func declineConfirmed()
}

final class GameViewModel: GameViewModelable {
    private enum Constants {
        static let minGameDuration = 2
        static let maxGameDuration = 5
        static let minRotations = 5
        static let maxRoatations = 9
    }
    
    @Published var lastDayConfirmation: Bool = false
    @Published var rotation: Angle = .radians(0.0)
    
    let giftItems: [GiftItem]
    
    var gameDuration: Double {
        Double(Int.random(in: Constants.minGameDuration...Constants.maxGameDuration))
    }
    
    private weak var coordinator: Coordinator?
    private var cancellables: Set<AnyCancellable> = []
    private let declineInternal = PassthroughSubject<Void, Error>()
    private let installationDaysProvider: InstallationDaysProviderable
    private let giftProvider: GiftProviderable
    
    init(
        coordinator: Coordinator,
        installationDaysProvider: InstallationDaysProviderable,
        giftProvider: GiftProviderable,
        giftItemsProvider: GiftItemsProviderable = GiftItemsProvider()
    ) {
        self.coordinator = coordinator
        self.installationDaysProvider = installationDaysProvider
        self.giftItems = giftItemsProvider.giftItems
        self.giftProvider = giftProvider
        
        configure()
    }
    
    func startGame() {
        giftProvider
            .value
            .prefix(1)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("Game screen: Receiving gift value failed with error: ", error.localizedDescription)
                }
            } receiveValue: { [weak self] gift in
                self?.processGift(gift)
            }
            .store(in: &cancellables)
    }
    
    func takeGift() {
        coordinator?.dismiss()
    }
    
    func decline() {
        declineInternal.send(())
    }
    
    func declineConfirmed() {
        coordinator?.dismiss()
    }
}

private extension GameViewModel {
    var rotationsCount: Double {
        return Double(Int.random(in: Constants.minRotations...Constants.maxRoatations))
    }
    
    func configure() {
        Publishers.CombineLatest(installationDaysProvider.isLastDayWarning, declineInternal)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("Game screen: Receiving last installation day value failed with error: ", error.localizedDescription)
                }
            } receiveValue: { [weak self] result in
                let (isLastDayWarning, _) = result
                
                guard isLastDayWarning else {
                    self?.coordinator?.dismiss()
                    return
                }
                
                self?.lastDayConfirmation = true
            }
            .store(in: &cancellables)
    }
    
    func processGift(_ item: GameGift) {
        guard let giftItem = giftItems.first(where: { $0.gift == item }), giftItem.startAngle <= giftItem.endAngle else {
            return
        }
        
        let randomAngle = Double.random(in: giftItem.startAngle.radians...giftItem.endAngle.radians)
        
        let fullRotationsAngle = rotationsCount * 2.0 * .pi
        let totalRotationAngle = fullRotationsAngle - randomAngle
        let shiftedRotationAngle = totalRotationAngle - .pi / 2.0
        
        rotation += .radians(shiftedRotationAngle)
    }
}
