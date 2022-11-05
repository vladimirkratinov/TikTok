//
//  PostModel.swift
//  TikTok
//
//  Created by Vladimir Kratinov on 2022-11-04.
//

import Foundation

struct PostModel {
    let identifier: String
    
    let user = User(
        username: "wizardexiles",
        profilePictureURL: nil,
        identifier: UUID().uuidString
    )
    
    var isLikedByCurrentUser = false
    
    static func mockModels() -> [PostModel] {
        var posts = [PostModel]()
        for _ in 0...100 {
            let post = PostModel(identifier: UUID().uuidString)
            posts.append(post)
        }
        return posts
    }
}
