//
//  NewScoreboardView.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 31.08.21.
//

import SwiftUI
import CoreData
import Combine

struct NewScoreboardWizardView: View {
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
                    destination: NewScoreboardPointModelSelectionView(pointModelSelection: pointModelSelection)
                        .navigationTitle("Punktezählung"),
                    isActive: $step2Active,
                    label: {
                        EmptyView()
                    })
                NewScoreboardPlayerSelectionView(playerSelection: playerSelection)
                
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

struct NewScoreboardWizardView_Previews: PreviewProvider {
    static var previews: some View {
        NewScoreboardWizardView(scoreboardCreation: PassthroughSubject<Scoreboard?, Never>())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
