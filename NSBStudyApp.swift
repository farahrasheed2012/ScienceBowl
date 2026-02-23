//
//  NSBStudyApp.swift
//  NSB Study
//

import SwiftUI

@main
struct NSBStudyApp: App {
    @StateObject private var contentRepository = ContentRepository()
    @StateObject private var progressStore = NSBProgressStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(contentRepository)
                .environmentObject(progressStore)
        }
    }
}
