//
//  NotificationsUserFollowTableViewCell.swift
//  TikTok
//
//  Created by Vladimir Kratinov on 2022-11-20.
//

import UIKit

class NotificationsUserFollowTableViewCell: UITableViewCell {

    static let identifier = "NotificationsUserFollowTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(with username: String) {
        
    }
}
