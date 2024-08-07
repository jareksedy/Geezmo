//
//  MainViewModel+.swift
//  Geezmo
//
//  Created by Ярослав Седышев on 18.07.2024.
//

import SwiftUI
import WebOSClient

extension MainViewModel {
    func connectAndRegister(forcingConnection: Bool = false) {
        guard let host = AppSettings.shared.host,
              let url = URL(string: "wss://\(host):3001"),
              !isConnected || forcingConnection 
        else { return }
        
        tv?.disconnect()

        tv = WebOSClient(
            url: url,
            delegate: self,
            shouldPerformHeartbeat: true,
            heartbeatTimeInterval: 30,
            shouldLogActivity: true
        )

        tv?.connect()
        tv?.send(
            .register(pairingType: .pin, clientKey: AppSettings.shared.clientKey),
            id: Globals.SubscriptionIds.registrationRequestId
        )
    }

    func disconnect() {
        tv?.disconnect()
        Task { @MainActor in
            isConnected = false
        }
    }
    
    private func requestLocalNetworkAuthorization(_ completion: ((Bool) -> Void)?) {
        let authorization = LocalNetworkAuthorization()
        authorization.requestAuthorization { granted in
            completion?(granted)
        }
    }
    
    func navigateToDeviceDiscoveryViewIfNeeded(_ context: DeviceDiscoveryNavigationContext) {
        requestLocalNetworkAuthorization { [weak self] granted in
            guard let self else { return }
            if granted {
                if context == .fromMainView && AppSettings.shared.host == nil {
                    preferencesPresented = true
                } else if context == .fromPreferences && AppSettings.shared.host == nil {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Globals.TimeIntervals.minimal) { [weak self] in
                        guard let self else { return }
                        navigationPath.append(.discover)
                    }
                }
            } else {
                if context == .fromMainView {
                    alert(.multicastPermissionsDenied)
                }
            }
        }
    }

    func handleScenePhase(_ scenePhase: ScenePhase) {
        switch scenePhase {
        case .active: connectAndRegister(forcingConnection: true)
        case .background: disconnect()
        default: break
        }
    }

    func discoverDevices() {
        deviceDiscoveryFinished = false
        devices.removeAll()
        ssdpClient.discoverService()
    }

    func subscribeAll() {
        tv?.send(
            .registerRemoteKeyboard,
            id: Globals.SubscriptionIds.remoteKeyboardRequestId
        )

        tv?.send(
            .getForegroundAppMediaStatus(subscribe: true),
            id: Globals.SubscriptionIds.mediaPlaybackInfoRequestId
        )
    }
    
    func showConnectionStatus() {
        toast(isConnected ? .connected : .disconnected)
    }
    
    func pairDiscoveredDevice(with device: DeviceData) {
        disconnect()
        AppSettings.shared.host = device.host
        AppSettings.shared.mac = device.mac
        AppSettings.shared.clientKey = nil
        preferencesPresented = false
        connectAndRegister(forcingConnection: true)
    }

    func resetConnectionData() {
        disconnect()
        AppSettings.shared.host = nil
        AppSettings.shared.clientKey = nil
        preferencesPresented = false
        DispatchQueue.main.asyncAfter(deadline: .now() + Globals.TimeIntervals.medium) { [weak self] in
            guard let self else { return }
            preferencesPresented = true
        }
    }

    func setHostManually(host: String) {
        disconnect()
        AppSettings.shared.host = host
        AppSettings.shared.clientKey = nil
        preferencesPresented = false
        connectAndRegister(forcingConnection: true)
    }
    
    func wakeMeUp() {
        guard let host = AppSettings.shared.host,
              let mac = AppSettings.shared.mac else {
            return
        }
        WakeOnLANService
            .shared
            .wakeDevice(at: host, macAddress: mac) { [weak self] _ in
                guard let self else { return }
                connectAndRegister(forcingConnection: true)
            }
    }
}
