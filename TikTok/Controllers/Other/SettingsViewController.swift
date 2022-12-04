//
//  SettingsViewController.swift
//  TikTok
//
//  Created by Vladimir Kratinov on 2022-11-03.
//

import UIKit
import SafariServices

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "Cell"
        )
        table.register(
            SwitchTableViewCell.self,
            forCellReuseIdentifier: SwitchTableViewCell.identifier
        )
        return table
    }()

    var sections = [SettingsSection]()

    override func viewDidLoad() {
        super.viewDidLoad()

        sections = [
            SettingsSection(
                title: "Preferences",
                options: [
                    SettingsOption(title: "Save Videos", handler: { })
                ]),

            SettingsSection(
                title: "Information",
                options: [
                    SettingsOption(title: "Terms of Service", handler: { [weak self] in
                        DispatchQueue.main.async {
                            guard let url = URL(string: "https://www.tiktok.com/legal/terms-of-service") else { return }
                            let vc = SFSafariViewController(url: url)
                            self?.present(vc, animated: true)
                        }
                    }),
                    SettingsOption(title: "Privacy Policy", handler: { [weak self] in
                        DispatchQueue.main.async {
                            guard let url = URL(string: "https://www.tiktok.com/legal/privacy-policy") else { return }
                            let vc = SFSafariViewController(url: url)
                            self?.present(vc, animated: true)
                        }
                    })
                ])
        ]

        title = "Settings"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        createFooter()
    }

    func createFooter() {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: 100))
        let button = UIButton(frame: CGRect(x: (view.width-200)/2, y: 25, width: 200, height: 50))
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.addTarget(self, action: #selector(didTapSignOut), for: .touchUpInside)
        footer.addSubview(button)
        tableView.tableFooterView = footer
    }

    @objc func didTapSignOut() {
        let actionSheet = UIAlertController(
            title: "Sign Out",
            message: "Would you like to sign out?",
            preferredStyle: .actionSheet
        )
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { [weak self] _ in
            DispatchQueue.main.async {
                AuthManager.shared.signOut { success in
                    if success {
                        UserDefaults.standard.setValue(nil, forKey: "username")
                        UserDefaults.standard.setValue(nil, forKey: "profile_picture_url")

                        let vc = SignInViewController()
                        let navVC = UINavigationController(rootViewController: vc)
                        navVC.modalPresentationStyle = .fullScreen
                        self?.present(navVC, animated: true)

                        self?.navigationController?.popToRootViewController(animated: true)
                        self?.tabBarController?.selectedIndex = 0
                    } else {
                        // failed
                        let alert = UIAlertController(title: "Whoops", message: "Something went wrong when signing out. Please try again.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
                        self?.present(alert, animated: true)

                    }
                }
            }
        }))
        present(actionSheet, animated: true)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    // MARK: - TableView

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].options[indexPath.row]

        if model.title == "Save Videos" {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SwitchTableViewCell.identifier,
                for: indexPath
            ) as? SwitchTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.configure(with: SwitchCellViewModel(title: model.title, isOn: UserDefaults.standard.bool(forKey: "save_video")))
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = model.title
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = sections[indexPath.section].options[indexPath.row]
        model.handler()
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
}

extension SettingsViewController: SwitchTableViewCellDelegate {
    func switchTableViewCell(_ cell: SwitchTableViewCell, didUpdateSwitchTo isOn: Bool) {
        HapticsManager.shared.vibrateForSelection()
        UserDefaults.standard.setValue(isOn, forKey: "save_video")
    }
}
