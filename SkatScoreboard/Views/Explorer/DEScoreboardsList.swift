//
//  DeScoreboardsList.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 29.08.21.
//

import SwiftUI

struct DEScoreboardsList: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var showAddScoreboard = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Scoreboard.createdOn, ascending: true)],
        animation: .default)
    private var scoreboards: FetchedResults<Scoreboard>
    
    var body: some View {
        List {
            ForEach(scoreboards) { scoreboard in
                VStack(alignment: .leading) {
                    if let lastChangedOn = scoreboard.lastChangedOn {
                        Text("Last changed on: \(lastChangedOn, formatter: itemFormatter)")
                    } else {
                        Text("No last changed date").italic()
                    }
                    if let createdOn = scoreboard.createdOn {
                        Text("Created on: \(createdOn, formatter: itemFormatter)")
                    } else {
                        Text("No creation date").italic()
                    }
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
            offsets.map { scoreboards[$0] }.forEach(viewContext.delete)
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
                            HStack {
                                if let iconName = player.iconName {
                                    Image(systemName: iconName)
                                }
                                if let name = player.name {
                                    Text(name)
                                } else {
                                    Text("NO NAME")
                                }
                            }.tag(player as Player?)
                        }
                    }
                    Picker(selection: $player2, label: Text("Player 2")) {
                        ForEach(players) { player in
                            HStack {
                                if let iconName = player.iconName {
                                    Image(systemName: iconName)
                                }
                                if let name = player.name {
                                    Text(name)
                                } else {
                                    Text("NO NAME")
                                }
                            }.tag(player as Player?)
                        }
                    }
                    Picker(selection: $player3, label: Text("Player 3")) {
                        ForEach(players) { player in
                            HStack {
                                if let iconName = player.iconName {
                                    Image(systemName: iconName)
                                }
                                if let name = player.name {
                                    Text(name)
                                } else {
                                    Text("NO NAME")
                                }
                            }.tag(player as Player?)
                        }
                    }
                    Picker(selection: $player4, label: Text("Player 4")) {
                        ForEach(players) { player in
                            HStack {
                                if let iconName = player.iconName {
                                    Image(systemName: iconName)
                                }
                                if let name = player.name {
                                    Text(name)
                                } else {
                                    Text("NO NAME")
                                }
                            }.tag(player as Player?)
                        }
                    }
                }
                
                Section {
                    Button(action: {
                        withAnimation {
                            let scoreboard = Scoreboard(context: viewContext)
                            scoreboard.createdOn = Date()
                            scoreboard.lastChangedOn = Date()
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

struct DEScoreboardsList_Previews: PreviewProvider {
    static var previews: some View {
        DEScoreboardsList()
        
        AddScoreboardView(showAddScoreboard: .constant(true))
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
