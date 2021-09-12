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
                .playersSorted
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
                let pointsText = points.points
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
        .padding(20)
    }
    
    private var background: some View {
        ZStack {
            ZStack {
                Color.listItemForeground
                
                // TODO for each player, create a blurred player-colored shape and set it
                // randomly on the card. So each card looks different, but always the same
                // when you reopen the list
                Capsule()
                    .frame(width: 300, height: 150)
                    .foregroundColor(.blue.opacity(0.2))
                    .offset(x: 100, y: 30)
                    .blur(radius: 14)
                
                Capsule()
                    .frame(width: 200, height: 150)
                    .foregroundColor(.yellow.opacity(0.2))
                    .offset(x: -120, y: -40)
                    .blur(radius: 8)
            }
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .padding(5)
            .shadow(radius: 5)

            
            GeometryReader { geo in
                Path { path in
                    path.move(to: CGPoint(x: 10, y: 58))
                    path.addLine(to: CGPoint(x: geo.size.width-10, y: 58))
                }
                .stroke(Color.listBackground, lineWidth: 1)
            }
        }
    }
    
    private var line: some View {
        VStack {
            Divider()
                .background(Color.yellow)
        }
        .padding()
    }
    
    var body: some View {
        ZStack(alignment:.topLeading) {
            background
            foreground
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
                .previewLayout(.fixed(width: 350, height: 150))
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
        .background(Color.listBackground)
    }
}
