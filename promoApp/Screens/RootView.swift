//
//  RootView.swift
//  promoApp
//
//  Created by Artem Manyshev on 16.08.24.
//

import SwiftUI

struct RootView: View {
    @StateObject private var coordinator = RootCoordinator()
    
    var body: some View {
        coordinator.build(for: RootCoordinator.Transition.home)
            .sheet(item: $coordinator.sheet) { sheet in
                coordinator.build(for: sheet)
            }
    }
}
