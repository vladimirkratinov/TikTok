//
//  HapticsManager.swift
//  TikTok
//
//  Created by Vladimir Kratinov on 2022-11-03.
//

import Foundation
import UIKit

final class HapticsManager {
    static let shared = HapticsManager()
    
    private init() {}
    
    //Public
    
    public func vibrateForSelection() {
        DispatchQueue.main.async {
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
    }
    
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        DispatchQueue.main.async {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type)
        }
    }
}
 
