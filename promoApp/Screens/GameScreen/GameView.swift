//
//  GameView.swift
//  promoApp
//
//  Created by Artem Manyshev on 16.08.24.
//

import SwiftUI
import Charts

struct GameView<ViewModel: GameViewModelable>: View {
    
    @StateObject private var viewModel: ViewModel
    
    init(viewModel: @autoclosure @escaping () -> ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        VStack {
            RouletteView(
                items: viewModel.giftItems,
                rotationAngle: viewModel.rotation,
                duration: viewModel.gameDuration
            )
            
            Spacer()
            
            VStack {
                Button(.takeGift) {
                    viewModel.takeGift()
                }
                .frame(maxWidth: .infinity)
                .customStyle(.filled(color: .purple, contentColor: .white))
                
                Button(.decline) {
                    viewModel.decline()
                }
                .frame(maxWidth: .infinity)
                .customStyle(.bordered(color: .purple))
            }
            .fixedSize(horizontal: true, vertical: false)
        }
        .padding()
        .alert(.declineForever, isPresented: $viewModel.lastDayConfirmation) {
            Button(.yes, role: .destructive) {
                viewModel.declineConfirmed()
            }
            
            Button(.cancel, role: .cancel) { }
        }
        .onAppear {
            viewModel.startGame()
        }
    }
}

private extension LocalizedStringKey {
    static let takeGift: LocalizedStringKey = "Забрать подарок"
    static let decline: LocalizedStringKey = "Отказаться"
    static let declineForever: LocalizedStringKey = "Отказаться от подарка навсегда?"
    static let yes: LocalizedStringKey = "Да"
    static let cancel: LocalizedStringKey = "Отмена"
}
