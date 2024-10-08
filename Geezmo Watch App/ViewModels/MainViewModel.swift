//
//  MainViewModel.swift
//  Geezmo Watch App
//
//  Created by Yaroslav Sedyshev on 18.07.2024.
//

import SwiftUI
import WatchConnectivity
import WebOSClient

final class MainViewModel: NSObject, ObservableObject {
    @Published var isConnected: Bool = false
    @Published var isMuted: Bool = false
    @Published var isScreenOff: Bool = false
    @Published var tvVolumeLevel: Double = 0
    @Published var isVolumeViewPresented: Bool = false
    @Published var preferencesAlternativeView: Bool = AppSettings.shared.watchAlternativeView {
        didSet {
            AppSettings.shared.watchAlternativeView = preferencesAlternativeView
        }
    }
    @Published var preferencesHapticFeedback: Bool = AppSettings.shared.watchHaptics {
        didSet {
            AppSettings.shared.watchHaptics = preferencesHapticFeedback
        }
    }

    private var session: WCSession

    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }
}

extension MainViewModel {
    func sendWakeUpMessage() {
        session.sendMessage(["WAKE_UP": true], replyHandler: nil)
    }

    func send(_ target: WebOSTarget) {
        guard let targetJSON = target.request.jsonWithId(UUID().uuidString) else {
            return
        }
//        if targetJSON.contains("turnOffScreen") {
//            session.sendMessage([.screenState: isScreenOff], replyHandler: nil)
//            return
//        }
        if targetJSON.contains("turnOff") {
            session.sendMessage([.service: "TV_ON_OFF"], replyHandler: nil)
            return
        }
        session.sendMessage([.commonTarget: targetJSON], replyHandler: nil) { [weak self] _ in
            guard let self else {
                return
            }
            Task { @MainActor in
                self.isConnected = false
            }
        }
    }

    func sendKey(_ target: WebOSKeyTarget) {
        guard let targetData = target.request else {
            return
        }
        let targetString = String(decoding: targetData, as: UTF8.self)
        session.sendMessage([.keyTarget: targetString], replyHandler: nil) { [weak self] _ in
            guard let self else {
                return
            }
            Task { @MainActor in
                self.isConnected = false
            }
        }
    }

    func presentVolumeView() {
        isVolumeViewPresented = true
    }
}

extension MainViewModel: WCSessionDelegate {
    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        Task { @MainActor in
            isConnected = error == nil ? true : false
        }
    }

    func session(
        _ session: WCSession,
        didReceiveMessage message: [String: Any]
    ) {
        if let volume = message["volumeChanged"] as? Double {
            Task { @MainActor in
                tvVolumeLevel = volume
            }
        }
        if let muteState = message[.muteState] as? Bool {
            Task { @MainActor in
                isMuted = muteState
            }
        }
        if let screenState = message[.screenState] as? Bool {
            Task { @MainActor in
                isScreenOff = screenState
            }
        }
    }
}

