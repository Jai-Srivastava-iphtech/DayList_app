//
//  SignUpViewController.swift
//  DayList
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController, UITextFieldDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var eyeButton1: UIButton!
    @IBOutlet weak var eyeButton2: UIButton!

    // MARK: - Properties
    private var isPasswordVisible = false

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        hideKeyboardWhenTappedAround()
    }

    private func setupUI() {
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        passwordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true
        
        eyeButton1.setImage(UIImage(named: "eye-slashed"), for: .normal)
        eyeButton2.setImage(UIImage(named: "eye-slashed"), for: .normal)
        
        usernameTextField.returnKeyType = .next
        emailTextField.returnKeyType = .next
        passwordTextField.returnKeyType = .next
        confirmPasswordTextField.returnKeyType = .done
        
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        
        usernameTextField.autocapitalizationType = .none
        usernameTextField.autocorrectionType = .no
        
        // Placeholders
        usernameTextField.placeholder = "Username"
        emailTextField.placeholder = "Email"
        passwordTextField.placeholder = "Password"
        confirmPasswordTextField.placeholder = "Confirm Password"
    }

    // MARK: - Eye Button
    @IBAction func eyeButtonTapped(_ sender: UIButton) {
        togglePasswordVisibility()
    }

    private func togglePasswordVisibility() {
        isPasswordVisible.toggle()
        passwordTextField.isSecureTextEntry = !isPasswordVisible
        confirmPasswordTextField.isSecureTextEntry = !isPasswordVisible
        let imageName = isPasswordVisible ? "eye-removebg-preview" : "eye-slashed"
        eyeButton1.setImage(UIImage(named: imageName), for: .normal)
        eyeButton2.setImage(UIImage(named: imageName), for: .normal)
        refreshTextField(passwordTextField)
        refreshTextField(confirmPasswordTextField)
    }

    private func refreshTextField(_ textField: UITextField) {
        let text = textField.text
        textField.text = nil
        textField.text = text
    }

    // MARK: - Sign Up
    @IBAction func signUpTapped(_ sender: UIButton) {
        guard let username = usernameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              let confirm = confirmPasswordTextField.text else {
            showAlert("Please fill all fields", isError: true)
            return
        }
        
        // Validate username
        let usernameValidation = UsernameValidator.validate(username)
        if !usernameValidation.isValid {
            showAlert(usernameValidation.errorMessage, isError: true)
            usernameTextField.becomeFirstResponder()
            return
        }
        
        // Validate email
        let emailValidation = EmailValidator.validate(email)
        if !emailValidation.isValid {
            showAlert(emailValidation.errorMessage, isError: true)
            emailTextField.becomeFirstResponder()
            return
        }
        
        // Check password
        if password.isEmpty {
            showAlert("Please enter a password", isError: true)
            passwordTextField.becomeFirstResponder()
            return
        }
        
        // Validate password strength
        let passwordValidation = PasswordValidator.validate(password)
        if !passwordValidation.isValid {
            showAlert(passwordValidation.errorMessage, isError: true)
            passwordTextField.becomeFirstResponder()
            return
        }
        
        // Check confirm password
        if confirm.isEmpty {
            showAlert("Please confirm your password", isError: true)
            confirmPasswordTextField.becomeFirstResponder()
            return
        }
        
        // Check if passwords match
        if password != confirm {
            showAlert("Passwords do not match", isError: true)
            confirmPasswordTextField.becomeFirstResponder()
            return
        }

        // Trim values
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Create account
        createAccount(username: trimmedUsername, email: trimmedEmail, password: password)
    }
    
    // MARK: - Create Account
    private func createAccount(username: String, email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                self.handleFirebaseError(error)
                return
            }
            
            guard let user = authResult?.user else {
                self.showAlert("Account creation failed.", isError: true)
                return
            }
            
            // Save username to Firebase Auth profile's displayName
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = username
            
            changeRequest.commitChanges { error in
                if let error = error {
                    print("⚠️ Error saving username: \(error.localizedDescription)")
                    // Account created but username save failed
                }
                
                print("✅ Account created! Username: \(username)")
                self.showSuccessAlert()
            }
        }
    }
    
    // MARK: - Firebase Error Handling
    private func handleFirebaseError(_ error: Error) {
        let nsError = error as NSError
        let errorCode = nsError.code
        
        switch errorCode {
        case 17007:
            showAlert("This email is already registered.\n\nPlease sign in instead.", isError: true)
            emailTextField.becomeFirstResponder()
            
        case 17008:
            showAlert("Invalid email format.", isError: true)
            emailTextField.becomeFirstResponder()
            
        case 17026:
            showAlert("Password is too weak.\n\nUse at least 6 characters.", isError: true)
            passwordTextField.becomeFirstResponder()
            
        case 17020:
            showAlert("Network error.\n\nCheck your internet connection.", isError: true)
            
        case 17010:
            showAlert("Too many requests.\n\nPlease try again later.", isError: true)
            
        default:
            showAlert("Sign up failed.\n\n\(error.localizedDescription)", isError: true)
        }
    }
    
    private func showSuccessAlert() {
        let alert = UIAlertController(
            title: "Success",
            message: "Account created successfully!\n\nYou can now sign in with your email.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.goToSignIn()
        })
        self.present(alert, animated: true)
    }

    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            confirmPasswordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

    private func goToSignIn() {
        // Try to pop if in navigation stack
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
            return
        }
        
        // Try to dismiss if presented modally
        if presentingViewController != nil {
            dismiss(animated: true, completion: nil)
            return
        }
        
        // Fallback: Navigate to sign in screen
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as? SignInViewController {
            signInVC.modalPresentationStyle = .fullScreen
            present(signInVC, animated: true, completion: nil)
        }
    }


    // MARK: - Helpers
    private func showAlert(_ message: String, isError: Bool) {
        DispatchQueue.main.async {
            let title = isError ? "Error" : "Success"
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
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
