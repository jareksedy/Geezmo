//
//  MainTabView.swift
//  Geezmo Watch App
//
//  Created by Yaroslav Sedyshev on 18.07.2024.
//

import SwiftUI

struct MainTabView: View {
    @Environment(\.scenePhase) var scenePhase
    @State var viewModel: MainViewModel
    @State private var selection: TabSelection

    var body: some View {
        TabView(selection: $selection) {
            NavigationView()
                .tag(TabSelection.navigation)
            PlaybackView()
                .tag(TabSelection.playback)
            PreferencesView(viewModel: viewModel)
                .tag(TabSelection.preferences)
        }
        .background(.geezmoDarkGray)
        .tabViewStyle(.verticalPage)
        .ignoresSafeArea(.all)
        .onChange(of: scenePhase) {
            switch scenePhase {
            case .active:
                viewModel.sendWakeUpMessage()
            default:
                break
            }
        }
        .environment(viewModel)
    }

    init(viewModel: MainViewModel, selection: TabSelection = .navigation) {
        self.viewModel = viewModel
        self.selection = .navigation
    }

    enum TabSelection {
        case navigation
        case playback
        case preferences
    }
}
