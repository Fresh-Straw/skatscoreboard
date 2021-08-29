//
//  DeScoreboardsList.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 29.08.21.
//

import SwiftUI
import CoreData

struct DEScoreboardsListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var showAddScoreboard = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Scoreboard.createdOn, ascending: false)],
        animation: .default)
    private var scoreboards: FetchedResults<Scoreboard>
    
    var body: some View {
        List {
            ForEach(scoreboards) { scoreboard in
                NavigationLink(
                    destination: DEScoreboardDetailView(scoreboard: scoreboard)
                        .navigationTitle("Scoreboard")) {
                    DEScoreboardRowView(scoreboard: scoreboard)
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
                    showAddScoreboard = true
                }, label: {
                    Label("Add Scoreboard", systemImage: "plus")
                })
            }
        }
        .sheet(isPresented: $showAddScoreboard, content: {
            AddScoreboardView(showAddScoreboard: $showAddScoreboard)
        })
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { scoreboards[$0] }.forEach( { scoreboard in
                let pisFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "PlayerInScoreboard")
                pisFetch.predicate = NSPredicate(format: "scoreboard = %@", scoreboard)
                do {
                    let pisses = try viewContext.fetch(pisFetch) as! [PlayerInScoreboard]
                    pisses.forEach(viewContext.delete)
                } catch {
                    // TODO
                }
                viewContext.delete(scoreboard)
            })
            PersistenceController.shared.save()
        }
    }
}

private struct AddScoreboardView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var showAddScoreboard: Bool
    
    @State private var player1: Player? = nil
    @State private var player2: Player? = nil
    @State private var player3: Player? = nil
    @State private var player4: Player? = nil
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Player.name, ascending: true)],
        animation: .default)
    private var players: FetchedResults<Player>

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Players")) {
                    Picker(selection: $player1, label: Text("Player 1")) {
                        ForEach(players) { player in
                            DEPlayerRowView(player: player)
                                .tag(player as Player?)
                        }
                    }
                    Picker(selection: $player2, label: Text("Player 2")) {
                        ForEach(players) { player in
                            DEPlayerRowView(player: player)
                                .tag(player as Player?)
                        }
                    }
                    Picker(selection: $player3, label: Text("Player 3")) {
                        ForEach(players) { player in
                            DEPlayerRowView(player: player)
                                .tag(player as Player?)
                        }
                    }
                    Picker(selection: $player4, label: Text("Player 4")) {
                        ForEach(players) { player in
                            DEPlayerRowView(player: player)
                                .tag(player as Player?)
                        }
                    }
                }
                
                Section {
                    Button(action: {
                        withAnimation {
                            let scoreboard = Scoreboard(context: viewContext)
                            scoreboard.createdOn = Date()
                            scoreboard.lastChangedOn = Date()
                            
                            if let player = player1 {
                                let pis = PlayerInScoreboard(context: viewContext)
                                pis.order = 1
                                pis.player = player
                                pis.scoreboard = scoreboard
                            }
                            
                            if let player = player2 {
                                let pis = PlayerInScoreboard(context: viewContext)
                                pis.order = 2
                                pis.player = player
                                pis.scoreboard = scoreboard
                            }
                            
                            if let player = player3 {
                                let pis = PlayerInScoreboard(context: viewContext)
                                pis.order = 3
                                pis.player = player
                                pis.scoreboard = scoreboard
                            }
                            
                            if let player = player4 {
                                let pis = PlayerInScoreboard(context: viewContext)
                                pis.order = 4
                                pis.player = player
                                pis.scoreboard = scoreboard
                            }

                            PersistenceController.shared.save()
                            showAddScoreboard = false
                        }
                    }, label: {
                        Text("Save")
                    })
                }
            }
            .navigationTitle("New Scoreboard")
        }
    }
}

struct DEScoreboardsListView_Previews: PreviewProvider {
    static var previews: some View {
        DEScoreboardsListView()
        
        AddScoreboardView(showAddScoreboard: .constant(true))
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
