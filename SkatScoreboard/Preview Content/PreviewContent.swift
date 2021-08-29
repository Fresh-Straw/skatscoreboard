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
    
    private func addGame(to scoreboard: Scoreboard, forOnOf players: [Player]) {
        let game = Game(context: container.viewContext)
        game.type = "Grand"
        game.createdOn = Date()
        game.partOf = scoreboard
        game.playedBy = players[Int.random(in: 0..<players.count)]
        game.bock = Bool.random()
        game.contra = Bool.random()
        game.hand = Bool.random()
        game.re = Bool.random()
        game.schneider = Bool.random()
        game.schneiderAnnounced = Bool.random()
        game.schwarz = Bool.random()
        game.schwarzAnnounced = Bool.random()
        game.won = Bool.random()
    }
    
    private func get<T>(a entityName: String) -> T {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.fetchLimit = 1
        do {
            let items = try container.viewContext.fetch(request) as! [T]
            return items[0]
        } catch {
            fatalError("No \(entityName) available.")
        }
    }
    
    func getAScoreboard_preview() -> Scoreboard {
        get(a: "Scoreboard")
    }
    
    func getAPlayer_preview() -> Player {
        get(a: "Player")
    }
    
    func getAGame_preview() -> Game {
        get(a: "Game")
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
        let scoreboard2 = controller.createScoreboard()
        
        let players1 = [player1, player2, player3]
        let players2 = [player4, player5, player6]
        controller.add(players: players1, to: scoreboard1)
        controller.add(players: players2, to: scoreboard2)
        
        (1...7).forEach { _ in
            controller.addGame(to: scoreboard1, forOnOf: players1)
        }
        (1...2).forEach { _ in
            controller.addGame(to: scoreboard2, forOnOf: players2)
        }


        controller.save { error in
            if let error = error {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        return controller
    }()
    
}
