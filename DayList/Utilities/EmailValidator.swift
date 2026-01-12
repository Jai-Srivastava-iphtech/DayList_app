//
//  EmailValidator.swift
//  DayList
//

import Foundation

struct EmailValidator {
    
    static func validate(_ email: String) -> (isValid: Bool, errorMessage: String) {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedEmail.isEmpty {
            return (false, "Please enter your email address")
        }
        
        if trimmedEmail.count < 5 {
            return (false, "Email is too short")
        }
        
        if !trimmedEmail.contains("@") {
            return (false, "Email must contain @ symbol")
        }
        
        let parts = trimmedEmail.split(separator: "@")
        if parts.count != 2 || !String(parts[1]).contains(".") {
            return (false, "Please enter a valid email (e.g., user@example.com)")
        }
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        if !emailPredicate.evaluate(with: trimmedEmail) {
            return (false, "Please enter a valid email address")
        }
        
        return (true, "")
    }
    
    static func isValid(_ email: String) -> Bool {
        let result = validate(email)
        return result.isValid
    }
}
