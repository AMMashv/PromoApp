//
//  ButtonModifiers.swift
//  promoApp
//
//  Created by Artem Manyshev on 17.08.24.
//

import SwiftUI

extension View {
    func customStyle(_ style: ButtonModifier.Style) -> some View {
        modifier(ButtonModifier(with: style))
    }
}

struct ButtonModifier: ViewModifier {
    enum Style {
        case bordered(color: Color)
        case filled(color: Color, contentColor: Color = .white)
    }
    
    private let style: Style
    
    init(with style: Style) {
        self.style = style
    }
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(foregroundColor)
            .padding()
            .background {
                Capsule()
                    .stroke(foregroundColor)
                    .fill(backgroundColor)
            }
    }
}

private extension ButtonModifier {
    var foregroundColor: Color {
        switch style {
        case .bordered(let color):
            return color
        case .filled(_, let contentColor):
            return contentColor
        }
    }
    
    var backgroundColor: Color {
        switch style {
        case .bordered:
            return .clear
        case .filled(let color, _):
            return color
        }
    }
}
