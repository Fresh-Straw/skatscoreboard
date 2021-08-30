//
//  SSButton.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 30.08.21.
//

import SwiftUI

struct SkatButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(RoundedRectangle(cornerRadius: 15.0, style: .continuous)
                            .foregroundColor(configuration.isPressed ? Color(.sRGB, red:0.0, green:0.549, blue:0.706, opacity:1.0) : Color.blue))
            .scaleEffect(configuration.isPressed ? CGFloat(0.9) : 1.0)
            .rotationEffect(.degrees(configuration.isPressed ? 0.0 : 0))
            .blur(radius: configuration.isPressed ? CGFloat(0.5) : 0)
            .animation(Animation.spring(response: 0.1, dampingFraction: 0.9, blendDuration: 1))
    }
}

extension Button {
    func skatButtonStyle() -> some View {
        self.buttonStyle(SkatButtonStyle())
    }
}

