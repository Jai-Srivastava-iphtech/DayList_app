//
//  SignInViewController.swift
//  DayList
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController, UITextFieldDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var eyeButton: UIButton!

    // MARK: - Properties
    private var isPasswordVisible = false

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        hideKeyboardWhenTappedAround()
    }

    private func setupUI() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        eyeButton.setImage(UIImage(named: "eye-slashed"), for: .normal)
        emailTextField.returnKeyType = .next
        passwordTextField.returnKeyType = .done
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
    }

    // MARK: - Eye Button
    @IBAction func eyeButtonTapped(_ sender: UIButton) {
        isPasswordVisible.toggle()
        passwordTextField.isSecureTextEntry = !isPasswordVisible
        let imageName = isPasswordVisible ? "eye-removebg-preview" : "eye-slashed"
        sender.setImage(UIImage(named: imageName), for: .normal)
        refreshTextField(passwordTextField)
    }

    private func refreshTextField(_ textField: UITextField) {
        let text = textField.text
        textField.text = nil
        textField.text = text
    }

    // MARK: - Sign In
    @IBAction func signInTapped(_ sender: UIButton) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
            showAlert("Please fill all fields")
            return
        }
        
        // Validate email using EmailValidator
        let emailValidation = EmailValidator.validate(email)
        if !emailValidation.isValid {
            showAlert(emailValidation.errorMessage)
            emailTextField.becomeFirstResponder()
            return
        }
        
        // Check if password is empty
        if password.isEmpty {
            showAlert("Please enter your password")
            passwordTextField.becomeFirstResponder()
            return
        }

        // Sign in with Firebase
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        signInWithFirebase(email: trimmedEmail, password: password)
    }
    
    private func signInWithFirebase(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            // Check for errors
            if let error = error {
                self.handleFirebaseError(error)
                return
            }
            
            // Check if user exists
            guard authResult?.user != nil else {
                self.showAlert("Sign in failed. Please try again.")
                return
            }
            
            // Success - go to home
            print("✅ Sign in successful!")
            self.goToHome()
        }
    }
    
    // MARK: - Firebase Error Handling (FINAL - Works for all cases)
    private func handleFirebaseError(_ error: Error) {
        let nsError = error as NSError
        let errorCode = nsError.code
        
        // Debug prints (you can remove these later)
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("Firebase Error Code: \(errorCode)")
        print("Error Description: \(error.localizedDescription)")
        print("Error Domain: \(nsError.domain)")
        
        // Print full error info for debugging
        if let userInfo = nsError.userInfo as? [String: Any] {
            print("UserInfo: \(userInfo)")
        }
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        
        // Handle specific error codes
        switch errorCode {
        case 17009: // ERROR_WRONG_PASSWORD
            showAlert("Incorrect password.\n\nPlease try again.")
            passwordTextField.text = ""
            passwordTextField.becomeFirstResponder()
            
        case 17011: // ERROR_USER_NOT_FOUND
            showAlert("No account found with this email.\n\nPlease sign up first.")
            emailTextField.becomeFirstResponder()
            
        case 17008: // ERROR_INVALID_EMAIL
            showAlert("Invalid email format.")
            emailTextField.becomeFirstResponder()
            
        case 17010: // ERROR_TOO_MANY_REQUESTS
            showAlert("Too many failed attempts.\n\nPlease try again later.")
            
        case 17020: // ERROR_NETWORK_ERROR
            showAlert("Network error.\n\nCheck your internet connection.")
            
        case 17999: // ERROR_INTERNAL (Generic error for invalid credentials)
            // For error 17999, we can't distinguish between wrong email and wrong password
            // So we show a generic message
            showAlert("Invalid email or password.\n\nPlease check your credentials.")
            emailTextField.becomeFirstResponder()
            
        case 17026: // ERROR_WEAK_PASSWORD
            showAlert("Password is too weak.\n\nUse at least 6 characters.")
            passwordTextField.becomeFirstResponder()
            
        case 17007: // ERROR_EMAIL_ALREADY_IN_USE
            showAlert("This email is already registered.\n\nPlease sign in instead.")
            
        case 17012: // ERROR_REQUIRES_RECENT_LOGIN
            showAlert("Session expired.\n\nPlease sign in again.")
            
        case 17014: // ERROR_USER_DISABLED
            showAlert("This account has been disabled.")
            
        default:
            // For unknown errors, show the actual error message
            showAlert("Sign in failed.\n\n\(error.localizedDescription)")
        }
    }

    private func goToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "TodayViewController") as UIViewController? else {
            showAlert("Navigation error. Please restart the app.")
            return
        }
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

    // MARK: - Helpers
    private func showAlert(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }

    private func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
