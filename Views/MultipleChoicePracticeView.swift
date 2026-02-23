//
//  MultipleChoicePracticeView.swift
//  NSB Study
//  W, X, Y, Z options; show topic explanation after each answer.
//

import SwiftUI
import UIKit

struct MultipleChoicePracticeView: View {
    let questions: [NSBQuestion]
    var modeLabel: String = "Multiple Choice"
    @EnvironmentObject var contentRepository: ContentRepository
    @EnvironmentObject var progressStore: NSBProgressStore
    @State private var currentIndex = 0
    @State private var selectedKey: String?
    @State private var showResult = false
    @State private var showExplanation = false
    @State private var score = 0
    @State private var missedTopicIds: [String] = []
    private let theme = AppTheme.palette

    private var currentQuestion: NSBQuestion? {
        guard !questions.isEmpty, currentIndex < questions.count else { return nil }
        return questions[currentIndex]
    }

    var body: some View {
        Group {
            if questions.isEmpty {
                emptyView
            } else if showExplanation, let q = currentQuestion, let topic = contentRepository.topic(byId: q.topicId) {
                explanationCard(topic: topic) {
                    nextOrFinish()
                }
            } else if let q = currentQuestion {
                mainQuestionView(q)
            } else {
                sessionEndView
            }
        }
        .navigationTitle("Multiple Choice")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var emptyView: some View {
        VStack(spacing: 16) {
            Text("No questions match your settings.")
                .font(.title2)
                .foregroundColor(theme.primaryText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.surface.ignoresSafeArea())
    }

    private func mainQuestionView(_ q: NSBQuestion) -> some View {
        ZStack {
            theme.surface.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 24) {
                Text("Question \(currentIndex + 1) of \(questions.count)")
                    .font(.system(size: ThemePalette.captionSize))
                    .foregroundColor(theme.secondaryText)
                Text(q.questionText)
                    .font(.system(size: ThemePalette.bodySize))
                    .foregroundColor(theme.primaryText)
                    .padding(AppLayout.padding)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(theme.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: AppLayout.cornerRadius))
                if let choices: [String: String] = q.answerChoices {
                    VStack(spacing: 12) {
                        ForEach(["W", "X", "Y", "Z"], id: \.self) { key in
                            if let text = choices[key] {
                                optionButton(key: key, text: text, correct: q.correctAnswer, correctText: choices[q.correctAnswer] ?? q.correctAnswer)
                            }
                        }
                    }
                }
                if showResult {
                    Text(selectedKey == q.correctAnswer ? "Correct!" : "Correct answer: \(q.correctAnswer)")
                        .font(.headline)
                        .foregroundColor(selectedKey == q.correctAnswer ? theme.success : theme.wrong)
                    Button("Show explanation") {
                        showExplanation = true
                    }
                    .font(.system(size: ThemePalette.bodySize, weight: .semibold))
                    .foregroundColor(theme.accent)
                }
                Spacer()
            }
            .padding(24)
        }
    }

    private func optionButton(key: String, text: String, correct: String, correctText: String) -> some View {
        let isSelected = selectedKey == key
        let showCorrect = showResult && key == correct
        let showWrong = showResult && isSelected && key != correct
        return Button {
            guard selectedKey == nil else { return }
            selectedKey = key
            if key == correct {
                score += 1
            } else {
                missedTopicIds.append(currentQuestion?.topicId ?? "")
            }
            showResult = true
        } label: {
            HStack {
                Text("\(key).")
                    .fontWeight(.semibold)
                    .foregroundColor(theme.primaryText)
                    .frame(width: 24, alignment: .leading)
                Text(text)
                    .font(.system(size: ThemePalette.bodySize))
                    .foregroundColor(theme.primaryText)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            .padding(.vertical, 18)
            .padding(.horizontal, AppLayout.padding)
            .background(theme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppLayout.cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: AppLayout.cornerRadius)
                    .stroke(showCorrect ? theme.success : (showWrong ? theme.wrong : (isSelected ? theme.accent : Color.clear)), lineWidth: 3)
            )
        }
        .buttonStyle(.plain)
        .disabled(selectedKey != nil)
        .accessibilityLabel("Option \(key): \(text)")
        .accessibilityHint(showResult ? (key == correct ? "Correct" : "Incorrect. Correct answer: \(correctText)") : "Double tap to select")
    }

    private func explanationCard(topic: NSBTopic, onContinue: @escaping () -> Void) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Topic: \(topic.title)")
                    .font(.system(size: ThemePalette.titleSize, weight: .bold))
                    .foregroundColor(theme.primaryText)
                Text(topic.whatIsIt)
                    .font(.system(size: ThemePalette.bodySize))
                    .foregroundColor(theme.primaryText)
                Text(topic.howItWorks)
                    .font(.system(size: ThemePalette.captionSize))
                    .foregroundColor(theme.secondaryText)
                Button(action: onContinue) {
                    Text(currentIndex + 1 < questions.count ? "Next question" : "See results")
                        .font(.system(size: ThemePalette.bodySize, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(theme.accent)
                        .clipShape(RoundedRectangle(cornerRadius: ThemePalette.cornerRadius))
                }
                .buttonStyle(.plain)
                .accessibilityLabel(currentIndex + 1 < questions.count ? "Next question" : "See results")
                .accessibilityHint("Double tap to continue")
            }
            .padding(24)
        }
        .background(theme.surface.ignoresSafeArea())
    }

    private func nextOrFinish() {
        showExplanation = false
        selectedKey = nil
        showResult = false
        if currentIndex + 1 < questions.count {
            currentIndex += 1
        } else {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            progressStore.recordSession(
                subject: currentQuestion?.subject ?? "Mixed",
                mode: modeLabel,
                score: score,
                total: questions.count,
                missedTopicIds: missedTopicIds
            )
            currentIndex = questions.count
        }
    }

    private var sessionEndView: some View {
        VStack(spacing: 24) {
            Text("Session complete!")
                .font(.system(size: ThemePalette.largeTitleSize, weight: .bold))
                .foregroundColor(theme.primaryText)
            Text("\(score) / \(questions.count) correct")
                .font(.system(size: ThemePalette.titleSize))
                .foregroundColor(theme.secondaryText)
            if !missedTopicIds.isEmpty {
                VStack(spacing: 12) {
                    Text("Topics to review")
                        .font(.headline)
                        .foregroundColor(theme.secondaryText)
                    NavigationLink(destination: weakTopicsReviewView) {
                        Text("Review weak topics")
                            .font(.system(size: ThemePalette.bodySize, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(theme.accent)
                            .clipShape(RoundedRectangle(cornerRadius: ThemePalette.cornerRadius))
                    }
                    .buttonStyle(.plain)
                    NavigationLink(destination: SessionSettingsView(mode: .multipleChoice, preferredTopicIds: Array(Set(missedTopicIds))).environmentObject(contentRepository).environmentObject(progressStore)) {
                        Text("Practice weak topics")
                            .font(.system(size: ThemePalette.bodySize, weight: .semibold))
                            .foregroundColor(theme.primaryText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(theme.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: ThemePalette.cornerRadius))
                            .overlay(RoundedRectangle(cornerRadius: ThemePalette.cornerRadius).stroke(theme.accent, lineWidth: 2))
                    }
                    .buttonStyle(.plain)
                }
            }
            NavigationLink(destination: SessionSettingsView(mode: .multipleChoice).environmentObject(contentRepository).environmentObject(progressStore)) {
                Text("Practice again")
                    .font(.system(size: ThemePalette.bodySize, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(theme.accent)
                    .clipShape(RoundedRectangle(cornerRadius: ThemePalette.cornerRadius))
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.surface.ignoresSafeArea())
    }

    private var weakTopicsReviewView: some View {
        List {
            ForEach(Array(Set(missedTopicIds)), id: \.self) { topicId in
                if let topic = contentRepository.topic(byId: topicId) {
                    NavigationLink(destination: TopicDetailView(topic: topic).environmentObject(progressStore).environmentObject(contentRepository)) {
                        Text(topic.title)
                    }
                }
            }
        }
        .navigationTitle("Review topics")
    }
}
