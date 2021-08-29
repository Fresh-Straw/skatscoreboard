//
//  DEPlayer.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 29.08.21.
//

import SwiftUI

struct DEPlayersList: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var addPlayer = false
    @State private var newPlayerName = ""
    
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
                    newPlayerName = ""
                    addPlayer = true
                }, label: {
                    Label("Add Item", systemImage: "plus")
                })
            }
        }
        .sheet(isPresented: $addPlayer, content: {
            VStack {
                VStack(alignment: .leading) {
                    Text("New Player")
                        .font(.caption)
                    TextField("Player name", text: $newPlayerName)
                        .autocapitalization(.words)
                        .disableAutocorrection(true)
                }
                .padding(.bottom, 10)
                
                Button(action: {
                    let player = Player(context: viewContext)
                    player.createdOn = Date()
                    player.name = newPlayerName
                    PersistenceController.shared.save()
                    addPlayer = false
                }, label: {
                    Text("Save")
                })
                
                Spacer()
            }
            .padding()
        })
        
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

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

struct DEPlayersList_Previews: PreviewProvider {
    static var previews: some View {
        DEPlayersList()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
