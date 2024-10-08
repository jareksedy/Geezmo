//
//  Globals.swift
//  Geezmo Watch App
//
//  Created by Yaroslav Sedyshev on 18.07.2024.
//

import SwiftUI

enum Globals {
    /// Device relative constants
    static let deviceHeight = WKInterfaceDevice.current().screenBounds.size.height
    static var smallerDevices: Bool { deviceHeight < 240 }

    static var negativeTopPadding: CGFloat = -11

    static var topPadding: CGFloat {
        if deviceHeight > 250 { return 65 }                         // 49mm Ultra
        if deviceHeight < 250 && deviceHeight > 240 { return 60 }   // 45mm
        if deviceHeight < 240 && deviceHeight > 210 { return 55 }   // 41mm
        return 50                                                   // 40mm and less
    }

    static var buttonSize: CGFloat {
        if deviceHeight > 250 { return 55 }                         // 49mm Ultra
        if deviceHeight < 250 && deviceHeight > 240 { return 55 }   // 45mm
        if deviceHeight < 240 && deviceHeight > 210 { return 48 }   // 41mm
        return 45                                                   // 40mm and less
    }

    static var buttonSpacing: CGFloat {
        if deviceHeight > 250 { return 4 }                          // 49mm Ultra
        if deviceHeight < 250 && deviceHeight > 240 { return 4 }    // 45mm
        if deviceHeight < 240 && deviceHeight > 210 { return 3 }    // 41mm
        return 3                                                    // 40mm and less
    }

    static var buttonFontSize: CGFloat {
        if deviceHeight > 250 { return 18 }                          // 49mm Ultra
        if deviceHeight < 250 && deviceHeight > 240 { return 18 }    // 45mm
        if deviceHeight < 240 && deviceHeight > 210 { return 16 }    // 41mm
        return 14                                                    // 40mm and less
    }
}
