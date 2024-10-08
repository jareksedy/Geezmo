//
//  WCSessionDelegate.swift
//  Geezmo
//
//  Created by Yaroslav Sedyshev on 18.07.2024.
//

import SwiftUI
import WatchConnectivity

extension MainViewModel: WCSessionDelegate {
    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {}

    func session(
        _ session: WCSession,
        didReceiveMessage message: [String: Any]
    ) {
        connectAndRegister()
        
        if let serviceString = message[.service] as? String {
            if serviceString == "TV_ON_OFF" {
                powerOnOrOff()
            }
        }
        
        if let shouldTurnOnScreen = message[.screenState] as? Bool {
            send(shouldTurnOnScreen ? .screenOn : .screenOff)
        }

        if let targetString = message[.keyTarget] as? String,
           let targetData = targetString.data(using: .utf8) {
            sendKey(keyData: targetData)
        }

        if let targetJSON = message[.commonTarget] as? String {
            send(jsonRequest: targetJSON)
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        session.activate()
    }

    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
}

