//
//  ContentRepository.swift
//  NSB Study
//

import Foundation

final class ContentRepository: ObservableObject {
    @Published var topics: [NSBTopic] = []
    @Published var questions: [NSBQuestion] = []

    init() {
        loadTopics()
        loadQuestions()
    }

    func loadTopics() {
        let url = Bundle.main.url(forResource: "topics", withExtension: "json", subdirectory: "StudyContent")
            ?? Bundle.main.url(forResource: "topics", withExtension: "json")
        guard let u = url, let data = try? Data(contentsOf: u), let decoded = try? JSONDecoder().decode([NSBTopic].self, from: data) else {
            topics = []
            return
        }
        topics = decoded
    }

    func loadQuestions() {
        let url = Bundle.main.url(forResource: "questions", withExtension: "json", subdirectory: "StudyContent")
            ?? Bundle.main.url(forResource: "questions", withExtension: "json")
        guard let u = url, let data = try? Data(contentsOf: u), let decoded = try? JSONDecoder().decode([NSBQuestion].self, from: data) else {
            questions = []
            return
        }
        questions = decoded
    }

    func topics(for subject: NSBSubject) -> [NSBTopic] {
        topics.filter { $0.subject == subject.rawValue }
    }

    func topic(byId id: String) -> NSBTopic? {
        topics.first { $0.id == id }
    }

    func questions(subject: String?, difficulty: String?, limit: Int) -> [NSBQuestion] {
        var list = questions
        if let s = subject, !s.isEmpty { list = list.filter { $0.subject == s } }
        if let d = difficulty, !d.isEmpty { list = list.filter { $0.difficulty == d } }
        return Array(list.shuffled().prefix(limit))
    }
}
