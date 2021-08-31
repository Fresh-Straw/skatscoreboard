//
//  CreatePlayerView.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 31.08.21.
//

import SwiftUI

struct CreatePlayerView: View {
    @State private var name: String = ""
    @State private var iconName: String = ICON_NAMES[0]
    @State private var iconColor: Color = Color.orange
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Spieler")) {
                    TextField("Name", text: $name)
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
                    Button(action: {}, label: {
                        Text("Abbrechen")
                    })
                })
                ToolbarItem(placement: .confirmationAction, content: {
                    Button(action: {}, label: {
                        Text("Speichern")
                    })
                })
            })
            .navigationTitle("Neuer Spieler")
        }
    }
}

struct CreatePlayerView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePlayerView()
    }
}
