//
//  PasswordValidator.swift
//  DayList
//

import Foundation

/// Password validator with strong security rules
struct PasswordValidator {
    
    /// Validates password and returns result with error message
    /// - Parameter password: The password string to validate
    /// - Returns: Tuple with validation status and error message
    static func validate(_ password: String) -> (isValid: Bool, errorMessage: String) {
        var missingRequirements: [String] = []
        
        // Rule 1: Minimum 8 characters
        if password.count < 8 {
            missingRequirements.append("At least 8 characters")
        }
        
        // Rule 2: At least one uppercase letter
        if !password.contains(where: { $0.isUppercase }) {
            missingRequirements.append("At least 1 uppercase letter (A-Z)")
        }
        
        // Rule 3: At least one lowercase letter
        if !password.contains(where: { $0.isLowercase }) {
            missingRequirements.append("At least 1 lowercase letter (a-z)")
        }
        
        // Rule 4: At least one number
        if !password.contains(where: { $0.isNumber }) {
            missingRequirements.append("At least 1 number (0-9)")
        }
        
        // Rule 5: At least one special character
        let specialCharacters = CharacterSet(charactersIn: "!@#$%^&*()_+-=[]{}|;':\"\\,.<>?/~`")
        if password.rangeOfCharacter(from: specialCharacters) == nil {
            missingRequirements.append("At least 1 special character (!@#$%^&*...)")
        }
        
        // If validation fails, create error message
        if !missingRequirements.isEmpty {
            let errorMessage = """
            Password must contain:
            • \(missingRequirements.joined(separator: "\n• "))
            """
            return (false, errorMessage)
        }
        
        // Password is valid
        return (true, "")
    }
    
    /// Quick check - returns true if password is valid
    /// - Parameter password: Password to check
    /// - Returns: True if valid, false otherwise
    static func isValid(_ password: String) -> Bool {
        let result = validate(password)
        return result.isValid
    }
}
