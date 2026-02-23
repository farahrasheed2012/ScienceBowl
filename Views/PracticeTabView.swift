//
//  PracticeTabView.swift
//  NSB Study
//

import SwiftUI

struct PracticeTabView: View {
    @EnvironmentObject var contentRepository: ContentRepository
    @EnvironmentObject var progressStore: NSBProgressStore

    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: SessionSettingsView(mode: .multipleChoice).environmentObject(contentRepository).environmentObject(progressStore)) {
                        Label("Multiple Choice", systemImage: "list.bullet")
                    }
                    NavigationLink(destination: SessionSettingsView(mode: .tossUpBonus).environmentObject(contentRepository).environmentObject(progressStore)) {
                        Label("Toss-Up & Bonus", systemImage: "timer")
                    }
                    NavigationLink(destination: SessionSettingsView(mode: .freeResponse).environmentObject(contentRepository).environmentObject(progressStore)) {
                        Label("Free Response", systemImage: "keyboard")
                    }
                } header: {
                    Text("Practice Modes")
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Practice")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

enum PracticeMode {
    case multipleChoice
    case tossUpBonus
    case freeResponse
}
