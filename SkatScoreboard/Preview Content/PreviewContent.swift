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
        // player.id = UUID()
        player.name = name
        player.iconName = Int.random(in: 1...2) == 1 ? "person.circle.fill" : "person.circle"
        return player
    }
    
    private func createScoreboard() -> Scoreboard {
        let scoreboard = Scoreboard(context: container.viewContext)
        scoreboard.createdOn = Date()
        scoreboard.lastChangedOn = Date()
        scoreboard.pointModel = "leipziger"
        return scoreboard
    }
    
    private func add(players: [Player], to scoreboard: Scoreboard) {
        players.forEach {
            let pis = PlayerInScoreboard(context: container.viewContext)
            let index: Int = players.firstIndex(of: $0) ?? 0
            pis.order = Int16(index)
            pis.player = $0
            pis.scoreboard = scoreboard
        }
    }
    
    func getAScoreboard() -> Scoreboard {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Scoreboard")
        fetch.fetchLimit = 1
        do {
            let scoreboards = try container.viewContext.fetch(fetch) as! [Scoreboard]
            return scoreboards[0]
        } catch {
            fatalError("No scoreboard available.")
        }
    }
    
    func getAPlayer() -> Player {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Player")
        fetch.fetchLimit = 1
        do {
            let players = try container.viewContext.fetch(fetch) as! [Player]
            return players[0]
        } catch {
            fatalError("No player available.")
        }
    }
    
    func getAGame() -> Game {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Game")
        fetch.fetchLimit = 1
        do {
            let games = try container.viewContext.fetch(fetch) as! [Game]
            return games[0]
        } catch {
            fatalError("No player available.")
        }
    }
    
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        // create some players
        let player1 = controller.createPlayer("Olaf")
        let player2 = controller.createPlayer("Selina")
        let player3 = controller.createPlayer("Jasmin")
        let player4 = controller.createPlayer("Tarzan")
        let player5 = controller.createPlayer("Jane")
        let player6 = controller.createPlayer("Mogli")
        
        let scoreboard1 = controller.createScoreboard()
        let scorebaord2 = controller.createScoreboard()
        
        controller.add(players: [player1, player2, player3], to: scoreboard1)
        controller.add(players: [player4, player5, player6], to: scorebaord2)

        controller.save { error in
            if let error = error {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        return controller
    }()
    
}
