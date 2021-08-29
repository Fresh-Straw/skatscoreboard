//
//  DEScoreboardDetail.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 29.08.21.
//

import SwiftUI

struct DEScoreboardDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var scoreboard: Scoreboard
    
    var body: some View {
        VStack(alignment: .leading) {
            
        }
    }
}

struct DEScoreboardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DEScoreboardDetailView(scoreboard: Scoreboard())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
