//
//  DEScoreboardRowView.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 29.08.21.
//

import SwiftUI

struct DEScoreboardRowView: View {
    var scoreboard: Scoreboard
    
    var body: some View {
        let players = scoreboard.getPlayers()
        VStack(alignment: .leading) {
            Text("Players: \(players.map({$0.name ?? "NO-NAME"}).joined(separator: ", "))")
            Text("Games: \(scoreboard.games?.count ?? 0)")
            if let lastChangedOn = scoreboard.lastChangedOn {
                Text("Last changed on: \(lastChangedOn, formatter: itemFormatter)")
                    .foregroundColor(.gray)
            } else {
                Text("No last changed date")
                    .italic()
                    .foregroundColor(.gray)
            }
            if let createdOn = scoreboard.createdOn {
                Text("Created on: \(createdOn, formatter: itemFormatter)")
                    .foregroundColor(.purple)
            } else {
                Text("No creation date")
                    .italic()
                    .foregroundColor(.purple)
            }
        }
    }
}

struct DEScoreboardRowView_Previews: PreviewProvider {
    static var previews: some View {
        DEScoreboardRowView(scoreboard: PersistenceController.preview.getAScoreboard_preview())
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
