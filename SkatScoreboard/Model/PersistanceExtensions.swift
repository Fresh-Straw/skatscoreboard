//
//  Extensions.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 31.08.21.
//

import Foundation
import SwiftUI

extension Player {
    var scoreboards: [Scoreboard] {
        let boards = tookPartIn as? Set<PlayerInScoreboard> ?? []
        return boards
            .map { $0.scoreboard }
            .filter { $0 != nil }
            .map { $0! }
            .sorted { $0.lastChangedOn ?? Date() < $1.lastChangedOn ?? Date() }
    }

    var iconColor: Color {
        get {
            return Color(hex: self.iconColorString ?? "") ?? Color.blue
        }
        set(newValue) {
            self.iconColorString = newValue.toHex
        }
    }
}

extension Scoreboard {
    var playersSorted: [Player] {
        let set = playersRaw as? Set<PlayerInScoreboard> ?? []
        return set.sorted {
            $0.order < $1.order
        }.map {
            $0.player!
        }
    }
    
    var pointModel: PointModel {
        get {
            return PointModel(rawValue: self.pointModelString ?? PointModel.leipzigerSkat.rawValue)!
        }
        set(newValue) {
            self.pointModelString = newValue.rawValue
        }
    }
}

extension Game {
    var gameType: GameType {
        get {
            return GameType(rawValue: self.typeString ?? GameType.suitHearts.rawValue)!
        }
        set(newValue) {
            self.typeString = newValue.rawValue
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
    private static let colorRegex = try! NSRegularExpression(pattern: "#?(?<r>[0-9A-F]{1,2})(?<g>[0-9A-F]{1,2})(?<b>[0-9A-F]{1,2})(?<a>[0-9A-F]{1,2})?", options: .caseInsensitive)
    
    static func random() -> Color {
        return Color(
            red:   Double.random(in: 0...1),
            green: Double.random(in: 0...1),
            blue:  Double.random(in: 0...1),
            opacity: 1.0
        )
    }
    
    init?(hex: String) {
        let hexNormalized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        
        let range = NSRange(location: 0, length: hexNormalized.count)
        let matches = Color.colorRegex.matches(in: hexNormalized, options: [], range: range)
        guard let match = matches.first else {
            return nil
        }
        
        var red: Double = 0.0
        var green: Double = 0.0
        var blue: Double = 0.0
        var alpha: Double = 1.0
        
        let cgr = match.range(withName: "r")
        let cgg = match.range(withName: "g")
        let cgb = match.range(withName: "b")
        let cga = match.range(withName: "a")
        if let substringRange = Range(cgr, in: hexNormalized) {
            let capture = String(hexNormalized[substringRange])
            guard let r = Int(capture, radix: 16) else {
                return nil
            }
            red = Double(r) / 255.0
        }
        if let substringRange = Range(cgg, in: hexNormalized) {
            let capture = String(hexNormalized[substringRange])
            guard let g = Int(capture, radix: 16) else {
                return nil
            }
            green = Double(g) / 255.0
        }
        if let substringRange = Range(cgb, in: hexNormalized) {
            let capture = String(hexNormalized[substringRange])
            guard let b = Int(capture, radix: 16) else {
                return nil
            }
            blue = Double(b) / 255.0
        }
        if let substringRange = Range(cga, in: hexNormalized) {
            let capture = String(hexNormalized[substringRange])
            guard let a = Int(capture, radix: 16) else {
                return nil
            }
            alpha = Double(a) / 255.0
        }
        
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
    
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat) {
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
                return (red: 0.0, green: 0.0, blue: 0.0, opacity: 1.0)
            }

            return (r, g, b, o)
        }
    
    var toHex: String {
        let components = self.components
        let string = String(format: "%02lX%02lX%02lX%02lX", lroundf(Float(components.red) * 255), lroundf(Float(components.green) * 255), lroundf(Float(components.blue) * 255), lroundf(Float(components.opacity) * 255))
        return string
    }
    
    var textColor: Color {
        let components = self.components
        
        // algorithm from: http://www.w3.org/WAI/ER/WD-AERT/#color-contrast
        let brightness = ((components.red * 299) + (components.green * 587) + (components.blue * 114)) / 1000;
        if (brightness < 0.5) {
            return Color.white
        }
        else {
            return Color.black
        }
    }
}
