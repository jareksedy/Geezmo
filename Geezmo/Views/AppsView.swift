//
//  AppsView.swift
//  Geezmo
//
//  Created by Yaroslav Sedyshev on 17.08.2024.
//

import SwiftUI
import ActivityIndicatorView
import WebOSClient
import FirebaseAnalytics

struct AppsView: View {
    @State var viewModel: MainViewModel
    @State private var animateSymbol: Bool = false
    @State private var searchText = ""
    
    var filteredApps: [WebOSResponseApplication] {
            if searchText.isEmpty {
                return viewModel.apps
            } else {
                return viewModel.apps.filter { $0.title?.localizedCaseInsensitiveContains(searchText) ?? false }
            }
        }
    
    var grid = Array(repeating: GridItem(.flexible()), count: 3)
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.loadingAppsFinished {
                    if viewModel.apps.isEmpty {
                        Spacer()

                        LargeTipView(
                            systemName: "repeat.circle.fill",
                            color: .accent,
                            message: Strings.Apps.noAppsFound
                        )
                        
                        Spacer().frame(height: 5)
                        
                        Button(Strings.Apps.reload) {
                            viewModel.loadApps()
                        }
                        .padding(25)
                        .buttonStyle(.borderedProminent)
                        .font(.system(size: Globals.bodyFontSize, weight: .bold, design: .rounded))
                        
                        Spacer()
                    } else {
                        // Search bar
//                        TextField("Search", text: $searchText)
//                            .textFieldStyle(SearchTextFieldStyle())
                        
                        ScrollView {
                            LazyVGrid(columns: grid, spacing: 15) {
                                ForEach(filteredApps) { app in
                                    SingleAppView(app: app, viewModel: viewModel)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 25)
                        }
                    }
                } else {
                    Spacer()
                    ActivityIndicatorView(
                        isVisible: $viewModel.isAppsLoadingActivityIndicatorShown,
                        type: .gradient([Color(uiColor: .systemGray6), .accent], .round, lineWidth: 6)
                    )
                    .frame(width: 175, height: 175)
                    .foregroundColor(.accentColor)
                    .padding(.top, 50)
                    Spacer()
                    TipView(
                        systemName: "clock.circle.fill",
                        color: .accent,
                        message: Strings.Apps.loadingApps
                    )
                    Spacer().frame(height: 25)
                }
            }
            .environment(\.defaultMinListRowHeight, 55)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(uiColor: .systemGray6))
            .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text(Strings.Titles.apps)
                        .font(.system(size: Globals.smallTitleSize, weight: .bold, design: .rounded))
                        .foregroundColor(.accent)
                        .padding(.leading, Globals.iconPadding)
                        .padding(.top, 10)
                }
            }
            .onAppear {
                viewModel.loadApps()
                Analytics.logEvent(AnalyticsEvents.AppsView.appsViewStarted.rawValue, parameters: nil)
            }
        }
    }
}

struct SearchTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        VStack {
            HStack(spacing: 5) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.accent)
                    .padding(.leading, 10)
                configuration
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .padding(.horizontal)
            }
        }
        .padding([.top, .bottom], 15)
        .background(.geezmoDarkerGray)
        .cornerRadius(12)
        .padding([.leading, .trailing], 20)
        .padding([.top, .bottom], 15)
    }
}
