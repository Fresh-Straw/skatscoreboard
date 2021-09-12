//
//  SkatModel.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 30.08.21.
//

import Foundation

enum PlayerRole: String {
    case dealer, listener, bidder, nextBidder
}

enum PointModel: String {
    case leipzigerSkat, seegerFabian, bierlachs
    
    var calculator: PointModelCalculator { PointModelCalculator.get(for: self) }
}

enum GameType: String, Identifiable, CaseIterable {
    case suitClubs, suitSpades, suitHearts, suitDiamonds, grand, null
    
    var imageSystemName: String {
        switch self {
        case .suitClubs:
            return "suit.club.fill"
        case .suitSpades:
            return "suit.spade.fill"
        case .suitHearts:
            return "suit.heart.fill"
        case .suitDiamonds:
            return "suit.diamond.fill"
        case .grand:
            return "star.fill"
        case .null:
            return "0.circle.fill"
        }
    }
    
    var displayName: String {
        switch self {
        case .suitClubs:
            return "Kreuz"
        case .suitSpades:
            return "Pik"
        case .suitHearts:
            return "Herz"
        case .suitDiamonds:
            return "Caro"
        case .grand:
            return "Grand"
        case .null:
            return "Null"
        }
    }
    
    var hasJacks: Bool {
        switch self {
        case .suitClubs, .suitSpades, .suitHearts, .suitDiamonds, .grand:
            return true
        default:
            return false
        }
    }
    
    var id: String { rawValue }
}

extension Scoreboard {
    func computePoints2() -> ScoreboardPoints {
        // TODO compute points
        return ScoreboardPoints(points: playersSorted.reduce(into: [Player:Int]()) {
            $0[$1] = Int.random(in: -32..<128)
        })
    }
    
    func computePoints() -> ScoreboardPoints {
        let calculator = pointModel.calculator
        let players = playersSorted
        let zeroPoints = ScoreboardPoints(players: players)
        if let games = games {
            return games
                .map { calculator.computePoints(for: $0 as! Game, players: players) }
                .reduce(into: zeroPoints) {
                    $0.add($1)
                }
        }
        return zeroPoints
    }
    
    var numberOfGames: Int {
        games?.count ?? 0
    }
    
    var giver: Player {
        let giverIndex = numberOfGames / (playersRaw?.count ?? 3)
        return playersSorted[giverIndex]
    }
    
    
    var possiblePlayers: [Player] {
        let players = playersSorted
        if players.count == 3 {
            return players
        }
        let giver = giver
        return players.filter { $0 != giver }
    }
}

struct GameConfig: Gamish {
    var playerOfGame: Player { player! }
    var player: Player?
    
    var won: Bool { win ?? false }
    var win: Bool?
    
    var type: GameType { gameType! }
    var gameType: GameType?
    
    var numberOfJacks: Int { jacks! }
    var jacks: Int?
    var hand: Bool = false
    var schneider: Bool = false
    var schneiderAnnounced: Bool = false
    var schwarz: Bool = false
    var schwarzAnnounced: Bool = false
    var ouvert: Bool = false
    
    private var contra_internal: Bool = false
    private var re_internal: Bool = false
    private var bock_internal: Bool = false
    
    var contra: Bool {
        get {
            contra_internal
        }
        set(newValue) {
            contra_internal = newValue
            re_internal = contra_internal && re_internal
            bock_internal = contra_internal && bock_internal
        }
    }
    var re: Bool {
        get {
            re_internal
        }
        set(newValue) {
            contra_internal = contra_internal || newValue
            re_internal = newValue
            bock_internal = newValue && bock_internal
        }
    }
    var bock: Bool {
        get {
            bock_internal
        }
        set(newValue) {
            contra_internal = contra_internal || newValue
            re_internal = re_internal || newValue
            bock_internal = newValue
        }
    }
    
    
    var isComplete: Bool {
        player != nil
            && gameType != nil
            && win != nil
            && (gameType == .null || jacks != nil)
//            && (gameType == .junk || win != nil)
//            && (gameType == .null || gameType == .junk || jacks != nil)
    }
}
