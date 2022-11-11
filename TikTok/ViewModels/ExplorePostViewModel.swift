//
//  ExplorePostViewModel.swift
//  TikTok
//
//  Created by Vladimir Kratinov on 2022-11-11.
//

import Foundation
import UIKit

struct ExplorePostViewModel {
    let thumbnailImage: UIImage?
    let caption: String
    let handler: (() -> Void)
}
