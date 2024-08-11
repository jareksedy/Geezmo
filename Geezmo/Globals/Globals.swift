//
//  Globals.swift
//  Geezmo
//
//  Created by Ярослав Седышев on 18.07.2024.
//

import SwiftUI

enum Globals {
    enum SubscriptionIds {
        static let registrationRequestId = "registrationSubscription"
        static let remoteKeyboardRequestId = "remoteKeyboardSubscription"
        static let mediaPlaybackInfoRequestId = "mediaPlaybackInfoSubscription"
    }
    
    enum TimeIntervals {
        static let minimal: TimeInterval = 0.1
        static let medium: TimeInterval = 0.25
        static let disabled: TimeInterval = 0.5
    }
    
    static let smallTitleSize: CGFloat = 18
    static let largetTitleSize: CGFloat = 36
    
    static let bodyFontSize: CGFloat = 18
    
    static let iconSize: CGFloat = 12
    static let iconPadding: CGFloat = 15
    
    static var buttonSize: CGFloat {
        return 70
    }
    
    static var lineHeight: CGFloat {
        return 3
    }
    
    static var buttonSpacing: CGFloat {
        return 4
    }
    
    static var buttonFontSize: CGFloat {
        return 16
    }
    
    static var bottomPadding: CGFloat {
        return 30
    }
}

