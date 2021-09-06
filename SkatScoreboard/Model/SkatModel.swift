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
    case suitsClubs, suitsSpades, suitsHearts, suitsDiamonds, grand, null
    
    var imageSystemName: String {
        switch self {
        case .suitsClubs:
            return "suit.club.fill"
        case .suitsSpades:
            return "suit.spade.fill"
        case .suitsHearts:
            return "suit.heart.fill"
        case .suitsDiamonds:
            return "suit.diamond.fill"
        case .grand:
            return "star.fill"
        case .null:
            return "0.circle.fill"
        }
    }
    
    var displayName: String {
        switch self {
        case .suitsClubs:
            return "Kreuz"
        case .suitsSpades:
            return "Pik"
        case .suitsHearts:
            return "Herz"
        case .suitsDiamonds:
            return "Caro"
        case .grand:
            return "Grand"
        case .null:
            return "Null"
        }
    }
    
    var hasJacks: Bool {
        switch self {
        case .suitsClubs, .suitsSpades, .suitsHearts, .suitsDiamonds, .grand:
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
}

