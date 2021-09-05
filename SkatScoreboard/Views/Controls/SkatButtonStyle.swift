//
//  SSButton.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 30.08.21.
//

import SwiftUI

struct SkatButtonStyle: ButtonStyle {
    private static let backgroundColorPressed = Color(.sRGB, red:0.0, green:0.549, blue:0.706, opacity:1.0)
    private static let backgroundColorNormal = Color.blue
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration
            .label
            .background(
                RoundedRectangle(cornerRadius: 15.0, style: .continuous)
                    .foregroundColor(configuration.isPressed ? SkatButtonStyle.backgroundColorPressed : SkatButtonStyle.backgroundColorNormal)
            )
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

struct SkatButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Button {} label: {
                Text("New Scoreboard")
                    .multilineTextAlignment(.center)
                    .font(.body.bold())
                    .padding(5)
                    .frame(width: 300, height: 100)
                    .foregroundColor(Color.white)
            }
            .skatButtonStyle()
                .previewLayout(.fixed(width: 330, height: 130))
                .previewDisplayName("Light Mode")
            
            Button {} label: {
                Text("Preview Content")
                    .multilineTextAlignment(.center)
                    .padding(5)
                    .frame(width: 300, height: 100)
                    .foregroundColor(Color.white)
            }
            .skatButtonStyle()
                .previewLayout(.fixed(width: 330, height: 130))
                .previewDisplayName("Dark Mode")
                .preferredColorScheme(.dark)
        }
    }
}
