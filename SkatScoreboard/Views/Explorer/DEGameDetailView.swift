//
//  DEGameDetailView.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 29.08.21.
//

import SwiftUI

struct DEGameDetailView: View {
    var game: Game
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct DEGameDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DEGameDetailView(game: PersistenceController.preview.getAGame())
    }
}
