//
//  CreatePlayerView.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 31.08.21.
//

import SwiftUI
import Combine
import CoreData

struct PlayerCreationView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var name: String = ""
    @State private var iconName: String = ICON_NAMES[0]
    @State private var iconColor: Color = Color.random()
    
    let playerCreation: PassthroughSubject<Player?, Never>
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Spieler")) {
                    TextField("Name", text: $name)
                        .autocapitalization(.words)
                        .disableAutocorrection(true)
                        .textContentType(/*@START_MENU_TOKEN@*/.name/*@END_MENU_TOKEN@*/)
                }
                Section(header: Text("Bild")) {
                    Picker(selection: $iconName, label: Text("Piktogram"), content: {
                        ForEach(ICON_NAMES, id: \.self) { iconName in
                            Image(systemName: iconName)
                                .imageScale(.large)
                                .tag(iconName)
                        }
                    })
                    ColorPicker("Farbe", selection: $iconColor)
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .cancellationAction, content: {
                    Button(action: {
                        playerCreation.send(nil)
                    }, label: {
                        Text("Abbrechen")
                    })
                })
                ToolbarItem(placement: .confirmationAction, content: {
                    Button(action: {
                        let player = SkatScoreboard.createPlayer(viewContext, name: name, iconName: iconName, color: iconColor)
                        viewContext.save(onComplete: NSManagedObjectContext.defaultCompletionHandler)
                        playerCreation.send(player)
                    }, label: {
                        Text("Speichern")
                    })
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).count == 0)
                })
            })
            .navigationTitle("Neuer Spieler")
        }
    }
}

struct PlayerCreationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PlayerCreationView(playerCreation: PassthroughSubject())
                .previewDisplayName("Light Mode")
            
            PlayerCreationView(playerCreation: PassthroughSubject())
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
        .previewLayout(.fixed(width: 400, height: 350))
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
