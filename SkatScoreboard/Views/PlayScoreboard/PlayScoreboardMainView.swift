//
//  PlayScoreboardView.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 05.09.21.
//

import SwiftUI
import Combine

struct PlayScoreboardMainView: View {
    let applicationState: CurrentValueSubject<ApplicationState, Never>
    
    let scoreboard: Scoreboard
    
    @State private var showCloseScoreAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Hello, World!")
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        showCloseScoreAlert = true
                    } label: { Text("Beenden") }
                }
            }
            .alert(isPresented: $showCloseScoreAlert, content: {
                Alert.init(
                    title: Text("Spiel beenden?"),
                    primaryButton: Alert.Button.default(Text("Beenden"), action: { applicationState.send(.MainMenu) }),
                    secondaryButton: Alert.Button.cancel()
                )
            })
        }
    }
}

struct PlayScoreboardMainView_Previews: PreviewProvider {
    static var previews: some View {
        PlayScoreboardMainView(
            applicationState: CurrentValueSubject<ApplicationState, Never>(.MainMenu),
            scoreboard: PersistenceController.preview.getAScoreboard_preview()
        )
    }
}
