//
//  NSBSelectGameTypeView.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 30.08.21.
//

import SwiftUI

struct NSWSelectGameTypeView: View {
    private let setter: (PointModel) -> ()
    
    init(setter: @escaping (PointModel) -> ()) {
        self.setter = setter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Nach welchem Modell sollen die Punkte im Spiel gezählt werden?")
            
            HStack(alignment: .center, spacing: 20) {
                Button {
                    setter(.leipzigerSkat)
                } label: {
                    Text("Leipziger Skat")
                        .bold()
                        .multilineTextAlignment(.center)
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color.white)
                }
                .skatButtonStyle()
                
                Button {
                    setter(.seegerFabian)
                } label: {
                    Text("Seeger/ Fabian")
                        .bold()
                        .multilineTextAlignment(.center)
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color.white)
                }
                .skatButtonStyle()
                
                Button {
                    setter(.bierlachs)
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

struct NSWSelectGameTypeView_Previews: PreviewProvider {
    static var previews: some View {
        NSWSelectGameTypeView(setter: {_ in})
    }
}
