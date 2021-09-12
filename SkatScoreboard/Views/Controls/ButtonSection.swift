//
//  ButtonSectionView.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 10.09.21.
//

import SwiftUI

struct ButtonSection<Content: View>: View {
    private let title: LocalizedStringKey
    private let spacing: CGFloat
    private let indentation: CGFloat
    private let content: Content
    
    init(_ title: LocalizedStringKey, spacing: CGFloat = 1, indentation: CGFloat = 15, @ViewBuilder content: () -> Content) {
        self.title = title
        self.spacing = spacing
        self.indentation = indentation
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            Text(title)
                .font(.caption)
                .textCase(.uppercase)
            content
                .padding(.leading, indentation)
        }
    }
}

struct ButtonSection_Previews: PreviewProvider {
    static var previews: some View {
        ButtonSection("Caption") {
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(.green)
        }
    }
}
