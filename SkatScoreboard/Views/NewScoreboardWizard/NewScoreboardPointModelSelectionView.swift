//
//  NSBSelectGameTypeView.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 30.08.21.
//

import SwiftUI
import Combine

struct NewScoreboardPointModelSelectionView: View {
    let pointModelSelection: PassthroughSubject<PointModel, Never>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Nach welchem Modell sollen die Punkte im Spiel gezählt werden?")
            
            HStack(alignment: .center, spacing: 20) {
                Button {
                    pointModelSelection.send(.leipzigerSkat)
                } label: {
                    Text("Leipziger Skat")
                        .bold()
                        .multilineTextAlignment(.center)
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color.white)
                }
                .skatButtonStyle()
                
                Button {
                    pointModelSelection.send(.seegerFabian)
                } label: {
                    Text("Seeger/ Fabian")
                        .bold()
                        .multilineTextAlignment(.center)
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color.white)
                }
                .skatButtonStyle()
                
                Button {
                    pointModelSelection.send(.bierlachs)
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

struct NewScoreboardPointModelSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NewScoreboardPointModelSelectionView(pointModelSelection: PassthroughSubject<PointModel, Never>())
    }
}
