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
            let width2 = width / 2.0
            let width4 = width / 4.0
            let width5 = width / 5.0
            let height = width / 4.5
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
                    .frame(width: width4, height: height)
                    .background(color(for: gameType))
                    .foregroundColor(color(for: gameType).textColor)
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
                    .frame(width: width2, height: height)
                    .background(color(for: gameType))
                    .foregroundColor(color(for: gameType).textColor)
                }
            }
            HStack(spacing: 0) {
                let handOuvertColor = Color(#colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1))
                GameSelectionButton {} label: {
                    VStack {
                        Text("Hand")
                            .font(.title2)
                    }
                }
                .frame(width: width2, height: height)
                .background(handOuvertColor)
                .foregroundColor(handOuvertColor.textColor)
                
                GameSelectionButton {} label: {
                    VStack {
                        Text("Ouvert")
                            .padding()
                            .font(.title2)
                    }
                }
                .frame(width: width2, height: height)
                .background(handOuvertColor.opacity(0.8))
                .foregroundColor(handOuvertColor.textColor)
            }
            HStack(spacing: 0) {
                let jackColor = Color(#colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1))
                GameSelectionButton {} label: {
                    VStack(spacing: 4) {
                        Text("Mit/ ohne")
                            .font(.caption)
                        Text("1")
                            .font(.title)
                    }
                }
                .frame(width: width5, height: height)
                .background(jackColor)
                .foregroundColor(jackColor.textColor)
                GameSelectionButton {} label: {
                    VStack(spacing: 4) {
                        Text("Mit/ ohne")
                            .font(.caption)
                        Text("2")
                            .font(.title)
                    }
                }
                .frame(width: width5, height: height)
                .background(jackColor.opacity(0.92))
                .foregroundColor(jackColor.textColor)
                GameSelectionButton {} label: {
                    VStack(spacing: 4) {
                        Text("Mit/ ohne")
                            .font(.caption)
                        Text("3")
                            .font(.title)
                    }
                }
                .frame(width: width5, height: height)
                .background(jackColor.opacity(0.84))
                .foregroundColor(jackColor.textColor)
                GameSelectionButton {} label: {
                    VStack(spacing: 4) {
                        Text("Mit/ ohne")
                            .font(.caption)
                        Text("4")
                            .font(.title)
                    }
                }
                .frame(width: width5, height: height)
                .background(jackColor.opacity(0.76))
                .foregroundColor(jackColor.textColor)
                GameSelectionButton {} label: {
                    VStack(spacing: 14) {
                        Text("Mit/ ohne")
                            .font(.caption)
                        Image(systemName: "ellipsis")
                            .imageScale(.large)
                    }
                }
                .frame(width: width5, height: height)
                .background(jackColor.opacity(0.68))
                .foregroundColor(jackColor.textColor)
            }
            HStack(spacing: 0) {
                let schneiderColor = Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1))
                GameSelectionButton {} label: {
                    VStack {
                        Text("Schneider")
                            .font(.title2)
                    }
                }
                .frame(width: width2, height: height)
                .background(schneiderColor)
                .foregroundColor(schneiderColor.textColor)
                
                GameSelectionButton {} label: {
                    VStack {
                        Text("Schneider angesagt")
                            .padding()
                            .font(.title2)
                    }
                }
                .frame(width: width2, height: height)
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
                .frame(width: width2, height: height)
                .background(schneiderColor)
                .foregroundColor(schneiderColor.textColor)
                
                GameSelectionButton {} label: {
                    VStack {
                        Text("Schwarz angesagt")
                            .padding()
                            .font(.title2)
                    }
                }
                .frame(width: width2, height: height)
                .background(schneiderColor.opacity(0.8))
                .foregroundColor(schneiderColor.textColor)
            }
        }
    }
    
    private func color(for game: GameType) -> Color {
        switch game {
        case .suitsClubs:
            return Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
        case .suitsSpades:
            return Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
        case .suitsHearts:
            return Color(#colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1))
        case .suitsDiamonds:
            return Color(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
        case .grand:
            return Color(#colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1))
        case .null:
            return Color(#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1))
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
