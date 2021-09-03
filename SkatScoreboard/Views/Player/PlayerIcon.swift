//
//  PlayerIcon.swift
//  Skat Scoreboard
//
//  Created by Olaf Neumann on 07.03.21.
//

import SwiftUI

struct PlayerIcon: View {
    private static let DEFAULT_COLOR = Color.gray
    var player: Player?
    
    private var image: some View {
        Image(systemName: player?.iconName ?? "person.fill")
            .padding(20)
            .background(backgroundColor)
            .foregroundColor(backgroundColor.textColor)
            .imageScale(.large)
    }
    
    private var backgroundColor: Color {
        player?.iconColor ?? PlayerIcon.DEFAULT_COLOR
    }
    
    var body: some View {
        image
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 2))
            .shadow(color: backgroundColor, radius: 5)
            //.shadow(radius: 5)
    }
}

struct PlayerIcon_Previews: PreviewProvider {
    static var previews: some View {
        PlayerIcon(player: PersistenceController.preview.getAPlayer_preview())
            .previewLayout(.fixed(width: 100, height: 100))
        PlayerIcon(player: nil)
            .previewLayout(.fixed(width: 100, height: 100))
        PlayerIcon(player: PersistenceController.preview.getAPlayer_preview())
            .environment(\.colorScheme, .dark)
            .previewLayout(.fixed(width: 100, height: 100))
    }
}
