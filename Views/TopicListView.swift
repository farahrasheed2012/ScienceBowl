//
//  TopicListView.swift
//  NSB Study
//

import SwiftUI

struct TopicListView: View {
    let subject: NSBSubject
    @EnvironmentObject var contentRepository: ContentRepository
    @EnvironmentObject var progressStore: NSBProgressStore
    private let theme = AppTheme.palette

    private var subjectTopics: [NSBTopic] {
        contentRepository.topics(for: subject)
    }

    var body: some View {
        List {
            ForEach(subjectTopics) { topic in
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
    }
}
