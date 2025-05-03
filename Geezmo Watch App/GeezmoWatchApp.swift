//
//  GeezmoWatchApp.swift
//  Geezmo Watch App
//
//  Created by Yaroslav Sedyshev on 18.07.2024.
//

import SwiftUI

@main
struct GeezmoWatchApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView(viewModel: MainViewModel())
        }
    }
}
