//
//  NSWSelectPlayersView.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 30.08.21.
//

import SwiftUI

struct NSWSelectPlayersView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Mitspieler")
                .font(.title)
            
            HStack(alignment: .center, spacing: 20) {
                Button {
                    
                } label: {
                    Text("Leipziger Skat")
                        .bold()
                        .multilineTextAlignment(.center)
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color.white)
                }
                .skatButtonStyle()
                
                Button {
                    
                } label: {
                    Text("Seeger/ Fabian")
                        .bold()
                        .multilineTextAlignment(.center)
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color.white)
                }
                .skatButtonStyle()
                
                Button {
                    
                } label: {
                    Text("Bierlachs")
                        .bold()
                        .multilineTextAlignment(.center)
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color.white)
                }
                .skatButtonStyle()
                
            }
        }
    }
}

struct NSWSelectPlayersView_Previews: PreviewProvider {
    static var previews: some View {
        NSWSelectPlayersView()
    }
}
