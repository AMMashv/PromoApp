//
//  HomeViewModel.swift
//  promoApp
//
//  Created by Artem Manyshev on 16.08.24.
//

import Foundation
import Combine

protocol HomeViewModelable: ObservableObject {
    var installationDay: Int { get }
    var startDayIsHidden: Bool { get }
    
    func startNextDay()
    func clear()
}

final class HomeViewModel: HomeViewModelable {
    
    @Published private(set) var installationDay: Int = 0
    @Published private(set) var startDayIsHidden: Bool = false
    
    private weak var coordinator: Coordinator?
    private var cancellables: Set<AnyCancellable> = []
    private let installationDaysManager: InstallationDaysManagerable
    
    init(coordinator: Coordinator, installationDaysManager: InstallationDaysManagerable) {
        self.coordinator = coordinator
        self.installationDaysManager = installationDaysManager
        configure()
    }
    
    func startNextDay() {
        do {
            try installationDaysManager.increaseValue()
        } catch {
            print("Home screen: increasing installation days failied with error: ", error.localizedDescription)
        }
        
        coordinator?.perform(transition: RootCoordinator.Transition.game)
    }
    
    func clear() {
        installationDaysManager.clearValue()
    }
}

private extension HomeViewModel {
    func configure() {
        installationDaysManager
            .value
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("Home screen: receiving installation days failed with error: ", error.localizedDescription)
                }
            } receiveValue: { [weak self] value in
                self?.installationDay = value
            }
            .store(in: &cancellables)
        
        installationDaysManager
            .isLastDayWarning
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] isLastDayWarning in
                self?.startDayIsHidden = isLastDayWarning
            }
            .store(in: &cancellables)
    }
}
