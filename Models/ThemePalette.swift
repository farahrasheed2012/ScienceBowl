//
//  ThemePalette.swift
//  NSB Study
//  Replicated from One Bee Spelling Practice.
//

import SwiftUI

struct ThemePalette {
    let accent: Color
    let success: Color
    let wrong: Color
    let surface: Color
    let cardBackground: Color
    let primaryText: Color
    let secondaryText: Color

    static let largeTitleSize: CGFloat = 28
    static let titleSize: CGFloat = 22
    static let bodySize: CGFloat = 20
    static let captionSize: CGFloat = 18
    static let cornerRadius: CGFloat = 20
    static let buttonPadding: CGFloat = 20
}

enum AppTheme {
    /// Dark theme (from One Bee design).
    static var palette: ThemePalette { dark }

    static let dark = ThemePalette(
        accent: Color(red: 1, green: 0.6, blue: 0.2),
        success: Color(red: 0.2, green: 0.8, blue: 0.4),
        wrong: Color(red: 0.95, green: 0.3, blue: 0.3),
        surface: Color(red: 0.12, green: 0.1, blue: 0.14),
        cardBackground: Color(red: 0.2, green: 0.18, blue: 0.22),
        primaryText: Color(red: 0.95, green: 0.93, blue: 1),
        secondaryText: Color(red: 0.65, green: 0.6, blue: 0.7)
    )

    static let warmLight = ThemePalette(
        accent: Color(red: 1, green: 0.6, blue: 0.2),
        success: Color(red: 0.2, green: 0.8, blue: 0.4),
        wrong: Color(red: 0.95, green: 0.3, blue: 0.3),
        surface: Color(red: 1, green: 0.98, blue: 0.94),
        cardBackground: Color.white,
        primaryText: Color(red: 0.15, green: 0.1, blue: 0.2),
        secondaryText: Color(red: 0.4, green: 0.35, blue: 0.45)
    )
}
