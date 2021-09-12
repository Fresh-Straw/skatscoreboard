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
    func computePoints() -> [Player:Int] {
        // TODO compute points
        return playersSorted.reduce(into: [Player:Int]()) {
            $0[$1] = Int.random(in: -32..<128)
        }
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

