//
//  DEGamesListView.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 29.08.21.
//

import SwiftUI

struct DEGamesListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var showAddGame = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Game.createdOn, ascending: true)],
        animation: .default)
    private var games: FetchedResults<Game>
    
    var body: some View {
        List {
            ForEach(games) { game in
                NavigationLink(
                    destination: DEGameDetailView(game: game)
                        .navigationTitle(game.type ?? "Game")) {
                    DEGameRowView(game: game)
                }
            }
            .onDelete(perform: { indexSet in
                deleteItems(offsets: indexSet)
            })
        }
        .toolbar {
            HStack {
                #if os(iOS)
                EditButton()
                #endif

                Button(action: {
                    showAddGame = true
                }, label: {
                    Label("Add Player", systemImage: "plus")
                })
            }
        }
        .sheet(isPresented: $showAddGame, content: {
            AddGameView(showAddGame: $showAddGame)
        })
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { games[$0] }.forEach(viewContext.delete)
            PersistenceController.shared.save()
        }
    }
}

private struct AddGameView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var showAddGame: Bool
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Scoreboard.lastChangedOn, ascending: false)],
        animation: .default)
    private var scoreboards: FetchedResults<Scoreboard>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Player.name, ascending: true)],
        animation: .default)
    private var players: FetchedResults<Player>
    
    @State private var scoreboard: Scoreboard?
    @State private var player: Player?
    @State private var type: String = ""
    @State private var jacks: Float = 0
    @State private var won = false
    @State private var hand = false
    @State private var ouvert = false
    @State private var schneider = false
    @State private var schneiderAnnounced = false
    @State private var schwarz = false
    @State private var schwarzAnnounced = false
    @State private var contra = false
    @State private var re = false
    @State private var bock = false

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Scoreboard", selection: $scoreboard) {
                        ForEach(scoreboards) { scoreboard in
                            DEScoreboardRowView(scoreboard: scoreboard)
                                .tag(scoreboard as Scoreboard?)
                        }
                    }
                    Picker("Player", selection: $player) {
                        ForEach(players) { player in
                            DEPlayerRowView(player: player)
                                .tag(player as Player?)
                        }
                    }
                    TextField("Game type", text: $type)
                }
                
                Section(header: Text("Game stuff")) {
                    Slider(value: $jacks, in: -5...4, step: 1, onEditingChanged: {_ in })
                    Toggle("Won", isOn: $won)
                    Toggle("Hand", isOn: $hand)
                    Toggle("Ouvert", isOn: $ouvert)
                }
                
                Section(header: Text("Ansagen")) {
                    Toggle("Schneider", isOn: $schneider)
                    Toggle("Schneider angesagt", isOn: $schneiderAnnounced)
                    Toggle("Schwarz", isOn: $schwarz)
                    Toggle("Schwarz angesagt", isOn: $schwarzAnnounced)
                    Toggle("Contra", isOn: $contra)
                    Toggle("Re", isOn: $re)
                    Toggle("Bock", isOn: $bock)
                }

                Section {
                    Button(action: {
                        withAnimation {
                            let game = Game(context: viewContext)
                            game.playedBy = player
                            game.partOf = scoreboard
                            game.type = type
                            game.jacks = Int16(jacks)
                            game.won = won
                            game.hand = hand
                            game.ouvert = ouvert
                            game.schneider = schneider
                            game.schneiderAnnounced = schneiderAnnounced
                            game.schwarz = schwarz
                            game.schwarzAnnounced = schwarzAnnounced
                            game.contra = contra
                            game.re = re
                            game.bock = bock
                            PersistenceController.shared.save()
                            
                            showAddGame = false
                        }
                    }, label: {
                        Text("Save")
                    })
                }
            }
            .navigationTitle("New Game")
        }
    }
}
struct DEGamesListView_Previews: PreviewProvider {
    static var previews: some View {
        DEGamesListView()
    }
}
