//
//  TopicDetailView.swift
//  NSB Study
//  All 7 sections: What Is It?, How It Works, Real-World Example, Key Terms, NSB Traps, Did You Know?, Related Topics.
//

import SwiftUI

struct TopicDetailView: View {
    let topic: NSBTopic
    @EnvironmentObject var progressStore: NSBProgressStore
    @EnvironmentObject var contentRepository: ContentRepository
    private let theme = AppTheme.palette

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                sectionBlock("What Is It?") { Text(topic.whatIsIt).font(.system(size: ThemePalette.bodySize)).foregroundColor(theme.primaryText) }
                sectionBlock("How It Works") { Text(topic.howItWorks).font(.system(size: ThemePalette.bodySize)).foregroundColor(theme.primaryText) }
                sectionBlock("Real-World Example") { Text(topic.realWorldExample).font(.system(size: ThemePalette.bodySize)).foregroundColor(theme.primaryText) }
                sectionBlock("Key Terms to Know") {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(topic.keyTerms, id: \.term) { term in
                            Text("**\(term.term):** \(term.definition)")
                                .font(.system(size: ThemePalette.captionSize))
                                .foregroundColor(theme.primaryText)
                        }
                    }
                }
                sectionBlock("Common NSB Traps") {
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(Array(topic.nsbTraps.enumerated()), id: \.offset) { _, trap in
                            HStack(alignment: .top, spacing: 6) {
                                Text("•").foregroundColor(theme.accent)
                                Text(trap).font(.system(size: ThemePalette.captionSize)).foregroundColor(theme.primaryText)
                            }
                        }
                    }
                }
                sectionBlock("Did You Know?") {
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(Array(topic.didYouKnow.enumerated()), id: \.offset) { _, fact in
                            Text(fact).font(.system(size: ThemePalette.captionSize)).foregroundColor(theme.secondaryText).italic()
                        }
                    }
                }
                if !topic.relatedTopics.isEmpty {
                    sectionBlock("Related Topics") {
                        FlowLayout(spacing: 8) {
                            ForEach(topic.relatedTopics, id: \.self) { topicId in
                                if let related = contentRepository.topic(byId: topicId) {
                                    NavigationLink(destination: TopicDetailView(topic: related).environmentObject(progressStore).environmentObject(contentRepository)) {
                                        Text(related.title)
                                            .font(.system(size: ThemePalette.captionSize, weight: .medium))
                                            .foregroundColor(theme.accent)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(theme.accent.opacity(0.15))
                                            .clipShape(Capsule())
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                }
                Button {
                    progressStore.markReviewed(topicId: topic.id)
                } label: {
                    HStack {
                        Image(systemName: progressStore.reviewedTopicIds.contains(topic.id) ? "checkmark.circle.fill" : "checkmark.circle")
                        Text(progressStore.reviewedTopicIds.contains(topic.id) ? "Reviewed" : "Mark as reviewed")
                    }
                    .font(.system(size: ThemePalette.bodySize, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, ThemePalette.buttonPadding)
                    .background(theme.accent)
                    .clipShape(RoundedRectangle(cornerRadius: ThemePalette.cornerRadius))
                }
                .buttonStyle(.plain)
                .padding(.top, 8)
            }
            .padding(AppLayout.padding)
            .padding(.bottom, 32)
        }
        .background(theme.surface.ignoresSafeArea())
        .navigationTitle(topic.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sectionBlock<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: ThemePalette.titleSize, weight: .bold))
                .foregroundColor(theme.primaryText)
            content()
        }
        .padding(AppLayout.padding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppLayout.cornerRadius))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

// Simple flow layout for related topic chips
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, pos) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + pos.x, y: bounds.minY + pos.y), proposal: .unspecified)
        }
    }
    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? 300
        var x: CGFloat = 0, y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var positions: [CGPoint] = []
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 { x = 0; y += rowHeight + spacing; rowHeight = 0 }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }
        let totalHeight = y + rowHeight
        return (CGSize(width: maxWidth, height: totalHeight), positions)
    }
}
