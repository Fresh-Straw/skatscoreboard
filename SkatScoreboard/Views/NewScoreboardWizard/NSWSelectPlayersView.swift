//
//  NSWSelectPlayersView.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 30.08.21.
//

import SwiftUI

struct NSWSelectPlayersView: View {
    private static let MIN_PLAYER_COUNT = 3
    private static let MAX_PLAYER_COUNT = 4
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Player.name, ascending: true)],
        animation: .default)
    private var allPlayers: FetchedResults<Player>
    
    @State private var selectedPlayers: [Player?] = [nil, nil, nil]
    
    private var numberOfPlayers: Int {
        selectedPlayers.filter({$0 != nil}).count
    }
    
    private func add(player: Player) {
        if numberOfPlayers < NSWSelectPlayersView.MAX_PLAYER_COUNT {
            if let index = selectedPlayers.firstIndex(of: nil) {
                selectedPlayers.insert(player, at: index)
            } else {
                selectedPlayers.append(player)
            }
        }
        remove(player: nil)
    }
    
    private func remove(player: Player?) {
        if let index = selectedPlayers.firstIndex(of: player) {
            selectedPlayers.remove(at: index)
        }
        if selectedPlayers.count < NSWSelectPlayersView.MIN_PLAYER_COUNT {
            selectedPlayers.append(nil)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .center, spacing: 20) {
                LinesList(selectedPlayers, itemWidth: 80, itemHeight: 120, spacing: 4, alignment: .leading, view: { player in
                    PlayerDisplay(player: player)
                        .transition(.opacity.animation(.easeInOut))
                        .onTapGesture(perform: {
                            withAnimation(.easeInOut, {
                                remove(player: player)
                            })
                        })
                })
                .frame(maxWidth: .infinity, maxHeight: 120)
            }

            if numberOfPlayers < 3 {
                Text("Wähle mindestens drei Spieler aus, die an dieser Runde teilnehmen.")
                    .transition(.opacity.animation(.easeInOut))
            } else {
                Text("Du kannst noch weitere Spieler zu dieser Skatrunde hinzufügen.")
                    .transition(.opacity.animation(.easeInOut))
            }
            ScrollView {
                LinesList(allPlayers.filter({!selectedPlayers.contains($0)}), itemWidth: 80, itemHeight: 120, spacing: 4, alignment: .leading, view: { p in PlayerDisplay(player: p)
                        .transition(.opacity.animation(.easeInOut))
                        .onTapGesture(perform: {
                            withAnimation(.easeInOut, {
                                add(player: p)
                            })
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
