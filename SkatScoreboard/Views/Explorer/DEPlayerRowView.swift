//
//  DEPlayerRowView.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 29.08.21.
//

import SwiftUI

struct DEPlayerRowView: View {
    var player: Player
    
    var body: some View {
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
                        .foregroundColor(.gray)
                } else {
                    Text("No date").italic()
                }
            }
        }
    }
}

struct DEPlayerRowView_Previews: PreviewProvider {
    static var previews: some View {
        DEPlayerRowView(player: PersistenceController.preview.getAPlayer_preview())
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
