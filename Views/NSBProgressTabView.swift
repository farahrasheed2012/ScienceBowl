//
//  NSBProgressTabView.swift
//  NSB Study
//

import SwiftUI

struct NSBProgressTabView: View {
    @EnvironmentObject var contentRepository: ContentRepository
    @EnvironmentObject var progressStore: NSBProgressStore
    private let theme = AppTheme.palette

    var body: some View {
        NavigationView {
            ZStack {
                theme.surface.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 24) {
                        overallCard
                        streakCard
                        sessionHistoryCard
                        weakAreasCard
                    }
                    .padding(24)
                }
            }
            .navigationTitle("Progress")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var overallCard: some View {
        VStack(spacing: 20) {
            Text("\(progressStore.reviewedTopicIds.count) topics reviewed")
                .font(.system(size: ThemePalette.titleSize, weight: .bold))
                .foregroundColor(theme.primaryText)
            Text("\(progressStore.sessionHistory.count) practice sessions")
                .font(.system(size: ThemePalette.bodySize))
                .foregroundColor(theme.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(32)
        .background(theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: ThemePalette.cornerRadius))
        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
    }

    private var streakCard: some View {
        HStack {
            Image(systemName: "flame.fill")
                .font(.title2)
                .foregroundColor(Color(UIColor.systemOrange))
            Text("\(progressStore.currentStreak) day streak")
                .font(.system(size: ThemePalette.bodySize))
                .foregroundColor(theme.primaryText)
            Spacer()
        }
        .padding(20)
        .background(theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppLayout.cornerRadius))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }

    private var sessionHistoryCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Session history")
                .font(.headline)
                .foregroundColor(theme.primaryText)
            ForEach(progressStore.sessionHistory.prefix(15)) { session in
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(session.subject)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(theme.primaryText)
                        Text(session.date, style: .date)
                            .font(.caption)
                            .foregroundColor(theme.secondaryText)
                    }
                    Spacer()
                    Text("\(session.score)/\(session.total)")
                        .font(.system(size: ThemePalette.bodySize, weight: .semibold))
                        .foregroundColor(theme.primaryText)
                }
                .padding(16)
                .background(theme.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: AppLayout.cornerRadius))
            }
        }
    }

    private var weakAreasCard: some View {
        Group {
            if !progressStore.weakTopicIds.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Topics to review")
                        .font(.headline)
                        .foregroundColor(theme.primaryText)
                    ForEach(progressStore.weakTopicIds.prefix(10), id: \.self) { topicId in
                        if let topic = contentRepository.topic(byId: topicId) {
                            NavigationLink(destination: TopicDetailView(topic: topic).environmentObject(progressStore).environmentObject(contentRepository)) {
                                HStack {
                                    Text(topic.title)
                                        .font(.body)
                                        .foregroundColor(theme.primaryText)
                                    Spacer()
                                    Text("\(progressStore.wrongCountPerTopicId[topicId] ?? 0) missed")
                                        .font(.caption)
                                        .foregroundColor(theme.wrong)
                                }
                                .padding(16)
                                .background(theme.cardBackground)
                                .clipShape(RoundedRectangle(cornerRadius: AppLayout.cornerRadius))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
    }
}
