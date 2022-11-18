//
//  ExploreManager.swift
//  TikTok
//
//  Created by Vladimir Kratinov on 2022-11-17.
//

import Foundation
import UIKit

protocol ExploreManagerDelegate: AnyObject {
    func pushViewController(_ vc: UIViewController)
    func didTapHashtag(_ hashtag: String)
}

final class ExploreManager {
    static let shared = ExploreManager()
    
    weak var delegate: ExploreManagerDelegate?
    
    enum BannerAction: String {
        case post
        case hashtag
        case user
    }
    
    //MARK: - Public
    
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
                    let vc = PostViewController(model: PostModel(identifier: postID))
                    self?.delegate?.pushViewController(vc)
                }
            }
        }
    }
    
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
                    let vc = PostViewController(model: PostModel(identifier: postID))
                    self?.delegate?.pushViewController(vc)
                }
            }
        }
    }
    
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
                    let vc = PostViewController(model: PostModel(identifier: postID))
                    self?.delegate?.pushViewController(vc)
                }
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
