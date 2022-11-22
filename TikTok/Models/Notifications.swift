//
//  Notifications.swift
//  TikTok
//
//  Created by Vladimir Kratinov on 2022-11-20.
//

import Foundation

enum NotificationType {
    case postLike(postName: String)
    case userFollow(username: String)
    case postComment(postName: String)
    
    var id: String {
        switch self {
        case .postLike: return "postLike"
        case .userFollow: return "userFollow"
        case .postComment: return "postComment"
        }
    }
}

struct Notification {
    let text: String
    let type: NotificationType
    let date: Date
    
    static func mockData() -> [Notification] {
        return Array(0...100).compactMap {
            Notification(
                text: "Something happened: \($0)",
                type: .postLike(postName: "Hello World Dummy Text Here"),
                date: Date()
            )
        }
    }
}