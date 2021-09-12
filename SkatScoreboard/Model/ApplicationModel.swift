//
//  ApplicationModel.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 30.08.21.
//

import Foundation
import CoreData
import SwiftUI

enum ApplicationState {
    case MainMenu,
         PlayScoreboard(scoreboard: Scoreboard),
         Settings,
         DataExplorer
}

let ICON_NAMES: [String] = [
    "suit.spade.fill",
    "hand.thumbsup.fill",
    "figure.wave",
    "square.circle.fill",
    "bed.double.fill",
]

func createPlayer(_ context: NSManagedObjectContext, name: String, iconName: String, color: Color) -> Player {
    let player = Player(context: context)
    player.createdOn = Date()
    player.name = name
    player.iconName = iconName
    player.iconColor = color
    return player
}

func createScoreboard(_ context: NSManagedObjectContext, pointModel: PointModel, with players: [Player] = []) -> Scoreboard {
    let scoreboard = Scoreboard(context: context)
    scoreboard.createdOn = Date()
    scoreboard.lastChangedOn = Date()
    scoreboard.pointModel = pointModel
    
    add(context, players: players, to: scoreboard)
    
    return scoreboard
}

func createGame(_ context: NSManagedObjectContext, in scoreboard: Scoreboard, gameConfig: GameConfig) -> Game {
    let game = Game(context: context)
    game.partOf = scoreboard
    game.playedBy = gameConfig.player
    
    game.gameType = gameConfig.type
    game.jacks = Int16(gameConfig.jacks ?? 0)
    game.hand = gameConfig.hand
    game.ouvert = gameConfig.ouvert
    game.schneider = gameConfig.schneider
    game.schneiderAnnounced = gameConfig.schneiderAnnounced
    game.schwarz = gameConfig.schwarz
    game.schwarzAnnounced = gameConfig.schwarzAnnounced
    
    game.contra = gameConfig.contra
    game.re = gameConfig.re
    game.bock = gameConfig.bock
    
    game.won = gameConfig.won
    
    return game
}

private func add(_ context: NSManagedObjectContext, players: [Player], to scoreboard: Scoreboard) {
    players.forEach {
        let pis = PlayerInScoreboard(context: context)
        let index: Int = players.firstIndex(of: $0) ?? 0
        pis.order = Int16(index)
        pis.player = $0
        pis.scoreboard = scoreboard
    }
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
