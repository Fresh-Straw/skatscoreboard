//
//  SkatModel.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 30.08.21.
//

import Foundation
import SwiftUI

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
    
    var color: Color {
        switch self {
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

