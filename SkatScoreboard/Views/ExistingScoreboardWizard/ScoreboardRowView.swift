//
//  ScoreboardRowView.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 03.09.21.
//

import SwiftUI

struct ScoreboardRowView: View {
    @Environment(\.colorScheme) var colorScheme

    let scoreboard: Scoreboard
    
    private var darkMode: Bool { colorScheme == .dark }
    
    private var foreground: some View {
        VStack(alignment: .leading, spacing: 10) {
            let title = scoreboard
                .getPlayers()
                .map { $0.name }
                .filter { $0 != nil }
                .map { $0! }
                .joined(separator: ", ")
            Text(title)
                .font(.title)
                .lineLimit(1)
                .allowsTightening(true)
                .truncationMode(.tail)
            
            HStack {
                let points = scoreboard.computePoints()
                let pointsText = points
                    .values
                    .map { String($0) }
                    .joined(separator: ", ")
                Text("Punkte: \(pointsText)")
                    .lineLimit(1)
                
                Spacer()
                
                Text("\(scoreboard.games?.count ?? 0) Spiel(e)")
            }
            
            if let date = scoreboard.lastChangedOn {
                Text(date, formatter: itemFormatter)
                    .font(.headline)
                    .opacity(0.7)
                    .padding(.top)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
        }
        .padding(18)
    }
    
    private var background: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(backgroundColor)
                //.shadow(color: backgroundColor.opacity(0.7), radius: 7)
                .padding(5)
            RoundedRectangle(cornerRadius: 20)
                .colorInvert()
                .shadow(color: shadowColor, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                .shadow(color: shadowColor, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                .shadow(color: shadowColor, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                .padding()
        }
    }
    
    var body: some View {
        ZStack(alignment:.topLeading) {
            background
            foreground
        }
    }
    
    private var shadowColor: Color {
        return darkMode ? Color.black : Color.white
    }
    
    private var backgroundColor: Color {
        // TODO make colors configurable via assets
        if darkMode {
            let clr = 0.25
            return Color(.sRGB, red: clr, green: clr, blue: clr, opacity: 1.0)
        } else {
            let clr = 0.9
            return Color(.sRGB, red: clr, green: clr, blue: clr, opacity: 1.0)
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .short
    return formatter
}()

struct ScoreboardRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ScoreboardRowView(scoreboard: PersistenceController.preview.getAScoreboard_preview())
                .previewLayout(.fixed(width: 400, height: 150))
                .previewDisplayName("Light mode")
                .preferredColorScheme(.light)

            ScoreboardRowView(scoreboard: PersistenceController.preview.getAScoreboard_preview())
                .previewLayout(.fixed(width: 400, height: 150))
                .previewDisplayName("Dark mode")
                .preferredColorScheme(.dark)

            ScoreboardRowView(scoreboard: PersistenceController.preview.getAScoreboard_preview())
                .previewLayout(.fixed(width: 150, height: 150))
                .previewDisplayName("Narrow")
                .preferredColorScheme(.light)
        }
        .background(Color(.sRGB, red: 0.9, green: 0.9, blue: 0.9, opacity: 1.0))
    }
}
