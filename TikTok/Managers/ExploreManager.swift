//
//  ExploreManager.swift
//  TikTok
//
//  Created by Vladimir Kratinov on 2022-11-17.
//

import Foundation
import UIKit

/// Delegate interface to notify manager events
protocol ExploreManagerDelegate: AnyObject {
    /// Notify a view controller should be pushed
    /// - Parameter vc: The view controller to present
    func pushViewController(_ vc: UIViewController)
    /// Notify a hashtag element was tapped
    /// - Parameter hashtag: The hashtag that was tapped
    func didTapHashtag(_ hashtag: String)
}

/// Manager that handles explore view content
final class ExploreManager {
    /// Shared singleton instance
    static let shared = ExploreManager()
    
    /// Delegate to notify of events
    weak var delegate: ExploreManagerDelegate?
    
    /// Represents banner action type
    enum BannerAction: String {
        /// Post type
        case post
        /// Hashtag search type
        case hashtag
        /// Creator type
        case user
    }
    
    //MARK: - Public
    
    /// Gets explore data for banner
    /// - Returns: Return a collection of models
    public func getExploreBanners() -> [ExploreBannerViewModel] {
        guard let exploreData = parseExploreData() else {
            return []
        }
        
        return exploreData.banners.compactMap { model in
            ExploreBannerViewModel(
                image: UIImage(named: model.image),
                title: model.title
            ) { [weak self] in
                // handler
                guard let action = BannerAction(rawValue: model.action) else { return }
                
                DispatchQueue.main.async {
                    let vc = UIViewController()
                    vc.view.backgroundColor = .systemBackground
                    vc.title = action.rawValue.uppercased()
                    self?.delegate?.pushViewController(vc)
                }
                
                switch action {
                case .user:
                    // profile
                    break
                case .post:
                    // post
                    break
                case .hashtag:
                    // search for hashtag
                    break
                }
            }
        }
    }
    
    /// Gets explore data for trending posts
    /// - Returns: Return a collection of models
    public func getExploreTrendingPosts() -> [ExplorePostViewModel] {
        guard let exploreData = parseExploreData() else {
            return []
        }
        
        return exploreData.trendingPosts.compactMap { model in
            ExplorePostViewModel(
                thumbnailImage: UIImage(named: model.image),
                caption: model.caption
            ) { [weak self] in
                DispatchQueue.main.async {
                    // handler:
                    // use id to fetch post from firebase
                    let postID = model.id
                    let vc = PostViewController(model: PostModel(identifier: postID, user: User(
                        username: "wizardexiles",
                        profilePictureURL: nil,
                        identifier: UUID().uuidString
                    )))
                    self?.delegate?.pushViewController(vc)
                }
            }
        }
    }
    
    /// Gets explore data for popular creators
    /// - Returns: Return a collection of models
    public func getExploreCreators() -> [ExploreUserViewModel] {
        guard let exploreData = parseExploreData() else {
            return []
        }
        
        return exploreData.creators.compactMap { model in
            ExploreUserViewModel(
                profilePicture: UIImage(named: model.image),
                username: model.username,
                followerCount: model.followers_count
            ) { [weak self] in
                // handler:
                DispatchQueue.main.async {
                    let userID = model.id
                    // Fetch user object from firebase
                    let vc = ProfileViewController(user: User(username: "Joe", profilePictureURL: nil, identifier: userID))
                    self?.delegate?.pushViewController(vc)
                }
            }
        }
    }
    
    /// Gets explore data for hashtags
    /// - Returns: Return a collection of models
    public func getExploreHashtags() -> [ExploreHashtagViewModel] {
        guard let exploreData = parseExploreData() else {
            return []
        }
        
        return exploreData.hashtags.compactMap { model in
            ExploreHashtagViewModel(
                text: "#" + model.tag,
                icon: UIImage(systemName: model.image),
                count: model.count
            ) { [weak self] in
                DispatchQueue.main.async {
                    // handler:
                    self?.delegate?.didTapHashtag(model.tag)
                }
            }
        }
    }
    
    /// Gets explore data for popular posts
    /// - Returns: Return a collection of models
    public func getExplorePopularPosts() -> [ExplorePostViewModel] {
        guard let exploreData = parseExploreData() else {
            return []
        }
        
        return exploreData.popular.compactMap { model in
            ExplorePostViewModel(
                thumbnailImage: UIImage(named: model.image),
                caption: model.caption
            ) { [weak self] in
                DispatchQueue.main.async {
                    // handler:
                    // use id to fetch post from firebase
                    let postID = model.id
                    let vc = PostViewController(model: PostModel(identifier: postID, user: User(
                        username: "wizardexiles",
                        profilePictureURL: nil,
                        identifier: UUID().uuidString
                    )))
                    self?.delegate?.pushViewController(vc)
                }
            }
        }
    }
    
    /// Gets explore data for recent posts
    /// - Returns: Return a collection of models
    public func getExploreRecentPosts() -> [ExplorePostViewModel] {
        guard let exploreData = parseExploreData() else {
            return []
        }
        
        return exploreData.recentPosts.compactMap { model in
            ExplorePostViewModel(
                thumbnailImage: UIImage(named: model.image),
                caption: model.caption
            ) { [weak self] in
                DispatchQueue.main.async {
                    // handler:
                    // use id to fetch post from firebase
                    let postID = model.id
                    let vc = PostViewController(model: PostModel(identifier: postID, user: User(
                        username: "wizardexiles",
                        profilePictureURL: nil,
                        identifier: UUID().uuidString
                    )))
                    self?.delegate?.pushViewController(vc)
                }
            }
        }
    }
    
    //MARK: - Private
    
    /// Parse explore JSON data
    /// - Returns: Returns an optional response model
    private func parseExploreData() -> ExploreResponse? {
        guard let path = Bundle.main.path(forResource: "explore", ofType: "json") else {
            return nil
        }
        
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
