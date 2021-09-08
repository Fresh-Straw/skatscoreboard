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
    
    // @ObservedObject var gameConfig: GameConfiguration
    @State private var gameType: GameType?
    @State private var jacks: Int?
    @State private var hand: Bool = false
    @State private var ouvert: Bool = false
    @State private var schneider: Bool = false
    @State private var schneiderAnnounced: Bool = false
    @State private var schwarz: Bool = false
    @State private var schwarzAnnounced: Bool = false
    @State private var contra: Bool = false
    @State private var re: Bool = false
    @State private var bock: Bool = false
    @State private var win: Bool?
    @State private var player: Player?

    var scoreboard: Scoreboard
    
    var gameConfigurationCompletion: PassthroughSubject<Game, Never>
    
    private var rowHeight: CGFloat {
        70
    }
    
    private var isStandardGame: Bool {
        switch gameType {
        case .suitClubs, .suitSpades, .suitHearts, .suitDiamonds:
            return true
        default:
            return false
        }
    }
    
    private var isGrandGame: Bool { gameType == .grand }
    
    private var isNullGame: Bool { gameType == .null }
    
    private var isJunkGame: Bool { /*gameType == .junk*/ false }

    private func checkGameConfiguration() {
        if false/*isComplete*/ {
            // TODO onGameConfigurationCompleted()
        }
    }

    var body: some View {
        VStack(spacing: GameResultInput.spacing) {
            gameTypeControls
            
            if isStandardGame {
                handOuvertControls
                VStack(spacing: GameResultInput.spacing) {
                    Text("Mit/ Ohne")
                    //mainJacksControls
                    //additionalJacksControls
                    extendedJacksControls
                }
                schneiderControls
                schwarzControls
                contraControls
                Text("Who played the game?")
                playersControls
                winLoseControls
            }
            
            if isGrandGame {
                handOuvertControls
                VStack(spacing: GameResultInput.spacing) {
                    Text("Mit/ Ohne")
                    mainJacksControls
                }
                schneiderControls
                schwarzControls
                contraControls
                Text("Who played the game?")
                playersControls
                winLoseControls
            }
            
            if isNullGame {
                handOuvertControls
                contraControls
                Text("Who played the game?")
                playersControls
                winLoseControls
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
                    ToggleButton(title: LocalizedStringKey(type.rawValue), binding: $gameType, match: type, onAction: {checkGameConfiguration()})
                }
            }
            .frame(height: rowHeight)
            HStack(spacing: GameResultInput.spacing) {
                ForEach(GameResultInput.row2GameTypes) { type in
                    ToggleButton(title: LocalizedStringKey(type.rawValue), binding: $gameType, match: type, onAction: {checkGameConfiguration()})
                }
            }
            .frame(height: rowHeight)
        }
    }
    
    private var mainJacksControls: some View {
        HStack(spacing: GameResultInput.spacing) {
            ForEach(1...4, id: \.self) { jacks in
                ToggleButton(title: LocalizedStringKey("j\(jacks)"), binding: $jacks, match: jacks, onAction: {checkGameConfiguration()})
            }
        }
        .frame(height: rowHeight)
    }
    
    private var extendedJacksControls: some View {
        HStack(spacing: GameResultInput.spacing) {
            ForEach(1...4, id: \.self) { jacks in
                ToggleButton(title: LocalizedStringKey("j\(jacks)"), binding: $jacks, match: jacks, onAction: {checkGameConfiguration()})
            }
            ToggleButton(title: LocalizedStringKey("..."), binding: $jacks, match: 5, onAction: {checkGameConfiguration()})
        }
        .frame(height: rowHeight)
    }
    
//    private var additionalJacksControls: some View {
//        // https://www.skatblog.com/2013/06/22/mit-6-spiel-7/
//        HStack(spacing: GameResultInput.spacing) {
//            ForEach(5...11, id: \.self) { jacks in
//                ToggleButton(title: LocalizedStringKey("j\(jacks)"), binding: $jacks, match: jacks, onAction: {checkGameConfiguration()})
//            }
//        }
//        .frame(height: rowHeight)
//    }
    
    private var schneiderControls: some View {
        HStack(spacing: GameResultInput.spacing) {
            ToggleButton(title: "Schneider", binding: $schneider, onAction: {checkGameConfiguration()})
            ToggleButton(title: "Schneider Angesagt", binding: $schneiderAnnounced, onAction: {checkGameConfiguration()})
        }
        .frame(height: rowHeight)
    }
    
    private var schwarzControls: some View {
        HStack(spacing: GameResultInput.spacing) {
            ToggleButton(title: "Schwarz", binding: $schwarz, onAction: {checkGameConfiguration()})
            ToggleButton(title: "Schwarz Angesagt", binding: $schwarzAnnounced, onAction: {checkGameConfiguration()})
        }
        .frame(height: rowHeight)
    }
    
    private var handOuvertControls: some View {
        HStack(spacing: GameResultInput.spacing) {
            ToggleButton(title: "Hand", binding: $hand, onAction: {checkGameConfiguration()})
            ToggleButton(title: "Ouvert", binding: $ouvert, onAction: {checkGameConfiguration()})
        }
        .frame(height: rowHeight)
    }
    
    private var contraControls: some View {
        HStack(spacing: GameResultInput.spacing) {
            ToggleButton(title: "Contra", binding: $contra, onAction: {checkGameConfiguration()})
            ToggleButton(title: "Re", binding: $re, onAction: {checkGameConfiguration()})
            ToggleButton(title: "Bock", binding: $bock, onAction: {checkGameConfiguration()})
        }
        .frame(height: rowHeight)
    }
    
    private var winLoseControls: some View {
        HStack(spacing: GameResultInput.spacing) {
            ToggleButton(title: "Won", binding: $win, match: true as Bool?, onAction: {checkGameConfiguration()})
            ToggleButton(title: "Lost", binding: $win, match: false as Bool?, onAction: {checkGameConfiguration()})
        }
        .frame(height: rowHeight)
    }
    
    private var playersControls: some View {
        HStack(spacing: GameResultInput.spacing) {
            ForEach(scoreboard.playersSorted) { player in
                ToggleButton(title: LocalizedStringKey(player.name!), binding: $player, match: player as Player?, onAction: {checkGameConfiguration()})
            }
        }
        .frame(height: rowHeight)
    }
}

struct GameResultInput_Previews: PreviewProvider {
    static var previews: some View {
//        GameResultInput(gameConfig: GameConfiguration(), players: AppState.preview.appData.scoreboards[0].players)
        GameResultInput(scoreboard: PersistenceController.preview.getAScoreboard_preview(), gameConfigurationCompletion: PassthroughSubject<Game, Never>())
    }
}
