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
        Form {
            Section(header: Text("Spieler")) {
                TextField("Name", text: $name)
            }
            Section(header: Text("Bild")) {
                Picker(selection: $iconName, label: Text("Piktogram"), content: {
                    ForEach(ICON_NAMES, id: \.self) { iconName in
                        Image(systemName: iconName)
                            .tag(iconName)
                    }
                })
                ColorPicker("Farbe", selection: $iconColor)
            }
        }
    }
}

struct CreatePlayerView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePlayerView()
    }
}
