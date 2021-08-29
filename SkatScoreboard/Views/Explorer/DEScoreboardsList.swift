//
//  DeScoreboardsList.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 29.08.21.
//

import SwiftUI
import CoreData

struct DEScoreboardsList: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var showAddScoreboard = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Scoreboard.createdOn, ascending: false)],
        animation: .default)
    private var scoreboards: FetchedResults<Scoreboard>
    
    var body: some View {
        List {
            ForEach(scoreboards) { scoreboard in
                let players = scoreboard.getPlayers(context: viewContext)
                NavigationLink(
                    destination: DEScoreboardDetailView(scoreboard: scoreboard)
                        .navigationTitle("Scoreboard (\(players.count))")) {
                    VStack(alignment: .leading) {
                        Text("Players: \(players.map({$0.name ?? "NO-NAME"}).joined(separator: ", "))")
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
