//
//  NewScoreboardView.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 31.08.21.
//

import SwiftUI
import Combine

struct NewScoreboardView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var active1 = false
    
    private let playerSelection = PassthroughSubject<[Player]?, Never>()
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(
                    destination: NSWSelectGameTypeView(setter: {_ in})
                        .navigationTitle("Punktezählung"),
                    isActive: $active1,
                    label: {
                        EmptyView()
                    })
                NSWSelectPlayersView(playerSelection: playerSelection)
                
            }
            .padding()
            .navigationTitle("Mitspieler")
        }
    }
}

struct NewScoreboardView_Previews: PreviewProvider {
    static var previews: some View {
        NewScoreboardView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
