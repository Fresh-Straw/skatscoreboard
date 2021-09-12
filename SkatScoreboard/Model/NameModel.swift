//
//  NameModel.swift
//  Skat Scoreboard
//
//  Created by Olaf Neumann on 19.02.21.
//

import Foundation
import SwiftUI

class NameModel {
    static var `default` = getNameModel(for: Locale.current)
    
    static func getNameModel(for locale: Locale) -> NameModel {
        return GermanDefaultNameModel()
    }
    
    func getName(for game: Gamish) -> LocalizedStringKey {
        LocalizedStringKey(getNameAsString(for: game))
    }
    
    func getNameAsString(for game: Gamish) -> String {
        fatalError("Implement getNameAsString(for:)")
    }
    func getNameAsString(for gameConfig: GameConfiguration) -> String {
        fatalError("Implement getNameAsString(for:)")
    }
    
    func getName(for gameType: GameType) -> LocalizedStringKey {
        fatalError("Implement getName(for:)")
    }
}

class GermanDefaultNameModel : NameModel {
    override func getNameAsString(for game: Gamish) -> String {
        "\(getSimpleName(for: game.type)) \(getAddition(ouvert: game.ouvert, hand: game.hand))"
    }
    
    override func getNameAsString(for gameConfig: GameConfiguration) -> String {
        "\(getSimpleName(for: gameConfig.gameType ?? .null)) \(getAddition(ouvert: gameConfig.ouvert, hand: gameConfig.hand))"
    }
    
    override func getName(for gameType: GameType) -> LocalizedStringKey {
        LocalizedStringKey(getSimpleName(for: gameType))
    }
    
    private func getSimpleName(for gameType: GameType) -> String {
        switch gameType {
        case .suitDiamonds: return "Karo"
        case .suitHearts: return "Herz"
        case .suitSpades: return "Pik"
        case .suitClubs: return "Kreuz"
        case .grand: return "Grand"
        case .null: return "Null"
//        case .junk: return "Ramsch"
        }
    }
    
    private func getAddition(ouvert: Bool, hand: Bool) -> String {
        let isIn = [ouvert, hand]
        let titles = ["Ouvert", "Hand"]
        return zip(isIn, titles).filter{$0.0}.map{$0.1}.joined(separator: " ")
    }
}
