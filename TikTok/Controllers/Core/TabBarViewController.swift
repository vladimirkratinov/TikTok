//
//  TabBarViewController.swift
//  TikTok
//
//  Created by Vladimir Kratinov on 2022-11-03.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    private var signInPresented = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpControllers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !signInPresented {
            presentSignInIfNeeded()
        }
    }
    
    private func presentSignInIfNeeded() {
        if !AuthManager.shared.isSignedIn {
            signInPresented = true
            let vc = SignInViewController()
            vc.competion = { [weak self] in
                self?.signInPresented = false
            }
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen // to avoid swipe back
            present(navVC, animated: false, completion: nil)
        }
    }
    
    private func setUpControllers() {
        let home = HomeViewController()
        let explore = ExploreViewController()
        let camera = CameraViewController()
        let notifications = NotificationsViewController()
        
        var urlString: String?
        if let cashedURLString = UserDefaults.standard.string(forKey: "profile_picture_url") {
            urlString = cashedURLString
        }
        let profile = ProfileViewController(
            user:
                User(
                    username: UserDefaults.standard.string(forKey: "username")?.uppercased() ?? "Me",
                    profilePictureURL: URL(string: urlString ?? ""),
                    identifier: UserDefaults.standard.string(forKey: "username")?.lowercased() ?? ""
                )
            
//            User(
//                username: "neo".uppercased(),
//                profilePictureURL: nil,
//                identifier: "neo"
//            )
        )
        
        notifications.title = "Notifications"
        profile.title = "Profile"
        
        let nav1 = UINavigationController(rootViewController: home)
        let nav2 = UINavigationController(rootViewController: explore)
        let nav3 = UINavigationController(rootViewController: notifications)
        let nav4 = UINavigationController(rootViewController: profile)
        let cameraNav =  UINavigationController(rootViewController: camera)
        
        nav1.navigationBar.backgroundColor = .clear
        nav1.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nav1.navigationBar.shadowImage = UIImage()
        
        cameraNav.navigationBar.backgroundColor = .clear
        cameraNav.navigationBar.setBackgroundImage(UIImage(), for: .default)
        cameraNav.navigationBar.shadowImage = UIImage()
        
        if #available(iOS 14.0, *) {
            nav1.navigationItem.backButtonDisplayMode = .minimal
            nav2.navigationItem.backButtonDisplayMode = .minimal
            nav3.navigationItem.backButtonDisplayMode = .minimal
            nav4.navigationItem.backButtonDisplayMode = .minimal
            cameraNav.navigationItem.backButtonDisplayMode = .minimal
        } else {
            // Fallback on earlier versions
        }
        
        nav1.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "safari"), tag: 2)
        camera.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "camera"), tag: 3)
        nav3.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "bell"), tag: 4)
        nav4.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person.circle"), tag: 5)

        nav1.navigationBar.tintColor =      .label
        nav2.navigationBar.tintColor =      .label
        cameraNav.navigationBar.tintColor = .label
        nav3.navigationBar.tintColor =      .label
        nav4.navigationBar.tintColor =      .label
        
        setViewControllers([nav1, nav2, cameraNav, nav3, nav4], animated: false)
    }
}
