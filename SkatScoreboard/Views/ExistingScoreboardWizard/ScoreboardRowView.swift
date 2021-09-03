//
//  ScoreboardRowView.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 03.09.21.
//

import SwiftUI

struct ScoreboardRowView: View {
    let scoreboard: Scoreboard
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ScoreboardRowView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreboardRowView(scoreboard: PersistenceController.preview.getAScoreboard_preview())
            .previewLayout(.fixed(width: 400, height: 150))
            .previewDisplayName("Light mode")
            .preferredColorScheme(.light)
        ScoreboardRowView(scoreboard: PersistenceController.preview.getAScoreboard_preview())
            .previewLayout(.fixed(width: 400, height: 150))
            .previewDisplayName("Dark mode")
            .preferredColorScheme(.dark)
    }
}
