//
//  ToggleButton.swift
//  Skat Scoreboard
//
//  Created by Olaf Neumann on 14.03.21.
//

import SwiftUI

struct ToggleButton: View {
    var title: LocalizedStringKey
    private var binding: Binding<Bool>
    private var onAction: () -> Void
        
    init(title: LocalizedStringKey, binding: Binding<Bool>, onAction: @escaping () -> Void = {}) {
        self.title = title
        self.binding = binding
        self.onAction = onAction
    }
    
    init<T: Equatable>(title: LocalizedStringKey, binding: Binding<T>, match: T,  onAction: @escaping () -> Void = {}) {
        self.title = title
        self.binding = Binding(get: {binding.wrappedValue == match}, set: { if $0 {binding.wrappedValue = match} })
        self.onAction = onAction
    }
    
    init<T: Equatable>(title: LocalizedStringKey, binding: Binding<T>, matching: @escaping () -> T, selection: @escaping (Bool) -> (),  onAction: @escaping () -> Void = {}) {
        self.title = title
        self.binding = Binding(get: {binding.wrappedValue == matching()}, set: selection)
        self.onAction = onAction
    }

    var body: some View {
        ZStack {
            let bgColor = binding.wrappedValue ? Color.toggleButtonPressed : Color.toggleButtonNormal
            
            bgColor
            
            Text(title)
                .foregroundColor(bgColor.textColor)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            binding.wrappedValue.toggle()
            onAction()
        }
    }
}

struct ToggleButton_Previews: PreviewProvider {
    static var previews: some View {
        ToggleButton(title: "abc", binding: .constant(false))
            .previewLayout(.fixed(width: 100, height: 100))
        ToggleButton(title: "abc", binding: .constant(true))
            .previewLayout(.fixed(width: 100, height: 100))
        ToggleButton(title: "grand", binding: .constant(GameType.grand), match: .grand)
            .previewLayout(.fixed(width: 100, height: 100))
        ToggleButton(title: "grand", binding: .constant(GameType.grand), match: .null)
            .previewLayout(.fixed(width: 100, height: 100))
    }
}
