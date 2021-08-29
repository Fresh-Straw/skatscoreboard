//
//  DEScoreboardDetail.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 29.08.21.
//

import SwiftUI

struct DEScoreboardDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var scoreboard: Scoreboard
    
    var body: some View {
        VStack(alignment: .leading) {
            Form {
                Section(header: Text("Dates")) {
                    if let createdOn = scoreboard.createdOn {
                        HStack {
                            Text("Created On: ").foregroundColor(.gray)
                            Spacer()
                            Text(createdOn, formatter: itemFormatter)
                        }
                    }
                    if let lastChangedOn = scoreboard.createdOn {
                        HStack {
                            Text("Last Changed On: ").foregroundColor(.gray)
                            Spacer()
                            Text(lastChangedOn, formatter: itemFormatter)
                        }
                    }
                }
                
                Section(header: Text("Players")) {
                    let players = scoreboard.getPlayers()
                    ForEach(players) { player in
                        NavigationLink(destination: DEPlayerDetailView(player: player)
                                        .navigationTitle(player.name ?? "Player")) {
                            DEPlayerRowView(player: player)
                        }
                    }
                    if players.isEmpty {
                        Text("No players in scoreboard").italic()
                    }
                }
                
                Section(header: Text("Games")) {
                    let games = (scoreboard.games as? Set<Game> ?? []).sorted {
                        if let co0 = $0.createdOn, let co1 = $1.createdOn {
                            return co0 < co1
                        } else {
                            return true
                        }
                    }
                    ForEach(games) { game in
                        DEGameRowView(game: game)
                    }
                }
            }
        }
    }
}

struct DEScoreboardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DEScoreboardDetailView(scoreboard: PersistenceController.preview.getAScoreboard())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
