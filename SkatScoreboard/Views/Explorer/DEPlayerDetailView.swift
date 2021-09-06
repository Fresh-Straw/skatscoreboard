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
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Game.createdOn, ascending: false)],
        // predicate: NSPredicate(format: "playedBy = %@", [player]),
        animation: .default)
    private var games: FetchedResults<Game>

    
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
                let boards = player.scoreboards
                ForEach(boards) { board in
                    NavigationLink(destination: DEScoreboardDetailView(scoreboard: board)
                                    .navigationTitle("Scoreboard")) {
                        DEScoreboardRowView(scoreboard: board)
                    }
                }
            }
            
            Section(header: Text("Games")) {
                ForEach(games) { game in
                    if player == game.playedBy {
                        // TODO filter another way
                        NavigationLink(destination: DEGameDetailView(game: game)
                                        .navigationTitle(game.type ?? "Game")) {
                            DEGameRowView(game: game)
                        }
                    }
                }
            }
        }
    }
}

struct DEPlayerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DEPlayerDetailView(player: PersistenceController.preview.getAPlayer_preview())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
