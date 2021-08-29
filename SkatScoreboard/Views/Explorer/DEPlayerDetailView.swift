//
//  DEPlayerDetailView.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 29.08.21.
//

import SwiftUI

struct DEPlayerDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var player: Player
    
    var body: some View {
        Form {
            Section(header: Text("Name")) {
                if let name = player.name {
                    Text(name)
                } else {
                    Text("NO-NAME")
                        .italic()
                }
            }
            
            Section(header: Text("Scoreboards")) {
                let boards = player.getScoreboards()
                ForEach(boards) { board in
                    NavigationLink(destination: DEScoreboardDetailView(scoreboard: board)
                                    .navigationTitle("Scoreboard")) {
                        DEScoreboardRowView(scoreboard: board)
                    }
                }
            }
        }
    }
}

struct DEPlayerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DEPlayerDetailView(player: PersistenceController.preview.getAPlayer())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
