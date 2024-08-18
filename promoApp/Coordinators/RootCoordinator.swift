//
//  RootCoordinator.swift
//  promoApp
//
//  Created by Artem Manyshev on 16.08.24.
//

import SwiftUI

final class RootCoordinator: Coordinator, ObservableObject {
    
    @Published var sheet: Transition?
    
    private let installationDaysManager: InstallationDaysManagerable
    
    init(installationDaysManager: InstallationDaysManagerable = InstallationDaysManager(with: UserDefaultsStorageManager())) {
        self.installationDaysManager = installationDaysManager
    }
    
    func perform(transition: any Transitionable) {
        guard let transition = transition as? Transition else {
            return
        }
        
        present(for: transition)
    }
    
    func dismiss() {
        sheet = nil
    }
    
    @ViewBuilder func build(for transition: Transition) -> some View {
        switch transition {
        case .home:
            let viewModel = HomeViewModel(coordinator: self, installationDaysManager: installationDaysManager)
            HomeView(viewModel: viewModel)
        case .game:
            let viewModel = GameViewModel(
                coordinator: self,
                installationDaysProvider: installationDaysManager,
                giftProvider: GiftProvider(with: installationDaysManager)
            )
            
            GameView(viewModel: viewModel)
        }
    }
}

extension RootCoordinator {
    enum Transition: Transitionable {
        case home
        case game
        
        var id: Self { return self }
    }
}

private extension RootCoordinator {
    
    func present(for transition: Transition) {
        sheet = transition
    }
}
