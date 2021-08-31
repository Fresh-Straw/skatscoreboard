//
//  NSWSelectPlayersView.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 30.08.21.
//

import SwiftUI

struct NSWSelectPlayersView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Player.name, ascending: true)],
        animation: .default)
    private var allPlayers: FetchedResults<Player>
    
    @State private var selectedPlayers: [Player] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Mitspieler")
                .font(.title)
            
            HStack(alignment: .center, spacing: 20) {
                Spacer()
                ForEach(selectedPlayers) { player in
                    PlayerDisplay(player: player)
                }
                if selectedPlayers.count < 1 {
                    PlayerDisplay(playerName: "Spieler 1")
                }
                if selectedPlayers.count < 2 {
                    PlayerDisplay(playerName: "Spieler 2")
                }
                if selectedPlayers.count < 3 {
                    PlayerDisplay(playerName: "Spieler 3")
                }
                Spacer()
            }

            if selectedPlayers.count < 3 {
                Text("Wähle mindestens drei Spieler aus, die an dieser Runde teilnehmen.")
                    .transition(.opacity.animation(.easeInOut))
            } else {
                Text("Du kannst noch weitere Spieler zu dieser Skatrunde hinzufügen.")
                    .transition(.opacity.animation(.easeInOut))
            }
            ScrollView {
                LinesList(allPlayers.filter({!selectedPlayers.contains($0)}), itemWidth: 80, itemHeight: 120, spacing: 6, alignment: .leading, view: { p in PlayerDisplay(player: p)
                    .onTapGesture(perform: {
                        withAnimation(.easeInOut, { selectedPlayers.append(p) })
                    })
                })
            }
        }
    }
}

struct NSWSelectPlayersView_Previews: PreviewProvider {
    static var previews: some View {
        NSWSelectPlayersView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
