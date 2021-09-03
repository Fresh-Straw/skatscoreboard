//
//  NSWSelectPlayersView.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 30.08.21.
//

import SwiftUI
import Combine

struct NSWSelectPlayersView: View {
    private static let MIN_PLAYER_COUNT = 3
    private static let MAX_PLAYER_COUNT = 4
    
    @Environment(\.managedObjectContext) private var viewContext
    
    private let playerCreation = PassthroughSubject<Player?, Never>()
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Player.name, ascending: true)],
        animation: .default)
    private var allPlayers: FetchedResults<Player>
    
    let playerSelection: PassthroughSubject<[Player]?, Never>
    
    @State private var selectedPlayers: [Player?] = [nil, nil, nil]
    @State private var showAddPlayer = false
    
    private var numberOfPlayers: Int {
        selectedPlayers.filter({$0 != nil}).count
    }
    
    private var canAddMorePlayers: Bool {
        numberOfPlayers < 4
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
    
    private var selectedPlayersToShow: [DisplayItemType] {
        return (0..<selectedPlayers.count)
            .map { index -> DisplayItemType in
                let item = selectedPlayers[index]
                if item != nil {
                    return DisplayItemType.player(player: item!)
                } else {
                    return DisplayItemType.emptyPlayers[index]
                }
            }
    }
    
    private var selectablePlayers: [DisplayItemType] {
        return [DisplayItemType.addButton]
            + allPlayers
            .filter { !selectedPlayers.contains($0) }
            .map { DisplayItemType.player(player: $0) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Spacer()
                ForEach(selectedPlayersToShow) { dit in
                    switch dit {
                    case .player(let player):
                        PlayerDisplay(player: player)
                            .transition(.opacity.animation(.easeInOut))
                            .onTapGesture(perform: {
                                withAnimation(.easeInOut, {
                                    remove(player: player)
                                })
                            })
                    case .emptyPlayer:
                        PlayerDisplay()
                            .transition(.opacity.animation(.easeInOut))
                    default:
                        Text("nothing")
                    }
                }
                Spacer()
            }
            
            if numberOfPlayers < 3 {
                Text("Wähle mindestens drei Spieler aus, die an dieser Runde teilnehmen.")
                    .transition(.opacity.animation(.easeInOut))
            } else if numberOfPlayers == 3 {
                Text("Du kannst noch einen weiteren Spieler zu dieser Skatrunde hinzufügen.")
                    .transition(.opacity.animation(.easeInOut))
            } else {
                Text("Mehr als vier Spieler können nicht zu einer Skatrunde hinzugefügt werden.")
                    .transition(.opacity.animation(.easeInOut))
            }
            ScrollView {
                LinesList(selectablePlayers, itemWidth: 80, itemHeight: 120, spacing: 4, alignment: .leading) { dit in
                    switch dit {
                    case .addButton:
                        VStack(alignment: .center) {
                            Image(systemName: "plus.circle")
                                .imageScale(.large)
                            Text("Neu")
                        }
                        .onTapGesture {
                            showAddPlayer = true
                        }
                    case .player(let player):
                        PlayerDisplay(player: player)
                            .opacity(canAddMorePlayers ? 1 : 0.4)
                            .transition(.opacity.animation(.easeInOut))
                            .onTapGesture(perform: {
                                withAnimation(.easeInOut, {
                                    add(player: player)
                                })
                            })
                    case .emptyPlayer:
                        PlayerDisplay()
                            .transition(.opacity.animation(.easeInOut))
                    }
                }
            }
            
            Button {
                let players = selectedPlayers
                    .filter { $0 != nil }
                    .map { $0! }
                playerSelection.send(players)
            } label: {
                Text("Weiter")
                    .bold()
                    .multilineTextAlignment(.center)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color.white)
            }
            .skatButtonStyle()
            .disabled(numberOfPlayers < 3)
        }
        .onReceive(playerCreation, perform: { player in
            showAddPlayer = false
        })
        .sheet(isPresented: $showAddPlayer) {
            PlayerCreationView(playerCreation: playerCreation)
        }
    }
}

private enum DisplayItemType : Identifiable {
    case addButton, player(player: Player), emptyPlayer(id: ObjectIdentifier)
    
    private static let addButtonId = ObjectIdentifier(NSString(string: UUID().uuidString))
    private static let emptyPlayerIds = [ObjectIdentifier(NSString(string: UUID().uuidString)), ObjectIdentifier(NSString(string: UUID().uuidString)), ObjectIdentifier(NSString(string: UUID().uuidString))]
    static let emptyPlayers = emptyPlayerIds.map({ DisplayItemType.emptyPlayer(id: $0) })
    
    var id: ObjectIdentifier {
        switch self {
        case .addButton:
            return DisplayItemType.addButtonId
        case .emptyPlayer(let id):
            return id
        case .player(let player):
            return player.id
        }
    }
}

struct NSWSelectPlayersView_Previews: PreviewProvider {
    static var previews: some View {
        NSWSelectPlayersView(playerSelection: PassthroughSubject<[Player]?, Never>())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
