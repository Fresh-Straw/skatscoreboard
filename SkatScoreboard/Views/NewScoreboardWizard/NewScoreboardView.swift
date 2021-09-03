//
//  NewScoreboardView.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 31.08.21.
//

import SwiftUI
import CoreData
import Combine

struct NewScoreboardView: View {
    @Environment(\.managedObjectContext) private var viewContext
        
    @State private var step2Active = false
    @State private var players: [Player] = []

    let scoreboardCreation: PassthroughSubject<Scoreboard?, Never>
    
    private let playerSelection = PassthroughSubject<[Player]?, Never>()
    private let pointModelSelection = PassthroughSubject<PointModel, Never>()
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(
                    destination: NSWSelectPointModelView(pointModelSelection: pointModelSelection)
                        .navigationTitle("Punktezählung"),
                    isActive: $step2Active,
                    label: {
                        EmptyView()
                    })
                NSWSelectPlayersView(playerSelection: playerSelection)
                
            }
            .padding()
            .navigationTitle("Mitspieler")
        }
        .onReceive(playerSelection, perform: { players in
            if let players = players {
                self.players = players
                step2Active = true
            } else {
                scoreboardCreation.send(nil)
            }
        })
        .onReceive(pointModelSelection, perform: { pointModel in
            let scoreboard = createScoreboard(viewContext, pointModel: pointModel, with: players)
            viewContext.save(onComplete: NSManagedObjectContext.defaultCompletionHandler)
            scoreboardCreation.send(scoreboard)
        })
    }
}

struct NewScoreboardView_Previews: PreviewProvider {
    static var previews: some View {
        NewScoreboardView(scoreboardCreation: PassthroughSubject<Scoreboard?, Never>())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
