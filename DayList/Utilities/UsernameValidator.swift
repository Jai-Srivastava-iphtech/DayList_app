//
//  UsernameValidator.swift
//  DayList
//

import Foundation

struct UsernameValidator {
    
    static func validate(_ username: String) -> (isValid: Bool, errorMessage: String) {
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedUsername.isEmpty {
            return (false, "Please enter a username")
        }
        
        if trimmedUsername.count < 3 {
            return (false, "Username must be at least 3 characters")
        }
        
        if trimmedUsername.count > 20 {
            return (false, "Username must be less than 20 characters")
        }
        
        let usernameRegex = "^[a-zA-Z0-9._]+$"
        let usernamePredicate = NSPredicate(format: "SELF MATCHES %@", usernameRegex)
        
        if !usernamePredicate.evaluate(with: trimmedUsername) {
            return (false, "Username can only contain letters, numbers, dots, and underscores")
        }
        
        if let firstChar = trimmedUsername.first, !firstChar.isLetter {
            return (false, "Username must start with a letter")
        }
        
        if trimmedUsername.contains("..") || trimmedUsername.contains("__") {
            return (false, "Username cannot have consecutive dots or underscores")
        }
        
        return (true, "")
    }
    
    static func isValid(_ username: String) -> Bool {
        let result = validate(username)
        return result.isValid
    }
}
