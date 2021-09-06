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
                
                nextGameInput(width: region.size.width)
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
    
    private func nextGameInput(width: CGFloat) -> some View {
        VStack {
            let size4 = width / 4.0
            let size2 = width / 2.0
            let buttons4 = [GameType.suitsClubs, GameType.suitsSpades, GameType.suitsHearts, GameType.suitsDiamonds]
            let buttons2 = [GameType.grand, GameType.null]

            HStack(spacing: 0) {
                ForEach(buttons4) { gameType in
                    GameSelectionButton {} label: {
                        VStack {
                            Image(systemName: gameType.imageSystemName)
                                .imageScale(.large)
                            Text(gameType.displayName)
                                .font(.title2)
                        }
                    }
                    .frame(width: size4, height: size4)
                    .background(gameType.color)
                    .foregroundColor(gameType.color.textColor)
                }
            }
            HStack(spacing: 0) {
                ForEach(buttons2) { gameType in
                    GameSelectionButton {} label: {
                        VStack {
                            Image(systemName: gameType.imageSystemName)
                                .imageScale(.large)
                            Text(gameType.displayName)
                                .font(.title2)
                        }
                    }
                    .frame(width: size2, height: size4)
                    .background(gameType.color)
                    .foregroundColor(gameType.color.textColor)
                }
            }
            HStack(spacing: 0) {
                let schneiderColor = Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1))
                GameSelectionButton {} label: {
                    VStack {
                        Text("Schneider")
                            .font(.title2)
                    }
                }
                .frame(width: size2, height: size4)
                .background(schneiderColor)
                .foregroundColor(schneiderColor.textColor)
                
                GameSelectionButton {} label: {
                    VStack {
                        Text("Schneider angesagt")
                            .padding()
                            .font(.title2)
                    }
                }
                .frame(width: size2, height: size4)
                .background(schneiderColor.opacity(0.8))
                .foregroundColor(schneiderColor.textColor)
            }
            HStack(spacing: 0) {
                let schneiderColor = Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
                GameSelectionButton {} label: {
                    VStack {
                        Text("Schwarz")
                            .font(.title2)
                    }
                }
                .frame(width: size2, height: size4)
                .background(schneiderColor)
                .foregroundColor(schneiderColor.textColor)
                
                GameSelectionButton {} label: {
                    VStack {
                        Text("Schwarz angesagt")
                            .padding()
                            .font(.title2)
                    }
                }
                .frame(width: size2, height: size4)
                .background(schneiderColor.opacity(0.8))
                .foregroundColor(schneiderColor.textColor)
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
                Image(systemName: "diamond.fill")
                    .imageScale(.medium)
                    .offset(x: -35, y: -40)
                    .opacity(0.8)
            }
            
            VStack {
                Text(String(points))
                    .font(.title)
                    .bold()
                    .shadow(radius: 10)
                
                Text(player.name ?? "")
                    .allowsTightening(true)
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
