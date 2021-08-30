//
//  OverView.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 29.08.21.
//

import SwiftUI

struct DEOverView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var applicationState: ApplicationState
    
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
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button { applicationState = .MainMenu } label: {
                        ExitButtonView()
                    }
                    .frame(width: 24, height: 24)
                }
            }
        }
        .listStyle(SidebarListStyle())
    }
}

struct DEOverView_Previews: PreviewProvider {
    static var previews: some View {
        DEOverView(applicationState: .constant(.DataExplorer))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
