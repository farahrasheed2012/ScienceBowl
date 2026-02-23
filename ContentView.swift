//
//  ContentView.swift
//  NSB Study
//  Three tabs: Learn, Practice, Progress (mirror One Bee style).
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var contentRepository: ContentRepository
    @EnvironmentObject var progressStore: NSBProgressStore
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            LearnTabView()
                .tabItem {
                    Label("Learn", systemImage: "book.fill")
                }
                .tag(0)

            PracticeTabView()
                .tabItem {
                    Label("Practice", systemImage: "pencil.and.list.clipboard")
                }
                .tag(1)

            NSBProgressTabView()
                .tabItem {
                    Label("Progress", systemImage: "chart.bar.fill")
                }
                .tag(2)
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
        .environmentObject(ContentRepository())
        .environmentObject(NSBProgressStore())
}
