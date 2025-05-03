//
//  KeyButton.swift
//  Geezmo Watch App
//
//  Created by Yaroslav Sedyshev on 18.07.2024.
//

import SwiftUI

struct KeyButton: View {
    @Environment(MainViewModel.self) private var viewModel
    var type: KeyButtonType
    var body: some View {
        Button(action: {
            if type.repeatBehavior == .enabled {
                performAction(type: type, viewModel: viewModel)
            }
        }, label: {})
            .buttonStyle(KeyButtonStyle(type))
            .buttonRepeatBehavior(type.repeatBehavior)
            .disabled(getDisabled(type))
    }

    init(_ type: KeyButtonType) {
        self.type = type
    }
}

private extension KeyButton {
    func getDisabled(_ type: KeyButtonType) -> Bool {
        return false
    }
}

struct KeyButtonStyle: ButtonStyle {
    @Environment(MainViewModel.self) private var viewModel
    @State private var isBeingPressed: Bool = false
    @State private var isColorChanged: Bool = false
    var type: KeyButtonType

    func makeBody(configuration: Configuration) -> some View {
        Circle()
            .frame(width: Globals.buttonSize, height: Globals.buttonSize)
            .foregroundColor(getBackgroundColor(type: type, isColorChanged))
            .overlay {
                Image(systemName: type.getSystemName(viewModel: viewModel))
                    .foregroundColor(getForegroundColor(type: type, isColorChanged))
                    .font(.system(size: Globals.buttonFontSize, weight: .bold, design: .rounded))
            }
            .scaleEffect(getScale(type: type, isBeingPressed))
            ._onButtonGesture(pressing: { pressing in
                withAnimation(.bouncy(duration: pressing ? 0.25 : 0.35)) {
                    isBeingPressed = pressing
                }

                withAnimation(.smooth(duration: pressing ? 0.05 : 0.75)) {
                    isColorChanged = pressing
                }

                if isBeingPressed && type.hapticTypePressed != nil && viewModel.preferencesHapticFeedback {
                    WKInterfaceDevice.current().play(type.hapticTypePressed!)
                }

                if isBeingPressed {
                    performAction(type: type, viewModel: viewModel)
                }
            }, perform: {
                if type.hapticTypeReleased != nil && viewModel.preferencesHapticFeedback {
                    WKInterfaceDevice.current().play(type.hapticTypeReleased!)
                }

                if type == .powerOff {
                    if viewModel.isConnected {
                        viewModel.send(.turnOff)
                        Task { @MainActor in
                            viewModel.isConnected = false
                        }
                    }
                }
            })
    }

    init(_ type: KeyButtonType) {
        self.type = type
    }
}

private extension KeyButtonStyle {
    func getScale(type: KeyButtonType, _ pressed: Bool) -> CGFloat {
        return pressed ? 0.9 : 1.0
    }

    func getBackgroundColor(type: KeyButtonType, _ pressed: Bool) -> Color {
        return pressed ? .accent : type.plain ? .black : .geezmoDarkGray
    }

    func getForegroundColor(type: KeyButtonType, _ pressed: Bool) -> Color {
        guard type != .powerOff else {
            return pressed ? .white : type.highlighted ? .accent : Color(uiColor: .gray)
        }

        return pressed ? .white : type.highlighted ? .accent : Color(uiColor: .gray)
    }
}

private func performAction(type: KeyButtonType, viewModel: MainViewModel) {
    if type == .powerOff {
        return
    }
    if let keyTarget = type.keyTarget {
        viewModel.sendKey(keyTarget)
    }
    if let commonTarget = type.commonTarget {
        viewModel.send(commonTarget)
    }
}

