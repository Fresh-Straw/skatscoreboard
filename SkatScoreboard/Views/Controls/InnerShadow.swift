//
//  InnerShadow.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 06.09.21.
//

import SwiftUI

extension View {
    func innerShadow<S: Shape>(using shape: S, angle: Angle = .degrees(0), color: Color = .black, width: CGFloat = 6, blur: CGFloat = 6) -> some View {
        let finalX = CGFloat(cos(angle.radians - .pi / 2))
        let finalY = CGFloat(sin(angle.radians - .pi / 2))
        return self
            .overlay(
                shape
                    .stroke(color, lineWidth: width)
                    .offset(x: finalX * width * 0.6, y: finalY * width * 0.6)
                    .blur(radius: blur)
                    .mask(shape)
            )
    }
}


struct InnerShadow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Capsule()
                .foregroundColor(.blue)
                .innerShadow(using: Capsule())
                .previewLayout(.fixed(width: 200.0, height: 100.0))
                .previewDisplayName("Light Mode")
            ExitButtonView()
                .previewLayout(.fixed(width: 100.0, height: 100.0))
                .previewDisplayName("Dark Mode")
                .preferredColorScheme(.dark)
        }
    }
}
