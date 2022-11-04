//
//  AuthenticationManager.swift
//  TikTok
//
//  Created by Vladimir Kratinov on 2022-11-03.
//

import Foundation
import FirebaseAuth

final class AuthManager {
    public static let shared = AuthManager()
    
    private init() {}
    
    enum SignInMethod {
        case email
        case facebook
        case google
    }
    
    //Public
    
    public func signIn(with method: SignInMethod) {
        
    }
    
    public func signOut() {
        
    }
}
