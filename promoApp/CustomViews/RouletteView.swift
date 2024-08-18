//
//  RouletView.swift
//  promoApp
//
//  Created by Artem Manyshev on 17.08.24.
//

import SwiftUI

struct RouletteView: View {
    private enum Constants {
        static let iconOffsetPart: CGFloat = 0.8
        static let textRotationOffset: Angle = .radians(.pi * 3.0 / 2.0)
        static let pointerScaleEffect = 1.5
        static let arrowImageName = "arrow.down"
    }
    
    let items: [GiftItem]
    let rotationAngle: Angle
    let duration: Double
    
    var body: some View {
        GeometryReader { geometry in
            let center = CGPoint(x: geometry.size.width / 2.0, y: geometry.size.height / 2.0)
            let radius = min(geometry.size.width, geometry.size.height) / 2.0
            let textRadius = radius * Constants.iconOffsetPart
            
            ZStack {
                ForEach(items, id: \.self) { item in
                    let textRotationAngle = (item.startAngle + item.endAngle) / 2.0
                    
                    let xOffset = textRadius * cos(CGFloat(textRotationAngle.radians))
                    let yOffset = textRadius * sin(CGFloat(textRotationAngle.radians))
                    
                    ZStack {
                        SegmentShape(startAngle: item.startAngle, endAngle: item.endAngle, center: center, radius: radius)
                            .fill(item.gift.color)
                        
                        Text(item.gift.icon)
                            .rotationEffect(textRotationAngle - Constants.textRotationOffset)
                            .offset(x: xOffset, y: yOffset)
                    }
                }
                .rotationEffect(rotationAngle)
                .animation(.easeInOut(duration: duration), value: rotationAngle)
                
                Image(systemName: Constants.arrowImageName)
                    .scaleEffect(Constants.pointerScaleEffect)
                    .position(center)
                    .offset(y: -radius)
            }
        }
    }
}

struct SegmentShape: Shape {
    let startAngle: Angle
    let endAngle: Angle
    let center: CGPoint
    let radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: center)
        
        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )
        
        path.closeSubpath()
        return path
    }
}
