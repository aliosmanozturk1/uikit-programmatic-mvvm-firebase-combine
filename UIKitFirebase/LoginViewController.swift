//
//  LoginViewController.swift
//  UIKitFirebase
//
//  Created by Ali Osman Öztürk on 21.10.2025.
//

import GoogleSignIn
import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    private let loginView = LoginView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.delegate = self
    }
}

// MARK: - LoginViewDelegate
extension LoginViewController: LoginViewDelegate {
    func loginViewDidTapLogin(_ view: LoginView, email: String?, password: String?) {
        guard let email = email, let password = password else {
            showAlert(message: "Please enter email and password")
            return
        }
        
        // Firebase login logic burada
        print("Login with: \(email)")
    }
    
    func loginViewDidTapForgotPassword(_ view: LoginView) {
        // Forgot password flow
        print("Forgot password tapped")
    }
    
    func loginViewDidTapGoogle(_ view: LoginView) {
        // Google sign in logic
        print("Google sign in tapped")
    }
    
    func loginViewDidTapApple(_ view: LoginView) {
        // Apple sign in logic
        print("Apple sign in tapped")
    }
    
    func loginViewDidTapSignup(_ view: LoginView) {
        // Navigate to signup screen
        print("Signup tapped")
    }
    
    // MARK: - Helper
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

@available(iOS 17.0, *)
#Preview {
    LoginViewController()
}
