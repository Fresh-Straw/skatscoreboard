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
//    func computePoints() -> [Player:Int] {
//        PointModelCalculator.default.
//        // TODO compute points
//        return playersSorted.reduce(into: [Player:Int]()) {
//            $0[$1] = Int.random(in: -32..<128)
//        }
//    }
    
    func computePoints() -> [Player:Int] {
        let calculator = pointModel.calculator
        let players = playersSorted
        var playerPoints = map(players, to: 0)
        if let games = games {
            for case let game as Game in games {
                let points = calculator.computePoints(for: game, players: players)
                points.forEach { (player, points) in
                    playerPoints[player]! += points
                }
            }
        }
        return playerPoints
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


final class GameConfiguration: ObservableObject, Gamish {
    var playerOfGame: Player { player! }
    var won: Bool { win! }
    var type: GameType { gameType! }
    var numberOfJacks: Int { jacks! }
    
    @Published var player: Player? = nil
    @Published var win: Bool?
    @Published var gameType: GameType? = nil {
        didSet {
            reset()
        }
    }
    @Published var jacks: Int?
    @Published var hand: Bool = false
    @Published var schneider: Bool = false {
        didSet {
            let newSchneiderAnnounced = schneiderAnnounced && schneider
            if newSchneiderAnnounced != schneiderAnnounced {
                schneiderAnnounced = newSchneiderAnnounced
            }
        }
    }
    @Published var schneiderAnnounced: Bool = false {
        didSet {
            let newSchneider = schneider || schneiderAnnounced
            if newSchneider != schneider {
                schneider = newSchneider
            }
        }
    }
    @Published var schwarz: Bool = false {
        didSet {
            let newSchwarzAnnounced = schwarzAnnounced && schwarz
            if newSchwarzAnnounced != schwarzAnnounced {
                schwarzAnnounced = newSchwarzAnnounced
            }
        }
    }
    @Published var schwarzAnnounced: Bool = false {
        didSet {
            let newSchwarz = schwarz || schwarzAnnounced
            if newSchwarz != schwarz {
                schwarz = newSchwarz
            }
        }
    }
    @Published var ouvert: Bool = false
    
    @Published var contra: Bool = false {
        didSet {
            if !contra {
                re = false
                bock = false
            }
        }
    }
    @Published var re: Bool = false {
        didSet {
            if re {
                contra = true
            } else {
                bock = false
            }
        }
    }
    @Published var bock: Bool = false {
        didSet {
            if bock {
                contra = true
                re = true
            }
        }
    }
    
    init() {
        // leave everything nil
    }
    
//    init(fromGame game: Game) {
//        self.player = game.player
//        self.win = game.win
//        self.gameType = game.type
//        self.jacks = game.matadorsJackStraight ?? 1
//        self.hand = game.hand
//        self.schneider = game.schneider
//        self.schneiderAnnounced = game.schneiderAnnounced
//        self.schwarz = game.schwarz
//        self.schwarzAnnounced = game.schwarzAnnounced
//        self.ouvert = game.ouvert
//        self.contra = game.announcedContra
//        self.re = game.announcedRe
//        self.bock = game.announcedBock
//    }
    
    private func reset() {
        hand = false
        ouvert = false
        jacks = nil
        schneider = false
        schwarz = false
        contra = false
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
