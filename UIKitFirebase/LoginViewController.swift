//
//  LoginViewController.swift
//  UIKitFirebase
//
//  Created by Ali Osman Öztürk on 21.10.2025.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    private let loginView = LoginView()
    private let viewModel = LoginViewModel()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.delegate = self
        viewModel.delegate = self
        
        // Check if user is already logged in
        if let user = viewModel.checkCurrentUser() {
            navigateToHome(user: user)
        }
    }
    
    // MARK: - Helper Methods
    private func navigateToHome(user: User) {
        print("User logged in: \(user.email ?? "No email")")
        print("User ID: \(user.uid)")
        print("Display Name: \(user.displayName ?? "No name")")
        // Navigate to home screen
        // let homeVC = HomeViewController()
        // navigationController?.setViewControllers([homeVC], animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - LoginViewDelegate
extension LoginViewController: LoginViewDelegate {
    func loginViewDidTapLogin(_ view: LoginView, email: String?, password: String?) {
        viewModel.loginWithEmail(email: email, password: password)
    }
    
    func loginViewDidTapForgotPassword(_ view: LoginView) {
        // Navigate to forgot password screen
        print("Forgot password tapped")
    }
    
    func loginViewDidTapGoogle(_ view: LoginView) {
        viewModel.loginWithGoogle(presenting: self)
    }
    
    func loginViewDidTapApple(_ view: LoginView) {
        // Apple sign in logic
        print("Apple sign in tapped")
    }
    
    func loginViewDidTapSignup(_ view: LoginView) {
        // Navigate to signup screen
        print("Signup tapped")
    }
}

// MARK: - LoginViewModelDelegate
extension LoginViewController: LoginViewModelDelegate {
    func loginViewModel(_ viewModel: LoginViewModel, didLoginSuccessfully user: User) {
        navigateToHome(user: user)
    }
    
    func loginViewModel(_ viewModel: LoginViewModel, didFailWithError error: String) {
        showAlert(message: error)
    }
    
    func loginViewModel(_ viewModel: LoginViewModel, didChangeLoadingState isLoading: Bool) {
        loginView.setLoading(isLoading)
    }
}

@available(iOS 17.0, *)
#Preview {
    LoginViewController()
}
