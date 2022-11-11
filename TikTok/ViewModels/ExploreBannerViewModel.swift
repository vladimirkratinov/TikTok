//
//  ExploreBannerViewModel.swift
//  TikTok
//
//  Created by Vladimir Kratinov on 2022-11-11.
//

import Foundation
import UIKit

struct ExploreBannerViewModel {
    let image: UIImage?
    let title: String
    let handler: (() -> Void)
}
