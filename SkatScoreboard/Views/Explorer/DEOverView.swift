//
//  OverView.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 29.08.21.
//

import SwiftUI

struct DEOverView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        List {
            NavigationLink(destination: DEPlayersList()
                            .navigationTitle("Players")
                            .environment(\.managedObjectContext, viewContext)) {
                Text("Players")
            }
            NavigationLink(destination: DEScoreboardsList()
                            .navigationTitle("Scoreboards")
                            .environment(\.managedObjectContext, viewContext)) {
                Text("Scoreboards")
            }
        }
        .navigationTitle("Data Explorer")
    }
}

struct DEOverView_Previews: PreviewProvider {
    static var previews: some View {
        DEOverView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
