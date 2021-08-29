//
//  DEPlayer.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 29.08.21.
//

import SwiftUI

struct DEPlayersList: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var showAddPlayer = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Player.name, ascending: true)],
        animation: .default)
    private var players: FetchedResults<Player>
    
    var body: some View {
        List {
            ForEach(players) { player in
                HStack(alignment: .center) {
                    if let iconName = player.iconName {
                        Image(systemName: iconName)
                            .imageScale(.large)
                    } else {
                        Image(systemName: "person.fill.turn.down")
                            .imageScale(.large)
                            .foregroundColor(Color.red)
                    }
                    
                    VStack(alignment: .leading) {
                        if let name = player.name {
                            Text(name)
                        } else {
                            Text("No name").italic()
                        }
                        if let createdOn = player.createdOn {
                            Text(createdOn, formatter: itemFormatter)
                        } else {
                            Text("No date").italic()
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
                    showAddPlayer = true
                }, label: {
                    Label("Add Item", systemImage: "plus")
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

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private struct AddPlayerView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var newPlayerName = ""
    @State private var newPlayerIconName = ""
    @Binding var showAddPlayer: Bool
    
    var body: some View {
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
                    .pickerStyle(WheelPickerStyle())
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

struct DEPlayersList_Previews: PreviewProvider {
    static var previews: some View {
        DEPlayersList()
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
