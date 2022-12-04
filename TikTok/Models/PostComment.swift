//
//  PostComment.swift
//  TikTok
//
//  Created by Vladimir Kratinov on 2022-11-04.
//

import Foundation

struct PostComment {
    let text: String
    let user: User
    let date: Date

    static func mockComments() -> [PostComment] {
        let user = User(username: "wizardexiles", profilePictureURL: nil, identifier: UUID().uuidString)

        var comments = [PostComment]()

        let text = [
            "This is not ok",
            "Are you sure? I think it's cool enough",
            "I don't understand anything lol"
        ]

        for comment in text {
            comments.append(PostComment(text: comment, user: user, date: Date()))
        }

        return comments
    }
}
