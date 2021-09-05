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

extension Scoreboard {
    func computePoints() -> [Player:Int] {
        // TODO compute points
        return getPlayers().reduce(into: [Player:Int]()) {
            $0[$1] = Int.random(in: -32..<128)
        }
    }
}

