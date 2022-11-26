//
//  StorageManager.swift
//  TikTok
//
//  Created by Vladimir Kratinov on 2022-11-03.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    public static let shared = StorageManager()
    
    private let storageBucket = Storage.storage().reference()
    
    private init() {}
    
    //Public
    
    public func getVideoURL(with identifier: String, completion: (URL) -> Void) {
        
    }
    
    public func uploadVideo(from url: URL, filename: String, completion: @escaping (Bool) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: "username") else { return }
        
        storageBucket.child("videos/\(username)/\(filename)").putFile(from: url) { _, error in
            completion(error == nil)
        }
    }
    
    public func uploadProfilePicture(with image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: "username") else { return }
        
        guard let imageData = image.pngData() else { return }
        
        let path = "profile_pictures/\(username)/picture.png"
        
        storageBucket.child(path).putData(imageData, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(error))
            }
            else {
                // get actual download URL
                self.storageBucket.child(path).downloadURL { url, error in
                    guard let url = url else {
                        // error handle
                        if let error = error {
                            completion(.failure(error))
                        }
                        return
                    }
                    // success
                    completion(.success(url))
                }
            }
        }
    }
    
    public func generateVideoName() -> String {
        let uuidString = UUID().uuidString
        let number = Int.random(in: 0...1000)
        let unixTimestamp = Date().timeIntervalSince1970
        
        return uuidString + "_\(number)_" + "\(unixTimestamp)" + ".mov"
    }
}
