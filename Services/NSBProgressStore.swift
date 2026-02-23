//
//  NSBProgressStore.swift
//  NSB Study
//

import Foundation
import SwiftUI

final class NSBProgressStore: ObservableObject {
    private let reviewedKey = "nsb_reviewed_topic_ids"
    private let sessionsKey = "nsb_session_history"
    private let lastStudyDateKey = "nsb_last_study_date"
    private let currentStreakKey = "nsb_current_streak"
    private let wrongTopicCountKey = "nsb_wrong_topic_count"

    @Published var reviewedTopicIds: Set<String> = []
    @Published var sessionHistory: [NSBSessionRecord] = []
    @Published var lastStudyDate: Date?
    @Published var currentStreak: Int = 0
    @Published var wrongCountPerTopicId: [String: Int] = [:]

    init() {
        load()
    }

    func markReviewed(topicId: String) {
        reviewedTopicIds.insert(topicId)
        updateStreakIfNeeded()
        save()
    }

    func recordSession(subject: String, score: Int, total: Int, missedTopicIds: [String]) {
        let record = NSBSessionRecord(
            id: UUID().uuidString,
            date: Date(),
            subject: subject,
            score: score,
            total: total,
            missedTopicIds: missedTopicIds
        )
        sessionHistory.insert(record, at: 0)
        for id in missedTopicIds {
            wrongCountPerTopicId[id, default: 0] += 1
        }
        updateStreakIfNeeded()
        save()
    }

    private func updateStreakIfNeeded() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        lastStudyDate = Date()
        guard let last = lastStudyDate else {
            currentStreak = 1
            return
        }
        let lastDay = calendar.startOfDay(for: last)
        let daysDiff = calendar.dateComponents([.day], from: lastDay, to: today).day ?? 0
        if daysDiff == 0 {
            return
        } else if daysDiff == 1 {
            currentStreak += 1
        } else {
            currentStreak = 1
        }
        save()
    }

    var weakTopicIds: [String] {
        wrongCountPerTopicId
            .filter { $0.value > 0 }
            .sorted { $0.value > $1.value }
            .map(\.key)
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: reviewedKey),
           let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
            reviewedTopicIds = decoded
        }
        if let data = UserDefaults.standard.data(forKey: sessionsKey),
           let decoded = try? JSONDecoder().decode([NSBSessionRecord].self, from: data) {
            sessionHistory = decoded
        }
        lastStudyDate = UserDefaults.standard.object(forKey: lastStudyDateKey) as? Date
        currentStreak = UserDefaults.standard.integer(forKey: currentStreakKey)
        if currentStreak == 0 && lastStudyDate != nil { currentStreak = 1 }
        if let data = UserDefaults.standard.data(forKey: wrongTopicCountKey),
           let decoded = try? JSONDecoder().decode([String: Int].self, from: data) {
            wrongCountPerTopicId = decoded
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(reviewedTopicIds) {
            UserDefaults.standard.set(data, forKey: reviewedKey)
        }
        if let data = try? JSONEncoder().encode(sessionHistory) {
            UserDefaults.standard.set(data, forKey: sessionsKey)
        }
        UserDefaults.standard.set(lastStudyDate, forKey: lastStudyDateKey)
        UserDefaults.standard.set(currentStreak, forKey: currentStreakKey)
        if let data = try? JSONEncoder().encode(wrongCountPerTopicId) {
            UserDefaults.standard.set(data, forKey: wrongTopicCountKey)
        }
    }
}

struct NSBSessionRecord: Codable, Identifiable {
    let id: String
    let date: Date
    let subject: String
    let score: Int
    let total: Int
    let missedTopicIds: [String]
}
