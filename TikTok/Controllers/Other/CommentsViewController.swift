//
//  CommentsViewController.swift
//  TikTok
//
//  Created by Vladimir Kratinov on 2022-11-04.
//

import UIKit

protocol CommentsViewControllerDelegate: AnyObject {
    func didTapCloseForComments(with viewController: CommentsViewController)
}

class CommentsViewController: UIViewController {

    private let post: PostModel
    weak var delegate: CommentsViewControllerDelegate?
    private var comments = [PostComment]()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            CommentTableViewCell.self,
            forCellReuseIdentifier: CommentTableViewCell.identifier
        )
        tableView.backgroundColor = .secondarySystemBackground
        return tableView
    }()

    private let closeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .tertiaryLabel
        button.setBackgroundImage(UIImage(systemName: "xmark"), for: .normal)
        return button
    }()

    init(post: PostModel) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)

        fetchPostComments()

        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        closeButton.frame = CGRect(x: view.width - 35,
                                   y: 10,
                                   width: 23,
                                   height: 23)
        tableView.frame = CGRect(x: 0,
                                 y: closeButton.bottom,
                                 width: view.width,
                                 height: view.width - closeButton.bottom)
    }

    @objc private func didTapClose() {
        delegate?.didTapCloseForComments(with: self)
    }

    func fetchPostComments() {
        // DatabaseManager.shared.fetchComment
        self.comments = PostComment.mockComments()
    }
}

extension CommentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = comments[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CommentTableViewCell.identifier,
            for: indexPath
        ) as? CommentTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: comment)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
