//
//  ExistingScoreboardWizard.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 03.09.21.
//

import SwiftUI
import Combine

struct ExistingScoreboardWizard: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Scoreboard.lastChangedOn, ascending: false)],
        animation: .default)
    private var scoreboards: FetchedResults<Scoreboard>
    
    var scoreboardSelection: PassthroughSubject<Scoreboard?, Never>
    
    var body: some View {
        ZStack {
            Color.listBackground
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Wähle ein existierendes Scoreboard aus, um es anzusehen oder weiterzuspielen.")
                    .padding(.horizontal)

                ScrollView {
                    LazyVStack {
                        ForEach(scoreboards) { scoreboard in
                            ScoreboardRowView(scoreboard: scoreboard)
                                .padding(.horizontal)
                                .onTapGesture {
                                    scoreboardSelection.send(scoreboard)
                                }
                                .onLongPressGesture {
                                    print("start")
                                }
                        }
                    }
                }
            }
            .padding(.top)
        }
    }
}

struct ExistingScoreboardWizard_Previews: PreviewProvider {
    static var previews: some View {
        ExistingScoreboardWizard(scoreboardSelection: PassthroughSubject<Scoreboard?, Never>())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
