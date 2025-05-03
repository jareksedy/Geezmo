//
//  DeviceDiscoveryView.swift
//  Geezmo
//
//  Created by Yaroslav Sedyshev on 18.07.2024.
//

import SwiftUI
import ActivityIndicatorView
import FirebaseAnalytics

struct DeviceDiscoveryView: View {
    @State var viewModel: MainViewModel
    @State private var animateSymbol: Bool = false
    var body: some View {
        VStack {
            if viewModel.deviceDiscoveryFinished {
                if viewModel.devices.isEmpty {
                    Spacer()

                    LargeTipView(
                        systemName: "repeat.circle.fill",
                        color: .accent,
                        message: Strings.ConnectTV.notFound
                    )
                    
                    Spacer().frame(height: 5)
                    
                    Button(Strings.ConnectTV.rescan) {
                        viewModel.discoverDevices()
                    }
                    .padding(25)
                    .buttonStyle(.borderedProminent)
                    .font(.system(size: Globals.bodyFontSize, weight: .bold, design: .rounded))
                    
                    Spacer()
                } else {
                    List(Array(viewModel.devices)) { device in
                        Section(Strings.ConnectTV.discoveredDevices) {
                            Label("\(device.name)", systemImage: "tv")
                                .font(.system(size: Globals.bodyFontSize, weight: .medium, design: .rounded))
                                .foregroundColor(.secondary)
                                .onTapGesture {
                                    viewModel.pairDiscoveredDevice(with: device)
                                }
                        }
                    }
                }
            } else {
                Spacer()

                ActivityIndicatorView(
                    isVisible: $viewModel.isDiscoverDevicesActivityIndicatorShown,
                    type: .gradient([Color(uiColor: .systemGray6), .accent], .round, lineWidth: 6)
                )
                .frame(width: 175, height: 175)
                .foregroundColor(.accentColor)
                .padding(.top, 50)

                Spacer()

                TipView(
                    systemName: "exclamationmark.circle.fill",
                    color: .accent,
                    message: Strings.ConnectTV.importantNote
                )

                Spacer().frame(height: 25)
            }
        }
        .environment(\.defaultMinListRowHeight, 55)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemGray6))
        .scrollContentBackground(.hidden)
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
                Text(Strings.Titles.connectTV)
                    .font(.system(size: Globals.smallTitleSize, weight: .bold, design: .rounded))
                    .foregroundColor(.accent)
                    .padding(.trailing, Globals.iconPadding)
                    .padding(.top, 10)
            }
        }
        .onAppear {
            viewModel.discoverDevices()
            Analytics.logEvent(AnalyticsEvents.PreferencesView.connectTVStarted.rawValue, parameters: nil)
        }
    }
}

