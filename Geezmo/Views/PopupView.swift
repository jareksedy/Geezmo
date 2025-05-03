//
//  PopupView.swift
//  Geezmo
//
//  Created by Yaroslav Sedyshev on 11.08.2024.
//

import SwiftUI

struct PopupView: View {
    var viewModel: MainViewModel
    var configuration: ToastConfiguration
    
    var body: some View {
        VStack {
            TipView(
                systemName: configuration.type.systemName,
                color: configuration.type.iconColor,
                message: configuration.message
            )
            .frame(width: UIScreen.main.bounds.width - 10)
            .padding(.vertical, 50)
        }
        .background(Color(uiColor: .systemGray6))
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.25), radius: 100, x: 0, y: 0)
        .onAppear {
            if viewModel.preferencesHapticFeedback {
                UINotificationFeedbackGenerator()
                    .notificationOccurred(configuration.type.getNotificationFeedbackType())
            }
        }
    }
}
