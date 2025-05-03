//
//  NavigationView.swift
//  Geezmo Watch App
//
//  Created by Yaroslav Sedyshev on 18.07.2024.
//

import SwiftUI

struct NavigationView: View {
    @Environment(MainViewModel.self) private var viewModel

    var body: some View {
        NavigationStack {
            KeyButtonGroup {
                if viewModel.preferencesAlternativeView {
                    NavigationAlternativeView()
                } else {
                    NavigationDefaultView()
                }
            }
            .navigationTitle(Strings.Titles.navigationViewTitle)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
