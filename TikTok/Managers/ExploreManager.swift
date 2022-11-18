//
//  ExploreManager.swift
//  TikTok
//
//  Created by Vladimir Kratinov on 2022-11-17.
//

import Foundation
import UIKit

final class ExploreManager {
    static let shared = ExploreManager()
    
    //MARK: - Public
    
    public func getExploreBanners() -> [ExploreBannerViewModel] {
        guard let exploreData = parseExploreData() else {
            return []
        }
        
        return exploreData.banners.compactMap {
            ExploreBannerViewModel(
                image: UIImage(named: $0.image),
                title: $0.title
            ) {
                //empty hamdler
            }
        }
    }
    
    public func getExploreCreators() -> [ExploreUserViewModel] {
        guard let exploreData = parseExploreData() else {
            return []
        }
        
        return exploreData.creators.compactMap {
            ExploreUserViewModel(
                profilePicture: UIImage(named: $0.image),
                username: $0.username,
                followerCount: $0.followers_count
            ) {
                //empty handler
            }
        }
    }
    
    public func getExploreHashtags() -> [ExploreHashtagViewModel] {
        guard let exploreData = parseExploreData() else {
            return []
        }
        
        return exploreData.hashtags.compactMap {
            ExploreHashtagViewModel(
                text: "#" + $0.tag,
                icon: UIImage(systemName: $0.image),
                count: $0.count
            ) {
                //empty handler
            }
        }
    }
    
    public func getExploreTrendingPosts() -> [ExplorePostViewModel] {
        guard let exploreData = parseExploreData() else {
            return []
        }
        
        return exploreData.trendingPosts.compactMap {
            ExplorePostViewModel(
                thumbnailImage: UIImage(named: $0.image),
                caption: $0.caption
            ) {
                //empty handler
            }
        }
    }
    
    public func getExploreRecentPosts() -> [ExplorePostViewModel] {
        guard let exploreData = parseExploreData() else {
            return []
        }
        
        return exploreData.recentPosts.compactMap {
            ExplorePostViewModel(
                thumbnailImage: UIImage(named: $0.image),
                caption: $0.caption
            ) {
                //empty handler
            }
        }
    }
    
    public func getExplorePopularPosts() -> [ExplorePostViewModel] {
        guard let exploreData = parseExploreData() else {
            return []
        }
        
        return exploreData.popular.compactMap {
            ExplorePostViewModel(
                thumbnailImage: UIImage(named: $0.image),
                caption: $0.caption
            ) {
                //empty handler
            }
        }
    }
    
    //MARK: - Private
    
    private func parseExploreData() -> ExploreResponse? {
        guard let path = Bundle.main.path(forResource: "explore", ofType: "json") else {
            return nil
        }
        
//        print(path)
        
        do {
            if #available(iOS 16.0, *) {
                let url = URL(filePath: path)
                let data = try Data(contentsOf: url)
                return try JSONDecoder().decode(ExploreResponse.self, from: data)
            } else {
                // Fallback on earlier versions
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url)
                return try JSONDecoder().decode(ExploreResponse.self, from: data)
            }
        }
        catch {
            print(error)
            return nil
        }
    }
}

struct ExploreResponse: Codable {
    let banners:       [Banner]
    let trendingPosts: [Post]
    let creators:      [Creator]
    let recentPosts:   [Post]
    let hashtags:      [Hashtag]
    let popular:       [Post]
    let recommended:   [Post]
}

struct Banner: Codable {
    let id:     String
    let image:  String
    let title:  String
    let action: String
}

struct Post: Codable {
    let id:      String
    let image:   String
    let caption: String
}

struct Hashtag: Codable {
    let image:  String
    let tag:    String
    let count:  Int
}

struct Creator: Codable {
    let id:               String
    let image:            String
    let username:         String
    let followers_count:  Int
}
