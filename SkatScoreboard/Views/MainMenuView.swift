//
//  MainView.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 30.08.21.
//

import SwiftUI

struct MainMenuView: View {
    @Binding var applicationState: ApplicationState
    @State private var isShowingRed = false
    
    var body: some View {
        VStack {
            Spacer()
            menu
            Spacer()
            HStack {
                Text("Version: 1.0")
                Spacer()
                Button(action: {
                    withAnimation {
                        applicationState = .Settings
                    }
                }, label: {
                    Image(systemName: "gear")
                })
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

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView(applicationState: .constant(.MainMenu))
    }
}
