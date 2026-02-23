//
//  SessionSettingsView.swift
//  NSB Study
//

import SwiftUI

struct SessionSettingsView: View {
    let mode: PracticeMode
    var preferredTopicIds: [String]? = nil
    @EnvironmentObject var contentRepository: ContentRepository
    @EnvironmentObject var progressStore: NSBProgressStore
    @State private var selectedSubject: String = "All Subjects"
    @State private var selectedDifficulty: String = "Both"
    @State private var questionCount: Int = 10

    private let subjects = ["All Subjects"] + NSBSubject.allCases.map(\.rawValue)
    private let difficulties = ["Grade 6", "Grade 7", "Both"]
    private let counts = [10, 20, 30]

    var body: some View {
        Form {
            if preferredTopicIds == nil {
                Section("Subject") {
                    Picker("Subject", selection: $selectedSubject) {
                        ForEach(subjects, id: \.self) { Text($0).tag($0) }
                    }
                    .pickerStyle(.menu)
                }
                Section("Difficulty") {
                    Picker("Difficulty", selection: $selectedDifficulty) {
                        ForEach(difficulties, id: \.self) { Text($0).tag($0) }
                    }
                    .pickerStyle(.segmented)
                }
            } else {
                Section {
                    Text("Questions from your weak topics only.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            Section("Number of questions") {
                Picker("Count", selection: $questionCount) {
                    ForEach(counts, id: \.self) { Text("\($0)").tag($0) }
                }
                .pickerStyle(.segmented)
            }
            Section {
                NavigationLink(destination: destinationView()) {
                    Text("Start")
                        .frame(maxWidth: .infinity)
                        .fontWeight(.semibold)
                }
            }
        }
        .navigationTitle(preferredTopicIds != nil ? "Practice weak topics" : modeTitle)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var modeTitle: String {
        switch mode {
        case .multipleChoice: return "Multiple Choice"
        case .tossUpBonus: return "Toss-Up & Bonus"
        case .freeResponse: return "Free Response"
        }
    }

    private func fetchQuestions() -> [NSBQuestion] {
        if let topicIds = preferredTopicIds, !topicIds.isEmpty {
            return contentRepository.questions(forTopicIds: Array(Set(topicIds)), limit: questionCount)
        }
        let diffKey = selectedDifficulty == "Grade 6" ? "grade6" : (selectedDifficulty == "Grade 7" ? "grade7" : nil)
        let subj = selectedSubject == "All Subjects" ? nil : selectedSubject
        return contentRepository.questions(subject: subj, difficulty: diffKey, limit: questionCount)
    }

    private func destinationView() -> some View {
        let questions = fetchQuestions()
        return Group {
            switch mode {
            case .multipleChoice:
                MultipleChoicePracticeView(questions: questions, modeLabel: modeTitle)
                    .environmentObject(contentRepository)
                    .environmentObject(progressStore)
            case .tossUpBonus:
                TossUpBonusPracticeView(questions: questions, modeLabel: modeTitle)
                    .environmentObject(contentRepository)
                    .environmentObject(progressStore)
            case .freeResponse:
                FreeResponsePracticeView(questions: questions, modeLabel: modeTitle)
                    .environmentObject(contentRepository)
                    .environmentObject(progressStore)
            }
        }
    }
}
