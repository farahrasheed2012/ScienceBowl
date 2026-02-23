//
//  TossUpBonusPracticeView.swift
//  NSB Study
//

import SwiftUI

struct TossUpBonusPracticeView: View {
    let questions: [NSBQuestion]
    @EnvironmentObject var contentRepository: ContentRepository
    @EnvironmentObject var progressStore: NSBProgressStore
    @State private var currentIndex = 0
    @State private var selectedKey: String?
    @State private var showExplanation = false
    @State private var tossUpScore = 0
    @State private var bonusScore = 0
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
        .navigationTitle("Toss-Up & Bonus")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func questionView(_ q: NSBQuestion) -> some View {
        ZStack {
            theme.surface.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 24) {
                Text("Toss-up \(currentIndex + 1) of \(questions.count)")
                    .font(.system(size: ThemePalette.captionSize))
                    .foregroundColor(theme.secondaryText)
                Text(q.questionText)
                    .font(.system(size: ThemePalette.bodySize))
                    .foregroundColor(theme.primaryText)
                    .padding(AppLayout.padding)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(theme.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: AppLayout.cornerRadius))
                if let choices = q.answerChoices {
                    VStack(spacing: 12) {
                        ForEach(["W", "X", "Y", "Z"], id: \.self) { key in
                            if let text = choices[key] {
                                Button {
                                    guard selectedKey == nil else { return }
                                    selectedKey = key
                                    if key == q.correctAnswer {
                                        tossUpScore += 1
                                    } else {
                                        missedTopicIds.append(q.topicId)
                                    }
                                    showExplanation = true
                                } label: {
                                    HStack {
                                        Text("\(key).").fontWeight(.semibold).foregroundColor(theme.primaryText).frame(width: 24, alignment: .leading)
                                        Text(text).font(.system(size: ThemePalette.bodySize)).foregroundColor(theme.primaryText).multilineTextAlignment(.leading)
                                        Spacer()
                                    }
                                    .padding(.vertical, 18)
                                    .padding(.horizontal, AppLayout.padding)
                                    .background(theme.cardBackground)
                                    .clipShape(RoundedRectangle(cornerRadius: AppLayout.cornerRadius))
                                    .overlay(RoundedRectangle(cornerRadius: AppLayout.cornerRadius).stroke(selectedKey == key ? theme.accent : Color.clear, lineWidth: 3))
                                }
                                .buttonStyle(.plain)
                                .disabled(selectedKey != nil)
                            }
                        }
                    }
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
                    selectedKey = nil
                    if currentIndex + 1 < questions.count {
                        currentIndex += 1
                    } else {
                        progressStore.recordSession(subject: currentQuestion?.subject ?? "Mixed", score: tossUpScore + bonusScore, total: questions.count, missedTopicIds: missedTopicIds)
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
            Text("Toss-ups: \(tossUpScore) / \(questions.count)")
                .font(.system(size: ThemePalette.titleSize))
                .foregroundColor(theme.secondaryText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.surface.ignoresSafeArea())
    }
}
