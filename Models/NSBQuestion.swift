//
//  NSBQuestion.swift
//  NSB Study
//

import Foundation

struct NSBQuestion: Codable, Identifiable {
    let id: String
    let subject: String
    let subtopic: String
    let type: String // "multipleChoice", "tossUp", "freeResponse"
    let questionText: String
    let answerChoices: [String: String]? // W, X, Y, Z
    let correctAnswer: String
    let difficulty: String // "grade6", "grade7"
    let topicId: String
}
