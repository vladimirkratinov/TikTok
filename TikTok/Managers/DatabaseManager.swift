//
//  DatabaseManager.swift
//  TikTok
//
//  Created by Vladimir Kratinov on 2022-11-03.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    public static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    private init() {}
    
    //Public
    
    public func getAllUsers(completion: ([String]) -> Void) {
        
    }
}
