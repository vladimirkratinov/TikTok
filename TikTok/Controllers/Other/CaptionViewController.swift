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
    
    private let captionTextView: UITextView = {
        let textView = UITextView()
        textView.contentInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        textView.backgroundColor = .secondarySystemBackground
        textView.layer.cornerRadius = 8
        textView.layer.masksToBounds = true
        textView.font = .systemFont(ofSize: 16, weight: .medium)
        return textView
    }()
    
    //MARK: - Init
    
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapPost))
        view.addSubview(captionTextView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        captionTextView.frame = CGRect(x: 5, y: view.safeAreaInsets.top + 5, width: view.width - 10, height: 150).integral
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captionTextView.becomeFirstResponder()
    }
    
    @objc func didTapPost() {
        captionTextView.resignFirstResponder()
        let caption = captionTextView.text ?? ""
        // Generate a video name that is unique based on ID
        let newVideoName = StorageManager.shared.generateVideoName()
        ProgressHUD.show("Posting")
        
        // Upload Video
        StorageManager.shared.uploadVideo(from: videoURL, filename: newVideoName) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    // Update database
                    DatabaseManager.shared.insertPost(filename: newVideoName, caption: caption) { databaseUpdated in
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
