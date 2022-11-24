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

class Notification {
    var identifier = UUID().uuidString
    var isHidden = false
    let text: String
    let type: NotificationType
    let date: Date
    
    init(isHidden: Bool = false, text: String, type: NotificationType, date: Date) {
        self.isHidden = isHidden
        self.text = text
        self.type = type
        self.date = date
    }
    
    static func mockData() -> [Notification] {
        let first = Array(0...4).compactMap {
            Notification(
                text: "Comment Post: \($0)",
                type: .postComment(postName: "This is Comment post"),
                date: Date()
            )
        }
        
        let second = Array(0...4).compactMap {
            Notification(
                text: "Username: \($0)",
                type: .userFollow(username: "Wizardexiles"),
                date: Date()
            )
        }
        
        let third = Array(0...4).compactMap {
            Notification(
                text: "Like Post: \($0)",
                type: .postLike(postName: "This is Like post"),
                date: Date()
            )
        }
        
        return first + second + third
    }
}
