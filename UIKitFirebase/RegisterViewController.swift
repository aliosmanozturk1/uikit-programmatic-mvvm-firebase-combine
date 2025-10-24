//
//  RegisterViewController.swift
//  UIKitFirebase
//
//  Created by Ali Osman Öztürk on 24.10.2025.
//

import UIKit
import FirebaseAuth
import AuthenticationServices
import SafariServices

class RegisterViewController: UIViewController {
    
    // MARK: - Properties
    private let registerView = RegisterView()
    private let viewModel = RegisterViewModel()
    
    private let termsURL = URL(string: "https://example.com/terms")
    private let privacyURL = URL(string: "https://example.com/privacy")
    
    // MARK: - Lifecycle
    override func loadView() {
        view = registerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerView.delegate = self
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Helpers
    private func navigateToHome(user: User) {
        print("User registered: \(user.email ?? "No email")")
        print("User ID: \(user.uid)")
        print("Display Name: \(user.displayName ?? "No name")")
        // Navigate to home screen
        // let homeVC = HomeViewController()
        // navigationController?.setViewControllers([homeVC], animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: NSLocalizedString("alert.errorTitle", comment: "Generic error alert title"),
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: NSLocalizedString("alert.ok", comment: "Alert confirm action"), style: .default))
        present(alert, animated: true)
    }
    
    private func openLegalURL(_ url: URL?) {
        guard let url = url else { return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}

// MARK: - RegisterViewDelegate
extension RegisterViewController: RegisterViewDelegate {
    func registerViewDidTapSignup(_ view: RegisterView, email: String?, password: String?, confirmPassword: String?) {
        viewModel.signupWithEmail(email: email, password: password, confirmPassword: confirmPassword)
    }
    
    func registerViewDidTapLogin(_ view: RegisterView) {
        navigationController?.popViewController(animated: true)
    }
    
    func registerViewDidTapTerms(_ view: RegisterView) {
        openLegalURL(termsURL)
    }
    
    func registerViewDidTapPrivacy(_ view: RegisterView) {
        openLegalURL(privacyURL)
    }
}

// MARK: - RegisterViewModelDelegate
extension RegisterViewController: RegisterViewModelDelegate {
    func registerViewModel(_ viewModel: RegisterViewModel, didRegisterSuccessfully user: User) {
        navigateToHome(user: user)
    }
    
    func registerViewModel(_ viewModel: RegisterViewModel, didFailWithError error: String) {
        showAlert(message: error)
    }
    
    func registerViewModel(_ viewModel: RegisterViewModel, didChangeLoadingState isLoading: Bool) {
        registerView.setLoading(isLoading)
    }
}


@available(iOS 17.0, *)
#Preview {
    RegisterViewController()
}
