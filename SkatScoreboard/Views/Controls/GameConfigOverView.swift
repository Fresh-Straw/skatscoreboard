//
//  GameConfigOverview.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 12.09.21.
//

import SwiftUI
import Combine

struct GameConfigOverView : View {
    var gameConfig: Gamish
    
    var body : some View {
        VStack(alignment: .leading) {
            let steps: [PointComputationStep] = PointModelCalculator.default.generateComputationSteps(for: gameConfig)

            VStack(alignment: .leading) {
                Text("Neues Spiel")
                    .font(.title2)
                
                Text("Spieler:")
                    .padding(.top)
                Text(gameConfig.playerOfGame.name ?? "Spielername")
                    .bold()
                    .padding(.leading)
                
                Text("Spiel:")
                    .padding(.top)
                HStack(spacing: 3) {
                    Text(gameConfig.type.displayName)
                        .bold()
                    if gameConfig.hand {
                        Text("Hand")
                    }
                    if gameConfig.ouvert {
                        Text("Ouvert")
                    }
                }
                .padding(.leading)
                
                Divider()
            }

            VStack(alignment: .leading) {
                Text("Punkte:")
                ForEach(0..<steps.count) { i in
                    HStack {
                        Text(steps[i].title)
                        + Text(":")
                        Text(String(steps[i].number))
                    }
                    .padding(.leading)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(2)
    }
}

struct GameConfigOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameConfigOverView(gameConfig: PersistenceController.preview.gameConfig)
            .previewLayout(.fixed(width: 300, height: 400))
    }
}
