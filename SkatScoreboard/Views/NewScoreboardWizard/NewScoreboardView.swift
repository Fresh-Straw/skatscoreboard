//
//  NewScoreboardView.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 31.08.21.
//

import SwiftUI

struct NewScoreboardView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var active1 = false
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(
                    destination: NSWSelectGameTypeView(setter: {_ in})
                        .navigationTitle("Punktezählung"),
                    isActive: $active1,
                    label: {
                        EmptyView()
                    })
                NSWSelectPlayersView()
                
                Button {
                    active1 = true
                } label: {
                    Text("Weiter")
                        .bold()
                        .multilineTextAlignment(.center)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color.white)
                }
                .skatButtonStyle()
            }
            .padding()
            .navigationTitle("Mitspieler")
        }
    }
}

struct NewScoreboardView_Previews: PreviewProvider {
    static var previews: some View {
        NewScoreboardView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
