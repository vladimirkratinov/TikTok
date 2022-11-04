//
//  PostViewController.swift
//  TikTok
//
//  Created by Vladimir Kratinov on 2022-11-03.
//

import UIKit

class PostViewController: UIViewController {
    
    let model: PostModel
    
    init(model: PostModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let colors: [UIColor] = [
            .red, .green, .black, .orange, .systemPink, .blue, .white
        ]
        view.backgroundColor = colors.randomElement()
    }
}
