//
//  HapticManager.swift
//  CryptoApp
//
//  Created by Bhavin Matreja on 12/05/25.
//

import Foundation
import SwiftUI

class HapticManager {
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}
