//
//  SkatScoreboardApp.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 28.08.21.
//

import SwiftUI

@main
struct SkatScoreboardApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
