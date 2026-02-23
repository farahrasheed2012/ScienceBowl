//
//  TopicListView.swift
//  NSB Study
//

import SwiftUI

struct TopicListView: View {
    let subject: NSBSubject
    @EnvironmentObject var contentRepository: ContentRepository
    @EnvironmentObject var progressStore: NSBProgressStore
    @State private var searchText = ""
    private let theme = AppTheme.palette

    private var subjectTopics: [NSBTopic] {
        contentRepository.topics(for: subject)
    }

    private var filteredTopics: [NSBTopic] {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !trimmed.isEmpty else { return subjectTopics }
        return subjectTopics.filter {
            $0.title.lowercased().contains(trimmed)
            || $0.whatIsIt.lowercased().contains(trimmed)
            || $0.keyTerms.contains { $0.term.lowercased().contains(trimmed) }
        }
    }

    var body: some View {
        List {
            ForEach(filteredTopics) { topic in
                NavigationLink(destination: TopicDetailView(topic: topic).environmentObject(progressStore).environmentObject(contentRepository)) {
                    HStack(spacing: 12) {
                        if progressStore.reviewedTopicIds.contains(topic.id) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.body)
                        }
                        Text(topic.title)
                            .font(.body)
                            .foregroundColor(theme.primaryText)
                    }
                }
                .listRowBackground(theme.cardBackground)
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(theme.surface)
        .navigationTitle(subject.rawValue)
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $searchText)
    }
}
