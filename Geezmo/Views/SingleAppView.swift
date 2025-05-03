//
//  SingleAppView.swift
//  Geezmo
//
//  Created by Yaroslav Sedyshev on 17.08.2024.
//

import SwiftUI
import WebOSClient
import FirebaseAnalytics

struct SingleAppView: View {
    let app: WebOSResponseApplication
    var viewModel: MainViewModel

    var body: some View {
        VStack {
            Button(app.title ?? "N/A", action: {
                if let appId = app.id {
                    viewModel.launchApp(id: appId)
                    Analytics.logEvent(AnalyticsEvents.AppsView.appLaunchTapped.rawValue, parameters: ["app_title": app.title ?? "unknown"])
                    if viewModel.preferencesHapticFeedback {
                        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                    }
                }
            })
            .buttonStyle(AccentButtonStyle(app: app, viewModel: viewModel))
        }
    }
}

struct AccentButtonStyle: ButtonStyle {
    var app: WebOSResponseApplication
    var viewModel: MainViewModel
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            Circle()
                .foregroundColor(configuration.isPressed ? .accent : Color(uiColor: .systemGray5))
                .frame(width: (UIScreen.main.bounds.width - 200) / 3, height: (UIScreen.main.bounds.width - 200) / 3)
                .scaleEffect(configuration.isPressed ? 3.0 : 1.0)
                .overlay(
                    Text(app.title?.toInitials() ?? "N/A")
                        .font(.system(size: configuration.isPressed ? 36 : 18, weight: .bold, design: .rounded))
                        .foregroundStyle(configuration.isPressed ? .white : .primary)
                        .multilineTextAlignment(.center)
                )
            
            Text(app.title ?? "N/A")
                .font(.system(size: Globals.smallTitleSize, weight: .bold, design: .rounded))
                .foregroundStyle(configuration.isPressed ? .white : .primary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal)
        .frame(width: (UIScreen.main.bounds.width - 60) / 3, height: (UIScreen.main.bounds.width - 60) / 3)
        //.background(Color(uiColor: .systemGray5).opacity(0.25))
        .cornerRadius(12)
        .animation(.easeInOut(duration: 0.25), value: configuration.isPressed)
        .onChange(of: configuration.isPressed) {
            if configuration.isPressed {
                if viewModel.preferencesHapticFeedback {
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                }
            }
        }
    }
}
