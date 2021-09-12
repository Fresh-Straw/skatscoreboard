//
//  GameResultInput.swift
//  Skat Scoreboard
//
//  Created by Olaf Neumann on 14.03.21.
//

import SwiftUI
import Combine

struct GameResultInput: View {
    private static let row1GameTypes: [GameType] = [.suitClubs, .suitSpades, .suitHearts, .suitDiamonds]
    private static let row2GameTypes: [GameType] = [.grand, .null]
    
    private static let spacing: CGFloat = 1
    
    var overallHeight: CGFloat = 70 * 8.5
    
    @ObservedObject var gameConfig: GameConfiguration
//    @State private var gameType: GameType?
//    @State private var jacks: Int?
//    @State private var hand: Bool = false
//    @State private var ouvert: Bool = false
//    @State private var schneider: Bool = false
//    @State private var schneiderAnnounced: Bool = false
//    @State private var schwarz: Bool = false
//    @State private var schwarzAnnounced: Bool = false
//    @State private var contra: Bool = false
//    @State private var re: Bool = false
//    @State private var bock: Bool = false
//    @State private var win: Bool?
//    @State private var player: Player?
    
    @State private var customJacks: Int = 0
    @State private var showJacksSelection = false

    var scoreboard: Scoreboard
    
    var gameConfigurationCompletion: PassthroughSubject<GameConfiguration, Never>
    
    private var rowHeight: CGFloat {
        overallHeight / 10
    }
    
    private var isStandardGame: Bool {
        switch gameConfig.gameType {
        case .suitClubs, .suitSpades, .suitHearts, .suitDiamonds:
            return true
        default:
            return false
        }
    }
    
    private var isGrandGame: Bool { gameConfig.gameType == .grand }
    
    private var isNullGame: Bool { gameConfig.gameType == .null }
    
    private var isJunkGame: Bool { /*gameType == .junk*/ false }

    private func checkGameConfiguration() {
        if gameConfig.isComplete {
            gameConfigurationCompletion.send(gameConfig)
        }
    }

    var body: some View {
        VStack(spacing: GameResultInput.spacing) {
            ButtonSection("Spiel") {
                gameTypeControls
            }
            .frame(height: rowHeight * 2)
            
            if isStandardGame {
                ButtonSection("Mit/ ohne") {
                    extendedJacksControls
                }
                .frame(height: rowHeight)
                ButtonSection("Multiplikatoren") {
                    handOuvertControls
                    schneiderControls
                    schwarzControls
                }
                .frame(height: rowHeight * 3)
                ButtonSection("Spielwerterhöhung") {
                    contraControls
                }
                .frame(height: rowHeight)
                ButtonSection("Spieler") {
                    playersControls
                }
                .frame(height: rowHeight)
                ButtonSection("Gewonnen?") {
                    winLoseControls
                }
                .frame(height: rowHeight)
            }
            
            if isGrandGame {
                ButtonSection("Mit/ ohne") {
                    mainJacksControls
                }
                .frame(height: rowHeight)
                ButtonSection("Multiplikatoren") {
                    handOuvertControls
                    schneiderControls
                    schwarzControls
                }
                .frame(height: rowHeight * 3)
                ButtonSection("Spielwerterhöhung") {
                    contraControls
                }
                .frame(height: rowHeight)
                ButtonSection("Spieler") {
                    playersControls
                }
                .frame(height: rowHeight)
                ButtonSection("Gewonnen?") {
                    winLoseControls
                }
                .frame(height: rowHeight)
            }
            
            if isNullGame {
                ButtonSection("Multiplikatoren") {
                    handOuvertControls
                }
                .frame(height: rowHeight)
                ButtonSection("Spielwerterhöhung") {
                    contraControls
                }
                .frame(height: rowHeight)
                ButtonSection("Spieler") {
                    playersControls
                }
                .frame(height: rowHeight)
                ButtonSection("Gewonnen?") {
                    winLoseControls
                }
                .frame(height: rowHeight)
            }
            
            if isJunkGame {
                Text("Who got the most points?")
                playersControls
            }
        }
    }
    
    private var gameTypeControls: some View {
            VStack(spacing: GameResultInput.spacing) {
                HStack(spacing: GameResultInput.spacing) {
                    ForEach(GameResultInput.row1GameTypes) { type in
                        ToggleButton(title: LocalizedStringKey(type.rawValue), binding: $gameConfig.gameType, match: type, onAction: {checkGameConfiguration()})
                    }
                }
                HStack(spacing: GameResultInput.spacing) {
                    ForEach(GameResultInput.row2GameTypes) { type in
                        ToggleButton(title: LocalizedStringKey(type.rawValue), binding: $gameConfig.gameType, match: type, onAction: {checkGameConfiguration()})
                    }
                }
            }
    }
    
    private var mainJacksControls: some View {
            HStack(spacing: GameResultInput.spacing) {
                ForEach(1...4, id: \.self) { jacks in
                    ToggleButton(title: LocalizedStringKey("j\(jacks)"), binding: $gameConfig.jacks, match: jacks, onAction: {checkGameConfiguration()})
                }
            }
    }
    
    private var extendedJacksControls: some View {
            HStack(spacing: GameResultInput.spacing) {
                ForEach(1...4, id: \.self) { jacks in
                    ToggleButton(title: LocalizedStringKey("j\(jacks)"), binding: $gameConfig.jacks, match: jacks, onAction: {
                        checkGameConfiguration()
                        customJacks = 0
                    }
                    )
                }
                ToggleButton(title: customJacks == 0 ? LocalizedStringKey("...") : LocalizedStringKey("j\(customJacks)"), binding: $gameConfig.jacks, matching: {customJacks}, selection: { _ in
                        showJacksSelection = true
                    }, onAction: {checkGameConfiguration()})
                    .popover(isPresented: $showJacksSelection) { jacksPopover }
            }
    }
    
    private var jacksPopover: some View {
        // https://www.skatblog.com/2013/06/22/mit-6-spiel-7/
        NavigationView {
            VStack {
                Text("Wie viele Buben hatte der Spieler (nicht)?")
                Picker(selection: $customJacks, label: Text("Mit/ ohne"), content: {
                    Text("5").tag(5)
                    Text("6").tag(6)
                    Text("7").tag(7)
                    Text("8").tag(8)
                    Text("9").tag(9)
                    Text("10").tag(10)
                    Text("11").tag(11)
                })
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            showJacksSelection = false
                            customJacks = 0
                        } label: {
                            Text("Abbrechen")
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button {
                            showJacksSelection = false
                            gameConfig.jacks = customJacks
                        } label: {
                            Text("Fertig")
                        }
                    }
                }
            }
        }
    }
        
    private var schneiderControls: some View {
            HStack(spacing: GameResultInput.spacing) {
                ToggleButton(title: "Schneider", binding: $gameConfig.schneider, onAction: {checkGameConfiguration()})
                ToggleButton(title: "Schneider Angesagt", binding: $gameConfig.schneiderAnnounced, onAction: {checkGameConfiguration()})
            }
    }
    
    private var schwarzControls: some View {
            HStack(spacing: GameResultInput.spacing) {
                ToggleButton(title: "Schwarz", binding: $gameConfig.schwarz, onAction: {checkGameConfiguration()})
                ToggleButton(title: "Schwarz Angesagt", binding: $gameConfig.schwarzAnnounced, onAction: {checkGameConfiguration()})
            }
    }
    
    private var handOuvertControls: some View {
            HStack(spacing: GameResultInput.spacing) {
                ToggleButton(title: "Hand", binding: $gameConfig.hand, onAction: {checkGameConfiguration()})
                ToggleButton(title: "Ouvert", binding: $gameConfig.ouvert, onAction: {checkGameConfiguration()})
            }
    }
    
    private var contraControls: some View {
            HStack(spacing: GameResultInput.spacing) {
                ToggleButton(title: "Contra", binding: $gameConfig.contra, onAction: {checkGameConfiguration()})
                ToggleButton(title: "Re", binding: $gameConfig.re, onAction: {checkGameConfiguration()})
                ToggleButton(title: "Bock", binding: $gameConfig.bock, onAction: {checkGameConfiguration()})
            }
    }
    
    private var winLoseControls: some View {
            HStack(spacing: GameResultInput.spacing) {
                ToggleButton(title: "Won", binding: $gameConfig.win, match: true as Bool?, onAction: {checkGameConfiguration()})
                ToggleButton(title: "Lost", binding: $gameConfig.win, match: false as Bool?, onAction: {checkGameConfiguration()})
            }
    }
    
    private var playersControls: some View {
            HStack(spacing: GameResultInput.spacing) {
                ForEach(scoreboard.possiblePlayers) { player in
                    ToggleButton(title: LocalizedStringKey(player.name!), binding: $gameConfig.player, match: player as Player?, onAction: {checkGameConfiguration()})
                }
            }
    }
}

struct GameResultInput_Previews: PreviewProvider {
    static var previews: some View {
        GameResultInput(gameConfig: GameConfiguration(), scoreboard: PersistenceController.preview.getAScoreboard_preview(), gameConfigurationCompletion: PassthroughSubject<GameConfiguration, Never>())
//        GameResultInput(scoreboard: PersistenceController.preview.getAScoreboard_preview(), gameConfigurationCompletion: PassthroughSubject<Game, Never>())
    }
}
