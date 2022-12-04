//
//  HapticsManager.swift
//  TikTok
//
//  Created by Vladimir Kratinov on 2022-11-03.
//

import Foundation
import UIKit

/// Object that deals with haptic feedback
final class HapticsManager {
    /// Shared singleton instance
    static let shared = HapticsManager()
    
    /// Private constructor
    private init() {}
    
    //MARK: - Public
    
    ///Vibrate for light selection of item
    public func vibrateForSelection() {
        DispatchQueue.main.async {
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
    }
    
    /// Trigger feedback vibration based on event type
    /// - Parameter type: Success, Error, or Warning type
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        DispatchQueue.main.async {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type)
        }
    }
}
 
