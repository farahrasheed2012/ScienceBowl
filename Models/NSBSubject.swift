//
//  NSBSubject.swift
//  NSB Study
//

import Foundation

enum NSBSubject: String, CaseIterable, Identifiable {
    case lifeScience = "Life Science"
    case physicalScience = "Physical Science"
    case chemistry = "Chemistry"
    case earthSpace = "Earth & Space Science"
    case energy = "Energy"
    case math = "Math"

    var id: String { rawValue }

    var shortId: String {
        switch self {
        case .lifeScience: return "ls"
        case .physicalScience: return "ps"
        case .chemistry: return "ch"
        case .earthSpace: return "es"
        case .energy: return "en"
        case .math: return "math"
        }
    }

    var emoji: String {
        switch self {
        case .lifeScience: return "🧬"
        case .physicalScience: return "⚛️"
        case .chemistry: return "🧪"
        case .earthSpace: return "🌍"
        case .energy: return "⚡"
        case .math: return "📐"
        }
    }
}
