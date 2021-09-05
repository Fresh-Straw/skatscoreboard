//
//  OverView.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 29.08.21.
//

import SwiftUI
import Combine

struct DEOverView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    let applicationState: CurrentValueSubject<ApplicationState, Never>
    
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
                    Button {
                        applicationState.send(.MainMenu)
                    } label: {
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
        DEOverView(applicationState: CurrentValueSubject<ApplicationState, Never>(.DataExplorer))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
