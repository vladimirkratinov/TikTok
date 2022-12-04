//
//  AuthButton.swift
//  TikTok
//
//  Created by Vladimir Kratinov on 2022-11-18.
//

import UIKit

class AuthButton: UIButton {

    enum ButtonType {
        case signIn
        case signUp
        case plain

        var title: String {
            switch self {
            case .signIn: return "Sign In"
            case .signUp: return "Sign Up"
            case .plain: return "-"
            }
        }
    }

    let type: ButtonType

    init(type: ButtonType, title: String?) {
        self.type = type
        super.init(frame: .zero)
        if let title = title {
            setTitle(title, for: .normal)
        }
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        if type != .plain {
            setTitle(type.title, for: .normal)
        }

        setTitleColor(.white, for: .normal)

        switch type {
        case .signIn: backgroundColor = .systemBlue
        case .signUp: backgroundColor = .systemGreen
        case .plain:
            setTitleColor(.link, for: .normal)
            backgroundColor = .clear
        }
        titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
}
