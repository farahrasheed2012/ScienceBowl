//
//  FreeResponsePracticeView.swift
//  NSB Study
//

import SwiftUI

struct FreeResponsePracticeView: View {
    let questions: [NSBQuestion]
    @EnvironmentObject var contentRepository: ContentRepository
    @EnvironmentObject var progressStore: NSBProgressStore
    @State private var currentIndex = 0
    @State private var userAnswer = ""
    @State private var showCorrectAnswer = false
    @State private var selfCorrect = false
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
                Text("No questions.").foregroundColor(theme.primaryText).frame(maxWidth: .infinity, maxHeight: .infinity).background(theme.surface.ignoresSafeArea())
            } else if showExplanation, let q = currentQuestion, let topic = contentRepository.topic(byId: q.topicId) {
                explanationThenNext(topic: topic)
            } else if let q = currentQuestion {
                questionView(q)
            } else {
                endView
            }
        }
        .navigationTitle("Free Response")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func questionView(_ q: NSBQuestion) -> some View {
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
                TextField("Your answer", text: $userAnswer)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                    .disabled(showCorrectAnswer)
                if showCorrectAnswer {
                    Text("Correct answer: \(q.correctAnswer)")
                        .font(.headline)
                        .foregroundColor(theme.primaryText)
                    HStack(spacing: 16) {
                        Button("I got it right") {
                            score += 1
                            showExplanation = true
                        }
                        .font(.system(size: ThemePalette.bodySize, weight: .semibold))
                        .foregroundColor(theme.success)
                        Button("I got it wrong") {
                            missedTopicIds.append(q.topicId)
                            showExplanation = true
                        }
                        .font(.system(size: ThemePalette.bodySize, weight: .semibold))
                        .foregroundColor(theme.wrong)
                    }
                } else {
                    Button("Submit") {
                        showCorrectAnswer = true
                    }
                    .font(.system(size: ThemePalette.bodySize, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(theme.accent)
                    .clipShape(RoundedRectangle(cornerRadius: ThemePalette.cornerRadius))
                    .buttonStyle(.plain)
                    .disabled(userAnswer.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                Spacer()
            }
            .padding(24)
        }
    }

    private func explanationThenNext(topic: NSBTopic) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Topic: \(topic.title)")
                    .font(.system(size: ThemePalette.titleSize, weight: .bold))
                    .foregroundColor(theme.primaryText)
                Text(topic.whatIsIt)
                    .font(.system(size: ThemePalette.bodySize))
                    .foregroundColor(theme.primaryText)
                Button {
                    showExplanation = false
                    showCorrectAnswer = false
                    userAnswer = ""
                    if currentIndex + 1 < questions.count {
                        currentIndex += 1
                    } else {
                        progressStore.recordSession(subject: currentQuestion?.subject ?? "Mixed", score: score, total: questions.count, missedTopicIds: missedTopicIds)
                        currentIndex = questions.count
                    }
                } label: {
                    Text(currentIndex + 1 < questions.count ? "Next" : "See results")
                        .font(.system(size: ThemePalette.bodySize, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(theme.accent)
                        .clipShape(RoundedRectangle(cornerRadius: ThemePalette.cornerRadius))
                }
                .buttonStyle(.plain)
            }
            .padding(24)
        }
        .background(theme.surface.ignoresSafeArea())
    }

    private var endView: some View {
        VStack(spacing: 24) {
            Text("Session complete!")
                .font(.system(size: ThemePalette.largeTitleSize, weight: .bold))
                .foregroundColor(theme.primaryText)
            Text("\(score) / \(questions.count) (self-reported)")
                .font(.system(size: ThemePalette.titleSize))
                .foregroundColor(theme.secondaryText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.surface.ignoresSafeArea())
    }
}
