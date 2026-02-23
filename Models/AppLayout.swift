//
//  AppLayout.swift
//  NSB Study
//  Replicated from One Bee Spelling Practice.
//

import SwiftUI

enum AppLayout {
    static let padding: CGFloat = 16
    static let cardSpacing: CGFloat = 12
    static let cornerRadius: CGFloat = 12
    static let minTouchTarget: CGFloat = 44
}

extension Color {
    static let appGroupedBackground = Color(UIColor.systemGroupedBackground)
    static let appSecondaryGroupedBackground = Color(UIColor.secondarySystemGroupedBackground)
    static let appTertiaryGroupedBackground = Color(UIColor.tertiarySystemGroupedBackground)
}

struct SystemCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(AppLayout.padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.appSecondaryGroupedBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppLayout.cornerRadius))
    }
}

extension View {
    func systemCard() -> some View {
        modifier(SystemCardStyle())
    }
}
