//
//  ExploreUserViewModel.swift
//  TikTok
//
//  Created by Vladimir Kratinov on 2022-11-11.
//

import Foundation
import UIKit

struct ExploreUserViewModel {
    let profilePicture: UIImage?
    let username: String
    let followerCount: Int
    let handler: (() -> Void)
}
