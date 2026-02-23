//
//  LearnTabView.swift
//  NSB Study
//

import SwiftUI

struct LearnTabView: View {
    @EnvironmentObject var contentRepository: ContentRepository
    @EnvironmentObject var progressStore: NSBProgressStore

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: AppLayout.cardSpacing) {
                    headerCard
                    ForEach(NSBSubject.allCases) { subject in
                        NavigationLink(destination: TopicListView(subject: subject).environmentObject(contentRepository).environmentObject(progressStore)) {
                            subjectRow(subject)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(AppLayout.padding)
            }
            .background(AppTheme.palette.surface)
            .navigationTitle("Learn")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var headerCard: some View {
        HStack(alignment: .top, spacing: AppLayout.padding) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Hi, Soha!")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(AppTheme.palette.primaryText)
                Text("Pick a subject to study.")
                    .font(.body)
                    .foregroundColor(AppTheme.palette.secondaryText)
            }
            Spacer(minLength: 0)
        }
        .padding(AppLayout.padding)
        .frame(minHeight: AppLayout.minTouchTarget * 1.5)
        .background(AppTheme.palette.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppLayout.cornerRadius))
    }

    private func subjectRow(_ subject: NSBSubject) -> some View {
        HStack(spacing: AppLayout.padding) {
            Text(subject.emoji)
                .font(.title)
            Text(subject.rawValue)
                .font(.body)
                .foregroundColor(AppTheme.palette.primaryText)
            Spacer(minLength: 0)
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(AppTheme.palette.secondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(minHeight: AppLayout.minTouchTarget)
        .padding(.horizontal, AppLayout.padding)
        .padding(.vertical, 12)
        .background(AppTheme.palette.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppLayout.cornerRadius))
    }
}
