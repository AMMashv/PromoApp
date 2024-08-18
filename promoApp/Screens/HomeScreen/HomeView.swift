//
//  HomeView.swift
//  promoApp
//
//  Created by Artem Manyshev on 16.08.24.
//

import SwiftUI

struct HomeView<ViewModel: HomeViewModelable>: View {
    
    @StateObject private var viewModel: ViewModel
    
    init(viewModel: @autoclosure @escaping () -> ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(.installationDay)
                Text("\(viewModel.installationDay)")
            }
            
            Spacer()
            
            VStack {
                if !viewModel.startDayIsHidden {
                    Button(.startNextDay) {
                        viewModel.startNextDay()
                    }
                    .frame(maxWidth: .infinity)
                    .customStyle(.filled(color: .purple, contentColor: .white))
                }
                
                Button(.clearInstallation) {
                    viewModel.clear()
                }
                .frame(maxWidth: .infinity)
                .customStyle(.bordered(color: .purple))
            }
            .buttonStyle(.plain)
            .fixedSize(horizontal: true, vertical: false)
            
            Spacer()
        }
        .padding()
    }
}

private extension LocalizedStringKey {
    static let installationDay: LocalizedStringKey = "День установки:"
    static let startNextDay: LocalizedStringKey = "Начать следующий день"
    static let clearInstallation: LocalizedStringKey = "Сброс установки"
}
