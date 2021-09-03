//
//  PlayerDisplay.swift
//  Skat Scoreboard
//
//  Created by Olaf Neumann on 07.03.21.
//

import SwiftUI

struct PlayerDisplay: View {
    var player: Player?
    var playerName: String?
    
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            PlayerIcon(player: player)
            Text(player?.name ?? playerName ?? "Player")
                .lineLimit(1)
        }
        .opacity(player != nil ? 1.0 : 0.4)
    }
}

struct PlayerDisplay_Previews: PreviewProvider {
    static var previews: some View {
        PlayerDisplay(player: PersistenceController.preview.getAPlayer_preview())
            .previewLayout(.fixed(width: 150, height: 150))
            .previewDisplayName("Light Mode")

        PlayerDisplay(player: PersistenceController.preview.getAPlayer_preview())
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
            .previewLayout(.fixed(width: 150, height: 150))

        PlayerDisplay(playerName: "Spieler 2")
            .previewLayout(.fixed(width: 150, height: 150))
            .previewDisplayName("Disable Light")
        
        PlayerDisplay(playerName: "Spieler 2")
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 150, height: 150))
            .previewDisplayName("Disable Dark")
    }
}
