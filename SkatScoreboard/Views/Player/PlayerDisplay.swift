//
//  PlayerDisplay.swift
//  Skat Scoreboard
//
//  Created by Olaf Neumann on 07.03.21.
//

import SwiftUI

struct PlayerDisplay: View {
    var player: Player?
    
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            PlayerIcon(player: player)
            Text(player?.name ?? "Player")
                .lineLimit(1)
        }
        .background(Color.white)
        .opacity(player != nil ? 1.0 : 0.4)
    }
}

struct PlayerDisplay_Previews: PreviewProvider {
    static var previews: some View {
        PlayerDisplay(player: PersistenceController.preview.getAPlayer_preview())
            .previewLayout(.fixed(width: 200, height: 200))
        PlayerDisplay()
            .previewLayout(.fixed(width: 200, height: 200))
    }
}
