//
//  PointModel.swift
//  Skat Scoreboard
//
//  Created by Olaf Neumann on 08.02.21.
//

import Foundation

class PointModelCalculator {
    fileprivate static let leipzigerSkat: PointModelCalculator = LeipzigerSkatPointModelCalculator()

    static let `default`: PointModelCalculator = leipzigerSkat
    
    static func get(for model: PointModel) -> PointModelCalculator {
        switch model {
        case .leipzigerSkat:
            return PointModelCalculator.leipzigerSkat
        default:
            return PointModelCalculator.default
        }
    }
    
    func computePoints(for game: Game, players: [Player]) -> [Player:Int] {
        fatalError("Sub class did not overwrite 'computePoints'.")
    }
    
    func generateComputationSteps(for game: Gamish) -> [PointComputationStep] {
        fatalError("Sub class did not overwrite 'generateComputationSteps'.")
    }
    
    var type: PointModel {fatalError("Implement variable 'type'")}
    
    func getPoints(for type: GameType) -> Int {
        switch type {
        case .grand: return 24
        case .null: return 23
        // case .junk: return 20
        case .suitClubs: return 12
        case .suitSpades: return 11
        case .suitHearts: return 10
        case .suitDiamonds: return 9
        }
    }
    
    internal func numberOfYes(in game: Game) -> Int {
        [game.hand, game.ouvert, game.schneider, game.schneiderAnnounced, game.schwarz, game.schwarzAnnounced]
            .filter { $0 ?? false }
            .count
    }
    
    internal func numberOfAnnouncements(in game: Game) -> Int {
        [game.contra, game.re, game.bock].filter{$0}.count
    }
}

fileprivate class LeipzigerSkatPointModelCalculator: PointModelCalculator {
    override var type: PointModel { .leipzigerSkat }
    
    private func fill(points playerPoints: Int, forPlayer gamePlayer: Player, andForTheOthers otherPoints: Int, players: [Player]) -> [Player:Int] {
        return players.reduce([Player:Int](), { (dict,player) in
            var dict  = dict
            dict[player] = player == gamePlayer ? playerPoints : otherPoints
            return dict
        })
    }
    
    override func computePoints(for game: Game, players: [Player]) -> [Player:Int] {
        // TODO Null-Ouver-Hand nur 59 !!!
        // https://www.parlettgames.uk/skat/skatvary.html#top
        
        let base: Int
        var factor: Int = 1
        
        switch game.gameType {
//        case .junk:
//            return fill(points: -20, forPlayer: game.player, andForTheOthers: 0, players: players)
        case .null:
            if game.ouvert && game.hand {
                base = 59
            } else if game.ouvert && !game.hand {
                base = 46
            } else if game.hand && !game.ouvert {
                base = 35
            } else {
                base = 23
            }
        case .grand, .suitClubs, .suitSpades, .suitHearts, .suitDiamonds:
            base = getPoints(for: game.gameType)
            
            factor = Int(game.jacks) + 1
            factor += self.numberOfYes(in: game)
        }
        
        if !game.won {
            factor *= -2
        }
        let points: Int = (factor * base) * (2 ^^ numberOfAnnouncements(in: game))
        return fill(points: points, forPlayer: game.playedBy!, andForTheOthers: 0, players: players)
    }
    
    override func generateComputationSteps(for game: Gamish) -> [PointComputationStep] {
        var steps: [PointComputationStep] = []
        var multiplyByGame = false
        
        switch game.type {
//        case .junk:
//            return [PointComputationStep(title: "Ramsch", number: -20)]
        case .null:
            let gameName = NameModel.default.getNameAsString(for: game)
            if game.ouvert && game.hand {
                steps.append(PointComputationStep(title: gameName, number: 59))
            } else if game.ouvert && !game.hand {
                steps.append(PointComputationStep(title: gameName, number: 46))
            } else if game.hand && !game.ouvert {
                steps.append(PointComputationStep(title: gameName, number: 35))
            } else {
                steps.append(PointComputationStep(title: gameName, number: 23))
            }
        case .grand, .suitClubs, .suitSpades, .suitHearts, .suitDiamonds:
            steps.append(PointComputationStep(title: "Mit/ ohne \(game.numberOfJacks), Spiel", number: game.numberOfJacks + 1))
            multiplyByGame = true
            // Punkte
            if game.ouvert {
                steps.append(PointComputationStep(title: "Ouvert", number: steps[steps.count - 1].number + 1))
            }
            if game.hand {
                steps.append(PointComputationStep(title: "Hand", number: steps[steps.count - 1].number + 1))
            }
            if game.schneider {
                steps.append(PointComputationStep(title: "Schneider", number: steps[steps.count - 1].number + 1))
            }
            if game.schneiderAnnounced {
                steps.append(PointComputationStep(title: "Schneider angesagt", number: steps[steps.count - 1].number + 1))
            }
            if game.schwarz {
                steps.append(PointComputationStep(title: "Schwarz", number: steps[steps.count - 1].number + 1))
            }
            if game.schneiderAnnounced {
                steps.append(PointComputationStep(title: "Schwarz angesagt", number: steps[steps.count - 1].number + 1))
            }
        }
        
        if !game.won {
            steps.append(PointComputationStep(title: "Verloren", number: steps[steps.count - 1].number * -2))
        }

        // Verdoppelungen
        if game.contra {
            steps.append(PointComputationStep(title: "Contra", number: steps[steps.count - 1].number * 2))
        }
        if game.re {
            steps.append(PointComputationStep(title: "Re", number: steps[steps.count - 1].number * 2))
        }
        if game.bock {
            steps.append(PointComputationStep(title: "Back", number: steps[steps.count - 1].number * 2))
        }

        // Spiel
        if multiplyByGame {
            let base = getPoints(for: game.type)
            steps.append(PointComputationStep(title: "Mal \(game.type.rawValue)", number: steps[steps.count - 1].number * base))
        }

        return steps
    }
}

struct PointComputationStep {
    let title: String
    let number: Int
}

protocol Gamish {
    var playerOfGame: Player { get }
    var won: Bool { get }
    var type: GameType { get }
    var numberOfJacks: Int { get }
    var hand: Bool { get }
    var schneider: Bool { get }
    var schneiderAnnounced: Bool { get }
    var schwarz: Bool { get }
    var schwarzAnnounced: Bool { get }
    var ouvert: Bool { get }
    var contra: Bool { get }
    var re: Bool { get }
    var bock: Bool { get }
}

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ^^ : PowerPrecedence
func ^^ (radix: Int, power: Int) -> Int {
    return Int(pow(Double(radix), Double(power)))
}


