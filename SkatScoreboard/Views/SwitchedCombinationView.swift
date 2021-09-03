//
//  SwitchedCombination.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 30.08.21.
//

import SwiftUI

struct SwitchedCombinationView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var applicationState = ApplicationState.MainMenu
    
    var body: some View {
        ZStack {
            switch applicationState {
            case .DataExplorer:
                DEOverView(applicationState: $applicationState)
                    .environment(\.managedObjectContext, viewContext)
            case .MainMenu:
                MainMenuView(applicationState: $applicationState)
                    .transition(.scale.animation(.easeInOut))
            case .Settings:
                VStack {
                    Button(action: {
                        withAnimation {
                            applicationState = .MainMenu
                        }
                    }, label: {
                        Text("Back")
                    })
                    Text("Settings")
                }
                .transition(.opacity.animation(.easeInOut))
//            default:
//                Text("Unknown application state")
            }
        }
    }
}

struct SwitchedCombinationView_Previews: PreviewProvider {
    static var previews: some View {
        SwitchedCombinationView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
