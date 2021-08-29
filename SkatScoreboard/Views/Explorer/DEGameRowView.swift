//
//  DEGameRowView.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 29.08.21.
//

import SwiftUI

struct DEGameRowView: View {
    var game: Game
    
    var body: some View {
        HStack {
            Text(game.type ?? "NOPE")
            Spacer()
            if let createdOn = game.createdOn {
                Text(createdOn, formatter: itemFormatter)
            }
        }
    }
}

struct DEGameRowView_Previews: PreviewProvider {
    static var previews: some View {
        DEGameRowView(game: PersistenceController.preview.getAGame())
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
