//
//  ExploreHashtagViewModel.swift
//  TikTok
//
//  Created by Vladimir Kratinov on 2022-11-11.
//

import Foundation
import UIKit

struct ExploreHashtagViewModel {
    let text: String
    let icon: UIImage?
    let count: Int // number of posts associated with tag
    let handler: (() -> Void)
}
