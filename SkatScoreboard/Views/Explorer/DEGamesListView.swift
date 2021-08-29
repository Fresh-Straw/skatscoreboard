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
    
    @State private var scoreboard: Scoreboard?
    
    @Binding var showAddGame: Bool
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Scoreboard.lastChangedOn, ascending: false)],
        animation: .default)
    private var scoreboards: FetchedResults<Scoreboard>
    
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
                }
                
                Section {
                    Button(action: {
                        withAnimation {
                            // TODO
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
