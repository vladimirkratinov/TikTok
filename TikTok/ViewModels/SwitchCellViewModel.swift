//
//  SwitchCellViewModel.swift
//  TikTok
//
//  Created by Vladimir Kratinov on 2022-12-03.
//

import Foundation

struct SwitchCellViewModel {
    let title: String
    var isOn: Bool
    
    mutating func setOn(_ on: Bool) {
        self.isOn = on
    }
}
