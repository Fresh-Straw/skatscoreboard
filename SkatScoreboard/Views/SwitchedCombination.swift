//
//  SwitchedCombination.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 30.08.21.
//

import SwiftUI

struct SwitchedCombination: View {
    @State private var applicationState: ApplicationState = .MainMenu
    
    var body: some View {
        ZStack {
            switch applicationState {
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

struct SwitchedCombination_Previews: PreviewProvider {
    static var previews: some View {
        SwitchedCombination()
    }
}
