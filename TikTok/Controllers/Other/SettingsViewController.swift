//
//  SettingsViewController.swift
//  TikTok
//
//  Created by Vladimir Kratinov on 2022-11-03.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                    }
                    else {
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "Hello World"
        return cell
    }
}
