//
//  MainView.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 30.08.21.
//

import SwiftUI
import Combine

struct MainMenuView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    // @Binding var applicationState: ApplicationState
    let applicationState: CurrentValueSubject<ApplicationState, Never>
    
    @State private var showNewScoreboardSheet = false
    @State private var showContinueScoreboardSheet = false
    
    let scoreboardCreation = PassthroughSubject<Scoreboard?, Never>()
    let scoreboardSelection = PassthroughSubject<Scoreboard?, Never>()
    
    var body: some View {
        VStack {
            Spacer()
            menu
            Spacer()
            HStack {
                Text("Version \(Bundle.main.releaseVersionNumber) (build \(Bundle.main.buildVersionNumber))")
                Spacer()
                Button(action: {
                    withAnimation {
                        applicationState.send(.DataExplorer)
                    }
                }) {
                    Image(systemName: "doc.badge.gearshape")
                        .imageScale(.medium)
                }
                Spacer()
                Button(action: {
                    withAnimation {
                        applicationState.send(.Settings)
                    }
                }) {
                    Image(systemName: "gear")
                        .imageScale(.large)
                }
            }
        }
        .padding()
        .sheet(isPresented: $showNewScoreboardSheet, content: {
            NewScoreboardWizardView(scoreboardCreation: scoreboardCreation)
                .environment(\.managedObjectContext, viewContext)
        })
        .sheet(isPresented: $showContinueScoreboardSheet, content: {
            ExistingScoreboardWizard(scoreboardSelection: scoreboardSelection)
                .environment(\.managedObjectContext, viewContext)
        })
        .onReceive(scoreboardCreation, perform: { scoreboard in
            if let scoreboard = scoreboard {
                applicationState.send(.PlayScoreboard(scoreboard: scoreboard))
            }
            showNewScoreboardSheet = false
        })
        .onReceive(scoreboardSelection, perform: { scoreboard in
            if let scoreboard = scoreboard {
                applicationState.send(.PlayScoreboard(scoreboard: scoreboard))
            }
            showContinueScoreboardSheet = false
        })
    }
    
    private var menu: some View {
        VStack(spacing: 20) {
            HStack(spacing: 20) {
                Button {
                    showNewScoreboardSheet = true
                } label: {
                    Text("New Scoreboard")
                        .multilineTextAlignment(.center)
                        .font(.body.bold())
                        .padding(5)
                        .frame(width: 150, height: 150)
                        .foregroundColor(Color.white)
                }
                .skatButtonStyle()
                Button {
                    showContinueScoreboardSheet = true
                } label: {
                    Text("Continue Scoreboard")
                        .multilineTextAlignment(.center)
                        .font(.body.bold())
                        .padding(5)
                        .frame(width: 150, height: 150)
                        .foregroundColor(Color.white)
                }
                .skatButtonStyle()
            }
            HStack(spacing: 10) {
                Button { } label: {
                    Text("Statistics")
                        .multilineTextAlignment(.center)
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color.white)
                }
                .skatButtonStyle()
                Button { } label: {
                    Text("History")
                        .multilineTextAlignment(.center)
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color.white)
                }
                .skatButtonStyle()
                Button { } label: {
                    Text("Players")
                        .multilineTextAlignment(.center)
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color.white)
                }
                .skatButtonStyle()
            }
        }
    }
}

private extension Bundle {
    var releaseVersionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? "Preview"
    }
    var buildVersionNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? "X"
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView(applicationState: CurrentValueSubject<ApplicationState, Never>(.MainMenu))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
