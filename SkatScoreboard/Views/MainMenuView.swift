//
//  MainView.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 30.08.21.
//

import SwiftUI

struct MainMenuView: View {
    @Binding var applicationState: ApplicationState
    
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
                        applicationState = .DataExplorer
                    }
                }) {
                    Image(systemName: "doc.badge.gearshape")
                        .imageScale(.medium)
                }
                Spacer()
                Button(action: {
                    withAnimation {
                        applicationState = .Settings
                    }
                }) {
                    Image(systemName: "gear")
                        .imageScale(.large)
                }
            }
        }
        .padding()
    }
    
    private var menu: some View {
        VStack(spacing: 20) {
            HStack(spacing: 20) {
                Button { } label: {
                    Text("New Scoreboard")
                        .multilineTextAlignment(.center)
                        .font(.body.bold())
                        .padding(5)
                        .frame(width: 150, height: 150)
                        .foregroundColor(Color.white)
                }
                .skatButtonStyle()
                Button { } label: {
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
        MainMenuView(applicationState: .constant(.MainMenu))
    }
}
