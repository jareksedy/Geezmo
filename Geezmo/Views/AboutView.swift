//
//  AboutView.swift
//  Geezmo
//
//  Created by Yaroslav Sedyshev on 18.07.2024.
//

import SwiftUI
import FirebaseAnalytics

struct AboutView: View {
    var viewModel: MainViewModel
    @State private var animateSymbol: Bool = false
    
    var body: some View {
        VStack {
            Spacer()

            VStack {
                Image(systemName: "av.remote")
                    .font(.system(size: 100, weight: .light, design: .rounded))
                    .foregroundColor(.accent)

                Text(
                    "\(Strings.General.shortAppName) " +
                    "\(Bundle.main.releaseVersionNumber) " +
                    "(\(Bundle.main.buildVersionNumber))"
                )
                .font(.system(size: Globals.bodyFontSize, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
                .padding(.top, 25)
                .lineSpacing(Globals.lineHeight)

                Text("\(Strings.About.appInfo)\n\(Strings.About.authorInfo)")
                    .font(.system(size: Globals.bodyFontSize, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.top, 5)
                    .lineSpacing(Globals.lineHeight)
            }
            .padding(.top, 25)

            Spacer()

            HStack(spacing: 5) {
                if viewModel.isCurrentLanguageKazakh() {
                    Text(Strings.About.madeIn)
                        .foregroundColor(.primary)
                    Image(systemName: "heart.fill")
                        .foregroundColor(.accent)
                        .symbolEffect(.bounce.up.byLayer, value: animateSymbol)
                        .onAppear {
                            animateSymbol.toggle()
                        }
                    Text(Strings.About.madeWith)
                        .foregroundColor(.primary)
                } else {
                    Text(Strings.About.madeWith)
                        .foregroundColor(.primary)
                    Image(systemName: "heart.fill")
                        .foregroundColor(.accent)
                        .symbolEffect(.bounce.up.byLayer, value: animateSymbol)
                        .onAppear {
                            animateSymbol.toggle()
                        }
                    Text(Strings.About.madeIn)
                        .foregroundColor(.primary)
                }
            }
            .font(.system(size: Globals.bodyFontSize, weight: .bold, design: .rounded))
            .multilineTextAlignment(.center)
            .lineSpacing(Globals.lineHeight)

            Spacer()
                .frame(height: 25)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemGray6))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "arrow.backward")
                    .font(.system(size: Globals.smallTitleSize, weight: .bold, design: .rounded))
                    .foregroundColor(.accent)
                    .padding(.top, 10)
                    .onTapGesture {
                        viewModel.navigationPath.removeAll()
                    }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Text(Strings.Titles.aboutApp)
                    .font(.system(size: Globals.smallTitleSize, weight: .bold, design: .rounded))
                    .foregroundColor(.accent)
                    .padding(.trailing, Globals.iconPadding)
                    .padding(.top, 10)
            }
        }
        .onAppear {
            Analytics.logEvent(AnalyticsEvents.PreferencesView.aboutViewStarted.rawValue, parameters: nil)
        }
    }
}

