//
//  DEGameDetailView.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 29.08.21.
//

import SwiftUI

struct DEGameDetailView: View {
    var game: Game
    
    var body: some View {
        Form {
            Section(header: Text("General")) {
                if let type = game.typeString {
                    Text(type)
                        .font(.title3)
                } else {
                    Text("NO-TYPE")
                        .foregroundColor(.red)
                }
                if let scoreboard = game.partOf {
                    NavigationLink(destination: DEScoreboardDetailView(scoreboard: scoreboard)
                                    .navigationTitle("Scoreboard")) {
                        DEScoreboardRowView(scoreboard: scoreboard)
                    }
                } else {
                    Text("NO-SCOREBOARD")
                        .foregroundColor(.red)
                }
                if let player = game.playedBy {
                    NavigationLink(destination: DEPlayerDetailView(player: player)
                                    .navigationTitle(player.name ?? "Player")) {
                        DEPlayerRowView(player: player)
                    }
                } else {
                    Text("NO-PLAYER")
                        .foregroundColor(.red)
                }
            }
            
            Section(header: Text("Settings")) {
                HStack {
                    if let jacks = game.jacks {
                        if jacks > 0 {
                            Text("Mit \(jacks)")
                        } else if jacks < 0 {
                            Text("Ohne \(-jacks)")
                        } else {
                            Text("Jacks-is-0").italic().foregroundColor(.red)
                        }
                    }
                }
                HStack {
                    Text("Won")
                        .foregroundColor(.gray)
                    Spacer()
                    if let value = game.won {
                        Text(value ? "yes" : "no")
                    }
                }
                HStack {
                    Text("Hand")
                        .foregroundColor(.gray)
                    Spacer()
                    if let value = game.hand {
                        Text(value ? "yes" : "no")
                    }
                }
                HStack {
                    Text("Ouvert")
                        .foregroundColor(.gray)
                    Spacer()
                    if let value = game.ouvert {
                        Text(value ? "yes" : "no")
                    }
                }
            }
            Section(header: Text("Ansagen")) {
                HStack {
                    Text("Schneider")
                        .foregroundColor(.gray)
                    Spacer()
                    if let value = game.schneider {
                        Text(value ? "yes" : "no")
                    }
                }
                HStack {
                    Text("Schneider angesagt")
                        .foregroundColor(.gray)
                    Spacer()
                    if let value = game.schneiderAnnounced {
                        Text(value ? "yes" : "no")
                    }
                }
                HStack {
                    Text("Schwarz")
                        .foregroundColor(.gray)
                    Spacer()
                    if let value = game.schwarz {
                        Text(value ? "yes" : "no")
                    }
                }
                HStack {
                    Text("Schwarz angesagt")
                        .foregroundColor(.gray)
                    Spacer()
                    if let value = game.schwarzAnnounced {
                        Text(value ? "yes" : "no")
                    }
                }
                HStack {
                    Text("Contra")
                        .foregroundColor(.gray)
                    Spacer()
                    if let value = game.contra {
                        Text(value ? "yes" : "no")
                    }
                }
                HStack {
                    Text("Re")
                        .foregroundColor(.gray)
                    Spacer()
                    if let value = game.re {
                        Text(value ? "yes" : "no")
                    }
                }
                HStack {
                    Text("Bock")
                        .foregroundColor(.gray)
                    Spacer()
                    if let value = game.bock {
                        Text(value ? "yes" : "no")
                    }
                }
            }
        }
    }
}

struct DEGameDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DEGameDetailView(game: PersistenceController.preview.getAGame_preview())
    }
}
