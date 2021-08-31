//
//  PlayersList.swift
//  Skat Scoreboard
//
//  Created by Olaf Neumann on 10.03.21.
//

import SwiftUI

struct LinesList<Item, Display: View>: View {
    private let items: [Item]
    private let views: [Display]
    private let itemWidth: CGFloat
    private let itemHeight : CGFloat
    private let spacing: Int
    private let alignment: HorizontalAlignment
    
    init(_ items: [Item], itemWidth: CGFloat = 80, itemHeight: CGFloat = 120, spacing: Int = 6 , alignment: HorizontalAlignment = .leading, @ViewBuilder view: (Item) -> Display) {
        self.items = items
        self.itemWidth = itemWidth
        self.itemHeight = itemHeight
        self.spacing = spacing
        self.alignment = alignment
        self.views = items.map { view($0) }
    }
    
    var body: some View {
        GeometryReader { geoProxy in
            let containerWidth = geoProxy.size.width
            let computedItemWidth: CGFloat = itemWidth + CGFloat(spacing)
            let itemsPerRow: Int = Int(floor(containerWidth / computedItemWidth))
            let numberOfRows: Int = itemsPerRow > 0 ? Int((CGFloat(items.count) / CGFloat(itemsPerRow)).rounded(.up)) : 0
            let usedWidth: CGFloat = computedItemWidth * CGFloat(itemsPerRow)
            let unusedWidth: CGFloat = containerWidth - usedWidth
            let horizontalPadding: CGFloat = unusedWidth / 2
            
            VStack(alignment: alignment, spacing: CGFloat(spacing)) {
                ForEach(0..<numberOfRows, id: \.self) { rowIndex in
                    HStack(spacing: CGFloat(spacing)) {
                        ForEach(0..<itemsPerRow, id: \.self) { columnIndex in
                            let itemIndex = rowIndex * itemsPerRow + columnIndex
                            if items.count > itemIndex {
                                views[itemIndex]
                                    .frame(width: itemWidth, height: itemHeight)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, horizontalPadding)
        }
    }
}

struct LinesList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LinesList(PersistenceController.preview.listPlayers_preview(), itemWidth: 80, itemHeight: 120, spacing: 6, alignment: .leading, view: { PlayerDisplay(player: $0)
            })
            .previewLayout(.fixed(width: 400, height: 200))
            LinesList(PersistenceController.preview.listPlayers_preview(), itemWidth: 80, itemHeight: 120, spacing: 6, alignment: .leading, view: { PlayerDisplay(player: $0)
            })
            .previewLayout(.fixed(width: 300, height: 200))
            LinesList(PersistenceController.preview.listPlayers_preview(), itemWidth: 80, itemHeight: 120, spacing: 6, alignment: .leading, view: { PlayerDisplay(player: $0)
            })
            .previewLayout(.fixed(width: 200, height: 200))
        }
    }
}
