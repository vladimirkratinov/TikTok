//
//  CaptionViewController.swift
//  TikTok
//
//  Created by Vladimir Kratinov on 2022-11-19.
//

import UIKit
import ProgressHUD

class CaptionViewController: UIViewController {

    let videoURL: URL
    
    init(videoURL: URL) {
        self.videoURL = videoURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Caption"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(didTapPost))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc func didTapPost() {
        // Generate a video name that is unique based on ID
        let newVideoName = StorageManager.shared.generateVideoName()
        
        ProgressHUD.show("Posting")
        
        // Upload Video
        StorageManager.shared.uploadVideo(from: videoURL, filename: newVideoName) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    // Update database
                    DatabaseManager.shared.insertPost(filename: newVideoName) { databaseUpdated in
                        if databaseUpdated {
                            HapticsManager.shared.vibrate(for: .success)
                            ProgressHUD.dismiss()
                            // Reset camera and switch to feed
                            self?.navigationController?.popToRootViewController(animated: true)
                            self?.tabBarController?.selectedIndex = 0
                            self?.tabBarController?.tabBar.isHidden = false
                        }
                        else {
                            HapticsManager.shared.vibrate(for: .error)
                            ProgressHUD.dismiss()
                            let alert = UIAlertController(title: "Whoops",
                                                          message: "We were unable to upload your video. Please try again",
                                                          preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
                            self?.present(alert, animated: true)
                        }
                    }
                }
                else {
                    HapticsManager.shared.vibrate(for: .error)
                    ProgressHUD.dismiss()
                    let alert = UIAlertController(title: "Whoops",
                                                  message: "We were unable to upload your video. Please try again",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
}
