//
//  PostCollectionViewCell.swift
//  TikTok
//
//  Created by Vladimir Kratinov on 2022-11-26.
//

import UIKit
import AVFoundation

class PostCollectionViewCell: UICollectionViewCell {
    /*
     1. Show a thumbnail of the video
     2. Click & Play the video
     3. Dequeue a cell for each video. The cell will be responsible for taking a post model
        and a cell for item function, converting it to the thumbnail
     */
    
    
    static let identifier = "PostCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        contentView.addSubview(imageView)
        contentView.backgroundColor = .secondarySystemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func configure(with post: PostModel) {
         // Derive child path
        StorageManager.shared.getDownloadURL(for: post) { result in
            /*
             Calling configures on the main thread and thumbnail generation is a reasonably heavy operation,
             so if you can extend the app to save a thumbnail when it uploads, it will be ideal.
             However, this is undoubtedly an unacceptable solution.
             */
            DispatchQueue.main.async {
                switch result {
                case .success(let url):
                    // Generate thumbnail
                    print("got url: \(url)")
                    let asset = AVAsset(url: url)
                    let generator = AVAssetImageGenerator(asset: asset)
                    
                    do {
                        let cgImage = try generator.copyCGImage(at: .zero, actualTime: nil)
                        // Assign CGImage to UIImageView
                        self.imageView.image = UIImage(cgImage: cgImage)
                    }
                    catch {
                        
                    }
                case .failure(let error):
                    print("failed to get download url: \(error)")
                }
            }
        }
        
        // Get download url
        
        
    }
}
