//
//  MainViewModel.swift
//  Geezmo
//
//  Created by Yaroslav Sedyshev on 18.07.2024.
//

import SwiftUI
import WatchConnectivity
import WebOSClient
import SSDPClient
import FirebaseAnalytics

private enum Constants {
    static let volumeSubscriptionRequestId = "volumeSubscription"
}

@Observable final class MainViewModel: NSObject {
    var isDiscoverDevicesActivityIndicatorShown: Bool = true
    var isAppsLoadingActivityIndicatorShown: Bool = true
    var isAlertPresented: Bool = false
    var alertConfiguration: AlertConfiguration?
    var isToastPresented: Bool = false
    var toastConfiguration: ToastConfiguration?
    var colorButtonsPresented: Bool = false
    var playState: String?
    var deviceDiscoveryFinished: Bool = false
    var keyboardPresented: Bool = false
    var pinPadPresented: Bool = false
    var pairingCode: String? = nil
    var isFocused: Bool = false
    var isMuted: Bool = false
    var isScreenOff: Bool = false
    var isConnected: Bool = false
    var preferencesPresented: Bool = false
    var appListPresented: Bool = false
    var devices = Set<DeviceData>()
    var loadingAppsFinished: Bool = false
    var apps = [WebOSResponseApplication]()
    var navigationPath = [NavigationScreens]()
    var preferencesAlternativeView: Bool = AppSettings.shared.phoneAlternativeView {
        didSet {
            AppSettings.shared.phoneAlternativeView = preferencesAlternativeView
        }
    }
    var preferencesHapticFeedback: Bool = AppSettings.shared.phoneHaptics {
        didSet {
            AppSettings.shared.phoneHaptics = preferencesHapticFeedback
        }
    }
    
    var faqItems: [FAQItem] = [
        FAQItem(question: Strings.FAQ.q1, answer: Strings.FAQ.a1, isExpanded: true),
        FAQItem(question: Strings.FAQ.q2, answer: Strings.FAQ.a2, isExpanded: true),
        FAQItem(question: Strings.FAQ.q3, answer: Strings.FAQ.a3, isExpanded: true),
        FAQItem(question: Strings.FAQ.q4, answer: Strings.FAQ.a4, isExpanded: true),
        FAQItem(question: Strings.FAQ.q5, answer: Strings.FAQ.a5, isExpanded: true),
        FAQItem(question: Strings.FAQ.q6, answer: Strings.FAQ.a6, isExpanded: true),
        FAQItem(question: Strings.FAQ.q7, answer: Strings.FAQ.a7, isExpanded: true),
        FAQItem(question: Strings.FAQ.q8, answer: Strings.FAQ.a8, isExpanded: true),
        FAQItem(question: Strings.FAQ.q9, answer: Strings.FAQ.a9, isExpanded: true),
        FAQItem(question: Strings.FAQ.q10, answer: Strings.FAQ.a10, isExpanded: true),
    ]
    
    var session: WCSession
    private var tv: WebOSClient?
    var ssdpClient = SSDPDiscovery()
    var services: [SSDPService] = []
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        ssdpClient.delegate = self
        session.delegate = self
        session.activate()
        connectAndRegister()
    }
    
    func configure(
        url: URL,
        delegate: WebOSClientDelegate?,
        shouldPerformHeartbeat: Bool,
        heartbeatTimeInterval: TimeInterval,
        shouldLogActivity: Bool
    ) {
        tv =
        WebOSClient(
            url: url,
            delegate: delegate,
            shouldPerformHeartbeat: shouldPerformHeartbeat,
            heartbeatTimeInterval: heartbeatTimeInterval,
            shouldLogActivity: shouldLogActivity
        )
    }

    @discardableResult
    func send(_ target: WebOSTarget, id: String? = nil) -> String? {
        var newId: String?

        if let id {
            newId = tv?.send(target, id: id)
        } else {
            newId = tv?.send(target)
        }

        if case .turnOff = target {
            tv?.disconnect()
        }

        return newId
    }
    
    func send(jsonRequest: String) {
        tv?.send(jsonRequest: jsonRequest)
    }

    func sendKey(_ keyTarget: WebOSKeyTarget) {
        tv?.sendKey(keyTarget)
        Analytics.logEvent(AnalyticsEvents.General.buttonTapped.rawValue, parameters: nil)
    }
    
    func sendKey(keyData: Data) {
        tv?.sendKey(keyData: keyData)
        Analytics.logEvent(AnalyticsEvents.General.buttonTapped.rawValue, parameters: nil)
    }
    
    func disconnect() {
        tv?.disconnect()
        Task { @MainActor in
            withAnimation(.easeInOut(duration: Globals.TimeIntervals.disabled)) {
                isConnected = false
                colorButtonsPresented = false
                playState = nil
            }
        }
        Analytics.logEvent(AnalyticsEvents.General.tvDisconnected.rawValue, parameters: nil)
    }
    
    func connect() {
        tv?.connect()
        Analytics.logEvent(AnalyticsEvents.General.tvConnected.rawValue, parameters: nil)
    }

    func toast(_ configuration: ToastConfiguration) {
        Task { @MainActor in
            toastConfiguration = configuration
            isToastPresented = true
        }
    }
    
    func alert(_ configuration: AlertConfiguration) {
        Task { @MainActor in
            alertConfiguration = configuration
            isAlertPresented = true
        }
    }
}
