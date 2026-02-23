//
//  NSBTopic.swift
//  NSB Study
//

import Foundation

struct NSBKeyTerm: Codable {
    let term: String
    let definition: String
}

struct NSBTopic: Codable, Identifiable {
    let id: String
    let subject: String
    let title: String
    let whatIsIt: String
    let howItWorks: String
    let realWorldExample: String
    let keyTerms: [NSBKeyTerm]
    let nsbTraps: [String]
    let didYouKnow: [String]
    let relatedTopics: [String]
}
