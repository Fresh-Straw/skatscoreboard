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
        NavigationView {
            List {
                NavigationLink(destination: DEPlayersListView()
                                .navigationTitle("Players")
                                .environment(\.managedObjectContext, viewContext)) {
                    Text("Players")
                }
                NavigationLink(destination: DEScoreboardsListView()
                                .navigationTitle("Scoreboards")
                                .environment(\.managedObjectContext, viewContext)) {
                    Text("Scoreboards")
                }
                NavigationLink(destination: DEGamesListView()
                                .navigationTitle("Games")
                                .environment(\.managedObjectContext, viewContext)) {
                    Text("Games")
                }
            }
            .navigationTitle("Data Explorer")
        }
        .listStyle(SidebarListStyle())
    }
}

struct DEOverView_Previews: PreviewProvider {
    static var previews: some View {
        DEOverView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
