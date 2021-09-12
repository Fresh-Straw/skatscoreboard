//
//  PlayScoreboardView.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 05.09.21.
//

import SwiftUI
import Combine

struct PlayScoreboardMainView: View {
    let applicationState: CurrentValueSubject<ApplicationState, Never>
    
    let scoreboard: Scoreboard
    
    @State private var showCloseScoreAlert = false
    
    var body: some View {
        ZStack {
            Color.listBackground
                .ignoresSafeArea()
            
            VStack {
                menuBar
                
                actualBody
            }
        }
        .alert(isPresented: $showCloseScoreAlert, content: {
            Alert.init(
                title: Text("Spiel beenden?"),
                primaryButton: Alert.Button.default(Text("Beenden"), action: { applicationState.send(.MainMenu) }),
                secondaryButton: Alert.Button.cancel()
            )
        })
    }
    
    private var menuBar: some View {
        HStack {
            Text("Runde 1")
            
            Spacer()
            
            Button {
                
            } label: { Text("Statistik") }
            Button {
                showCloseScoreAlert = true
            } label: {
                ExitButtonView()
                    .frame(width: 32, height: 32)
            }
        }
        .padding(5)
    }
    
    private var actualBody: some View {
        GeometryReader { region in
            VStack(spacing: 8) {
                pointDisplay
                    .frame(height: region.size.width / 3)
                
                Text("Gib das Ergebnis für das nächste Spiel an:")
                
                GeometryReader { geo in
                    GameResultInput(overallHeight: geo.size.height, gameConfig: GameConfiguration(), scoreboard: scoreboard, gameConfigurationCompletion: PassthroughSubject<GameConfiguration, Never>())
                }
                //nextGameInput(width: region.size.width)
            }
        }
        
    }
    
    private var pointDisplay: some View {
        HStack(alignment: .center, spacing: 0) {
            let players = scoreboard.playersSorted
            let giver = scoreboard.giver
            let points = scoreboard.computePoints()

            ForEach(players) { player in
                PlayerPointView(player: player, points: points[player] ?? 0, giver: player == giver)
            }
        }
    }
}

private struct GameSelectionButton<Label: View> : View {
    private let label: Label
    private let action: () -> ()
    
    init(_ action: @escaping () -> (), @ViewBuilder label: () -> Label) {
        self.label = label()
        self.action = action
    }
    
    var body : some View {
        Button(action: action, label: {
            label
        })
    }
}

private struct PlayerPointView : View {
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

struct PlayScoreboardMainView_Previews: PreviewProvider {
    static var previews: some View {
        PlayScoreboardMainView(
            applicationState: CurrentValueSubject<ApplicationState, Never>(.MainMenu),
            scoreboard: PersistenceController.preview.getAScoreboard_preview()
        )
        PlayerPointView(player: PersistenceController.preview.getAPlayer_preview(), points: 42)
            .previewLayout(.fixed(width: 150, height: 150))
        PlayerPointView(player: PersistenceController.preview.getAPlayer_preview(), points: 42, giver: true)
            .previewLayout(.fixed(width: 150, height: 150))
    }
}
