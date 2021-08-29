//
//  PreviewContent.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 29.08.21.
//

import Foundation
import CoreData

extension PersistenceController {
    
    private func createPlayer(_ name: String) -> Player {
        let player = Player(context: container.viewContext)
        player.createdOn = Date()
        player.name = name
        player.iconName = "asd"
        return player
    }
    
    private func createScoreboard() -> Scoreboard {
        let scoreboard = Scoreboard(context: container.viewContext)
        return scoreboard
    }
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // create items
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        
        // create some players
        let player1 = result.createPlayer("Olaf")
        let player2 = result.createPlayer("Selina")
        let player3 = result.createPlayer("Jasmin")
        let player4 = result.createPlayer("Tarzan")
        let player5 = result.createPlayer("Jane")
        
        let scoreboard = result.createScoreboard()

        result.save { error in
            if let error = error {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        return result
    }()
    
}
