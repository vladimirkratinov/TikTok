//
//  ExploreResponse.swift
//  TikTok
//
//  Created by Vladimir Kratinov on 2022-12-04.
//

import Foundation

struct ExploreResponse: Codable {
    let banners: [Banner]
    let trendingPosts: [Post]
    let creators: [Creator]
    let recentPosts: [Post]
    let hashtags: [Hashtag]
    let popular: [Post]
    let recommended: [Post]
}
