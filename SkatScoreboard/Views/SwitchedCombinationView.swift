//
//  SwitchedCombination.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 30.08.21.
//

import SwiftUI
import Combine

struct SwitchedCombinationView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var applicationState = ApplicationState.MainMenu
    private let applicationStateSubject = CurrentValueSubject<ApplicationState, Never>(ApplicationState.MainMenu)
    
    var body: some View {
        ZStack {
            switch applicationState {
            case .DataExplorer:
                DEOverView(applicationState: applicationStateSubject)
                    .transition(.opacity.animation(.easeInOut))
                    .environment(\.managedObjectContext, viewContext)
            case .MainMenu:
                MainMenuView(applicationState: applicationStateSubject)
                    .transition(.scale.animation(.easeInOut))
            case .PlayScoreboard(let scoreboard):
                PlayScoreboardMainView(applicationState: applicationStateSubject, scoreboard: scoreboard)
                    .transition(.slide.animation(.easeInOut))
            case .Settings:
                VStack {
                    Button(action: {
                        withAnimation {
                            applicationStateSubject.send(.MainMenu)
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
        .onReceive(applicationStateSubject, perform: { state in
            applicationState = state
        })
    }
}

struct SwitchedCombinationView_Previews: PreviewProvider {
    static var previews: some View {
        SwitchedCombinationView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
