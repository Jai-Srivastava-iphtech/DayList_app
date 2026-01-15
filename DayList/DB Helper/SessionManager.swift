//
//  SessionManager.swift
//  DayList
//
//  iOS 12+ Compatible Session Manager
//

import Foundation

class SessionManager {
    
    static let shared = SessionManager()
    
    private let userIdKey = "currentUserId"
    private let emailKey = "userEmail"
    private let isLoggedInKey = "isLoggedIn"
    
    private init() {}
    
    // MARK: - Check Login Status
    var isLoggedIn: Bool {
        return UserDefaults.standard.bool(forKey: isLoggedInKey)
    }
    
    var currentUserId: String? {
        return KeychainManager.shared.get(key: userIdKey)
    }
    
    var currentEmail: String? {
        return KeychainManager.shared.get(key: emailKey)
    }
    
    // MARK: - Create Session (After Login/Signup)
    func createSession(userId: String, email: String) {
        // Save to Keychain (secure)
        let userIdSaved = KeychainManager.shared.save(key: userIdKey, value: userId)
        let emailSaved = KeychainManager.shared.save(key: emailKey, value: email)
        
        // Save login state to UserDefaults
        UserDefaults.standard.set(true, forKey: isLoggedInKey)
        UserDefaults.standard.synchronize()
        
        // Set Core Data current user
        CoreDataManager.shared.setCurrentUser(userId: userId)
        
        if userIdSaved && emailSaved {
            print("Session created successfully")
        } else {
            print("Warning: Session creation incomplete")
        }
    }
    
    // MARK: - Restore Session (Auto-Login)
    func restoreSession() -> Bool {
        guard isLoggedIn, let userId = currentUserId else {
            return false
        }
        
        // Set Core Data current user
        CoreDataManager.shared.setCurrentUser(userId: userId)
        print("Session restored for user: \(userId)")
        return true
    }
    
    // MARK: - Logout
    func logout() {
        // Clear Keychain
        KeychainManager.shared.delete(key: userIdKey)
        KeychainManager.shared.delete(key: emailKey)
        
        // Clear UserDefaults
        UserDefaults.standard.set(false, forKey: isLoggedInKey)
        UserDefaults.standard.synchronize()
        
        // Clear Core Data current user
        CoreDataManager.shared.clearCurrentUser()
        
        print("Session cleared")
    }
    
    // MARK: - Delete Account (Full Cleanup)
    func deleteAccount() {
        logout()
        KeychainManager.shared.deleteAll()
    }
}
