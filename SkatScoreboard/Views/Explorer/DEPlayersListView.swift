//
//  DEPlayer.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 29.08.21.
//

import SwiftUI

struct DEPlayersListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var showAddPlayer = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Player.name, ascending: true)],
        animation: .default)
    private var players: FetchedResults<Player>
    
    var body: some View {
        List {
            ForEach(players) { player in
                NavigationLink(
                    destination: DEPlayerDetailView(player: player)
                        .navigationTitle(player.name ?? "Player")) {
                    DEPlayerRowView(player: player)
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
                    showAddPlayer = true
                }, label: {
                    Label("Add Player", systemImage: "plus")
                })
            }
        }
        .sheet(isPresented: $showAddPlayer, content: {
            AddPlayerView(showAddPlayer: $showAddPlayer)
        })
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { players[$0] }.forEach(viewContext.delete)
            PersistenceController.shared.save()
        }
    }
}

private struct AddPlayerView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var newPlayerName = ""
    @State private var newPlayerIconName = ""
    @State private var newPlayerIconColor = Color.random()
    @Binding var showAddPlayer: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack(alignment: .leading) {
                        TextField("Player name", text: $newPlayerName)
                            .autocapitalization(.words)
                            .disableAutocorrection(true)
                    }
                    Picker(selection: $newPlayerIconName, label:
                            Text("Player Icon")
                           , content: {
                            //Text("").tag("")
                            Image(systemName: "suit.spade.fill")
                                .tag("suit.spade.fill")
                            Image(systemName: "hand.thumbsup.fill")
                                .tag("hand.thumbsup.fill")
                            Image(systemName: "figure.wave")
                                .tag("figure.wave")
                            Image(systemName: "square.circle.fill")
                                .tag("square.circle.fill")
                            Image(systemName: "bed.double.fill")
                                .tag("bed.double.fill")
                           })
                    ColorPicker("Player Icon Color", selection: $newPlayerIconColor)
                }
                
                Section {
                    Button(action: {
                        withAnimation {
                            let player = Player(context: viewContext)
                            player.createdOn = Date()
                            player.name = newPlayerName
                            if newPlayerIconName != "" {
                                player.iconName = newPlayerIconName
                            }
                            player.iconColor = newPlayerIconColor
                            PersistenceController.shared.save()
                            showAddPlayer = false
                        }
                    }, label: {
                        Text("Save")
                    })
                }
            }
            .navigationTitle("New Player")
        }
    }
}

struct DEPlayersListView_Previews: PreviewProvider {
    static var previews: some View {
        DEPlayersListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        
        AddPlayerView(showAddPlayer: .constant(true))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
