//
//  PlaybackView.swift
//  Geezmo Watch App
//
//  Created by Yaroslav Sedyshev on 18.07.2024.
//

import SwiftUI

struct PlaybackView: View {
    @Environment(MainViewModel.self) private var viewModel

    var body: some View {
        NavigationStack {
            KeyButtonGroup {
                if viewModel.preferencesAlternativeView {
                    PlaybackAlternativeView()
                } else {
                    PlaybackDefaultView()
                }
            }
            .navigationTitle(Strings.Titles.playbackViewTitle)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
