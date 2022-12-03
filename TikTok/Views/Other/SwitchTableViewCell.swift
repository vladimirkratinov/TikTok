//
//  SwitchTableViewCell.swift
//  TikTok
//
//  Created by Vladimir Kratinov on 2022-12-03.
//

import UIKit

protocol SwitchTableViewCellDelegate: AnyObject {
    func switchTableViewCell(_ cell: SwitchTableViewCell, didUpdateSwitchTo isOn: Bool)
}

class SwitchTableViewCell: UITableViewCell {
    static let identifier = "SwitchTableViewCell"
    
    weak var delegate: SwitchTableViewCellDelegate?
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let _switch: UISwitch = {
        let _switch = UISwitch()
        _switch.onTintColor = .systemBlue
        _switch.isOn = UserDefaults.standard.bool(forKey: "save_video")
        return _switch
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        selectionStyle = .none
        contentView.addSubview(label)
        contentView.addSubview(_switch)
        _switch.addTarget(self, action: #selector(didChangeSwitchValue), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didChangeSwitchValue(_ sender: UISwitch) {
        delegate?.switchTableViewCell(self, didUpdateSwitchTo: sender.isOn)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.sizeToFit()
        label.frame = CGRect(x: 10, y: 0, width: label.width, height: contentView.height)
        
        _switch.sizeToFit()
        _switch.frame = CGRect(x: contentView.width - _switch.width - 10, y: 6, width: _switch.width, height: _switch.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    func configure(with viewModel: SwitchCellViewModel) {
        label.text = viewModel.title
        _switch.isOn = viewModel.isOn
    }
}
