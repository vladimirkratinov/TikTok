//
//  NotificationsViewController.swift
//  TikTok
//
//  Created by Vladimir Kratinov on 2022-11-03.
//

import UIKit

class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let notificationsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.text = "No Notifications"
        label.isHidden = true
        label.textAlignment = .center
        return label
    }()

    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true

        table.register(
            NotificationsUserFollowTableViewCell.self,
            forCellReuseIdentifier: NotificationsUserFollowTableViewCell.identifier)

        table.register(
            NotificationsPostCommentTableViewCell.self,
            forCellReuseIdentifier: NotificationsPostCommentTableViewCell.identifier)

        table.register(
            NotificationsPostLikeTableViewCell.self,
            forCellReuseIdentifier: NotificationsPostLikeTableViewCell.identifier)

        return table
    }()

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.tintColor = .label
        spinner.startAnimating()
        return spinner
    }()

    var notifications = [Notification]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(tableView)
        view.addSubview(notificationsLabel)
        view.addSubview(spinner)

        tableView.delegate = self
        tableView.dataSource = self

        let control = UIRefreshControl()        // refreshing page when pulling down.
        control.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableView.refreshControl = control

        fetchNotifications()
    }

    @objc func didPullToRefresh(_ sender: UIRefreshControl) {
        sender.beginRefreshing()

        DatabaseManager.shared.getNotifications { [weak self] notifications in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self?.notifications = notifications
                self?.tableView.reloadData()
                sender.endRefreshing()
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        notificationsLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        notificationsLabel.center = view.center
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = view.center
    }

    func fetchNotifications() {
        DatabaseManager.shared.getNotifications { [weak self] notifications in
            DispatchQueue.main.async {
                self?.spinner.stopAnimating()
                self?.spinner.isHidden = true
                self?.notifications = notifications
                self?.updateUI()
            }
        }
    }

    func updateUI() {
        if notifications.isEmpty {
            notificationsLabel.isHidden = false
            tableView.isHidden = true
        } else {
            notificationsLabel.isHidden = true
            tableView.isHidden = false
        }

        tableView.reloadData()
    }

    // Table View

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = notifications[indexPath.row]

        switch model.type {

        case .postLike(let postName):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NotificationsPostLikeTableViewCell.identifier,
                for: indexPath
            ) as? NotificationsPostLikeTableViewCell else {
                return tableView.dequeueReusableCell(
                    withIdentifier: "cell",
                    for: indexPath
                )
            }
            cell.delegate = self                                // postLike delegate
            cell.configure(with: postName, model: model)
            return cell

        case .userFollow(let username):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NotificationsUserFollowTableViewCell.identifier,
                for: indexPath
            ) as? NotificationsUserFollowTableViewCell else {
                return tableView.dequeueReusableCell(
                    withIdentifier: "cell",
                    for: indexPath
                )
            }
            cell.delegate = self                                // follow delegate
            cell.configure(with: username, model: model)
            return cell

        case .postComment(let postName):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NotificationsPostCommentTableViewCell.identifier,
                for: indexPath
            ) as? NotificationsPostCommentTableViewCell else {
                return tableView.dequeueReusableCell(
                    withIdentifier: "cell",
                    for: indexPath
                )
            }
            cell.delegate = self                                // postComment delegate
            cell.configure(with: postName, model: model)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }

        let model = notifications[indexPath.row]
        model.isHidden = true

        DatabaseManager.shared.markNotificationAsHidden(notificationID: model.identifier) { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    self?.notifications = self?.notifications.filter { $0.isHidden == false } ?? []  // filtering hidden data.
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .none)
                    tableView.endUpdates()
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension NotificationsViewController: NotificationsUserFollowTableViewCellDelegate {
    func notificationsUserFollowTableViewCell(_ cell: NotificationsUserFollowTableViewCell, didTapFollowFor username: String) {
        DatabaseManager.shared.updateRelationship(
            for: User(
                username: username,
                profilePictureURL: nil,
                identifier: UUID().uuidString),
            follow: true
        ) { success in
            if !success {
                // something went wrong
            }
        }
    }

    func notificationsUserFollowTableViewCell(_ cell: NotificationsUserFollowTableViewCell, didTapAvatarFor username: String) {
        HapticsManager.shared.vibrateForSelection()
        let vc = ProfileViewController(
            user: User(username: username,
                       profilePictureURL: nil,
                       identifier: "123"))
        vc.title = username.uppercased()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension NotificationsViewController: NotificationsPostLikeTableViewCellDelegate {
    func notificationsPostLikeTableViewCell(_ cell: NotificationsPostLikeTableViewCell, didTapPostWith identifier: String) {
        openPost(with: identifier)
    }
}

extension NotificationsViewController: NotificationsPostCommentTableViewCellDelegate {
    func notificationsPostCommentTableViewCellDelegate(_ cell: NotificationsPostCommentTableViewCell, didTapPostWith identifier: String) {
        openPost(with: identifier)
    }
}

extension NotificationsViewController {
    func openPost(with identifier: String) {
        // resolve the post model from database
        HapticsManager.shared.vibrateForSelection()
        let vc = PostViewController(model: PostModel(identifier: identifier, user: User(
            username: "wizardexiles",
            profilePictureURL: nil,
            identifier: UUID().uuidString
        )))
        vc.title = "Video"
        navigationController?.pushViewController(vc, animated: true)
    }
}
