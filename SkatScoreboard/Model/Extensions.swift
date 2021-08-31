//
//  Extensions.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 31.08.21.
//

import Foundation
import SwiftUI

extension Player {
    var iconColor: Color {
        get {
            return Color(hex: self.iconColorString ?? "") ?? Color.blue
        }
        set(newValue) {
            self.iconColorString = newValue.toHex
        }
    }
}

func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}

extension Color {
    init?(hex: String) {
        let hexNormalized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")

        // Helpers
        var rgb: Int64 = 0
        var r: Double = 0.0
        var g: Double = 0.0
        var b: Double = 0.0
        var a: Double = 1.0
        let length = hexNormalized.count

        // Create Scanner
        Scanner(string: hexNormalized)
            .scanInt64(&rgb)

        if length == 6 {
            r = Double((rgb & 0xFF0000) >> 16) / 255.0
            g = Double((rgb & 0x00FF00) >> 8) / 255.0
            b = Double(rgb & 0x0000FF) / 255.0

        } else if length == 8 {
            r = Double((rgb & 0xFF000000) >> 24) / 255.0
            g = Double((rgb & 0x00FF0000) >> 16) / 255.0
            b = Double((rgb & 0x0000FF00) >> 8) / 255.0
            a = Double(rgb & 0x000000FF) / 255.0

        } else {
            return nil
        }
        
        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
    
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat)? {
            #if canImport(UIKit)
            typealias NativeColor = UIColor
            #elseif canImport(AppKit)
            typealias NativeColor = NSColor
            #endif

            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var o: CGFloat = 0

            guard NativeColor(self).getRed(&r, green: &g, blue: &b, alpha: &o) else {
                return nil
            }

            return (r, g, b, o)
        }
    
    var toHex: String {
        let components = self.components ?? (red: 0.0, green: 0.0, blue: 0.0, opacity: 1.0)
        return String(format: "%02lX%02lX%02lX%02lX", lroundf(Float(components.red) * 255), lroundf(Float(components.green) * 255), lroundf(Float(components.blue) * 255), lroundf(Float(components.opacity) * 255))
    }
}
