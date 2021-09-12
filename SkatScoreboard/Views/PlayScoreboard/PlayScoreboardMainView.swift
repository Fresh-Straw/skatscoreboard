//
//  PlayScoreboardView.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 05.09.21.
//

import SwiftUI
import Combine
import SlideOverCard

struct PlayScoreboardMainView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    let applicationState: CurrentValueSubject<ApplicationState, Never>
    
    let scoreboard: Scoreboard
    
    @State private var showCloseScoreAlert = false
    @State private var showGameInputSlideOver = false
    
    private let gameConfigurationCreation = PassthroughSubject<GameConfig, Never>()
    @State private var gameConfig = GameConfig()
    @State private var latestGameConfig: GameConfig? = nil
    
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
        .slideOverCard(isPresented: $showGameInputSlideOver) {
            if let gameConfig = latestGameConfig {
                VStack {
                    GameConfigOverView(gameConfig: gameConfig)
                    HStack(spacing: 5) {
                        Button(action: {
                            showGameInputSlideOver = false
                        }, label: {
                            Text("Korrigieren")
                        })
                        .buttonStyle(SOCAlternativeButton())
                        Button(action: {
                            showGameInputSlideOver = false
                            let game = createGame(viewContext, in: scoreboard, gameConfig: gameConfig)
                            PersistenceController.shared.save()
                        }, label: {
                            Text("Speichern")
                        })
                        .buttonStyle(SOCActionButton())
                    }
                }
            }
        }
        .onReceive(gameConfigurationCreation, perform: { gameConfig in
            latestGameConfig = gameConfig
            showGameInputSlideOver = true
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
                let pdsize: CGFloat = min(region.size.width, region.size.height) / 3.0
                pointDisplay
                    .frame(height: pdsize)
                
                Text("Gib das Ergebnis für das nächste Spiel an:")
                
                GeometryReader { geo in
                    GameResultInput(overallHeight: geo.size.height, gameConfig: gameConfig, scoreboard: scoreboard, gameConfigurationCompletion: gameConfigurationCreation)
                }
            }
        }
    }
    
    private var pointDisplay: some View {
        HStack(alignment: .center, spacing: 0) {
            let players = scoreboard.playersSorted
            let giver = scoreboard.giver
            let points = scoreboard.computePoints()

            ForEach(players) { player in
                PlayerPointView(player: player, points: points.points[player] ?? 0, giver: player == giver)
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
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
