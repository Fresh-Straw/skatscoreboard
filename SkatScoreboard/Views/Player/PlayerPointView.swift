//
//  PlayerPointView.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 12.09.21.
//

import SwiftUI

struct PlayerPointView : View {
    let player: Player
    let points: Int
    var giver = false
    
    var body : some View {
        ZStack {
            player.iconColor
                .opacity(0.25)
            
            if giver {
                Image(systemName: "seal.fill")
                    .imageScale(.medium)
                    .offset(x: -35, y: -40)
                    .opacity(0.7)
            }
            
            VStack {
                Text(String(points))
                    .font(.title)
                    .bold()
                    .shadow(radius: 10)
                
                Text(player.name ?? "")
                    .allowsTightening(true)
                    .lineLimit(2)
                    .textCase(.uppercase)
            }
        }
    }
}

struct PlayerPointView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerPointView(player: PersistenceController.preview.getAPlayer_preview(), points: 42)
            .previewLayout(.fixed(width: 150, height: 150))
        PlayerPointView(player: PersistenceController.preview.getAPlayer_preview(), points: 42, giver: true)
            .previewLayout(.fixed(width: 150, height: 150))
    }
}
