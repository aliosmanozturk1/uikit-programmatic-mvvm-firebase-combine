//
//  LoginViewController.swift
//  UIKitFirebase
//
//  Created by Ali Osman Öztürk on 21.10.2025.
//

import UIKit
import FirebaseAuth
import AuthenticationServices

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    private let loginView = LoginView()
    private let viewModel = LoginViewModel()
    
    private var currentNonce: String?
    
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
        let alert = UIAlertController(
            title: NSLocalizedString("alert.errorTitle", comment: "Generic error alert title"),
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: NSLocalizedString("alert.ok", comment: "Alert confirm action"), style: .default))
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
            let nonce = AppleSignInHelper.randomNonceString()
            currentNonce = nonce
            
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            request.nonce = AppleSignInHelper.sha256(nonce)
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
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

extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            showAlert(message: NSLocalizedString("appleSignIn.error.noCredential", comment: "Apple ID credential failure message"))
            return
        }
        
        guard let nonce = currentNonce else {
            showAlert(message: NSLocalizedString("appleSignIn.error.invalidState", comment: "Apple sign-in invalid nonce state message"))
            return
        }
        
        guard let appleIDToken = appleIDCredential.identityToken else {
            showAlert(message: NSLocalizedString("appleSignIn.error.noIdentityToken", comment: "Apple sign-in identity token missing message"))
            return
        }
        
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            showAlert(message: NSLocalizedString("appleSignIn.error.serialization", comment: "Apple sign-in token serialization failure message"))
            return
        }
        
        viewModel.loginWithApple(idToken: idTokenString, nonce: nonce, fullName: appleIDCredential.fullName)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let message = String(
            format: NSLocalizedString("appleSignIn.error.generic", comment: "Generic Apple sign-in error message"),
            error.localizedDescription
        )
        showAlert(message: message)
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

@available(iOS 17.0, *)
#Preview {
    LoginViewController()
}
