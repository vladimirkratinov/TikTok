//
//  Notifications.swift
//  TikTok
//
//  Created by Vladimir Kratinov on 2022-11-20.
//

import Foundation

struct Notification {
    let text: String
    let date: Date
    
    static func mockData() -> [Notification] {
        return Array(0...100).compactMap {
            Notification(text: "Something happened: \($0)", date: Date())
        }
    }
}
