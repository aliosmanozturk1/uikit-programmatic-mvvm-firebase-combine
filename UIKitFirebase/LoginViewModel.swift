//
//  LoginViewModel.swift
//  UIKitFirebase
//
//  Created by Ali Osman Öztürk on 21.10.2025.
//

import Foundation
import UIKit
import FirebaseAuth

// MARK: - Delegate Protocol
protocol LoginViewModelDelegate: AnyObject {
    func loginViewModel(_ viewModel: LoginViewModel, didLoginSuccessfully user: User)
    func loginViewModel(_ viewModel: LoginViewModel, didFailWithError error: String)
    func loginViewModel(_ viewModel: LoginViewModel, didChangeLoadingState isLoading: Bool)
}

class LoginViewModel {
    
    // MARK: - Properties
    private let authService: AuthServiceProtocol
    weak var delegate: LoginViewModelDelegate?
    
    // MARK: - Initialization
    init(authService: AuthServiceProtocol = AuthService.shared) {
        self.authService = authService
    }
    
    // MARK: - Email Login
    func loginWithEmail(email: String?, password: String?) {
        // Validate input
        guard let email = email, !email.isEmpty,
              let password = password, !password.isEmpty else {
            delegate?.loginViewModel(self, didFailWithError: "Please enter email and password")
            return
        }
        
        guard isValidEmail(email) else {
            delegate?.loginViewModel(self, didFailWithError: "Please enter a valid email address")
            return
        }
        
        delegate?.loginViewModel(self, didChangeLoadingState: true)
        
        Task {
            do {
                let user = try await authService.signInWithEmail(email, password: password)
                await MainActor.run {
                    delegate?.loginViewModel(self, didChangeLoadingState: false)
                    delegate?.loginViewModel(self, didLoginSuccessfully: user)
                }
            } catch {
                await MainActor.run {
                    delegate?.loginViewModel(self, didChangeLoadingState: false)
                    delegate?.loginViewModel(self, didFailWithError: error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Google Sign In
    func loginWithGoogle(presenting viewController: UIViewController) {
        delegate?.loginViewModel(self, didChangeLoadingState: true)
        
        Task {
            do {
                let user = try await authService.signInWithGoogle(presenting: viewController)
                await MainActor.run {
                    delegate?.loginViewModel(self, didChangeLoadingState: false)
                    delegate?.loginViewModel(self, didLoginSuccessfully: user)
                }
            } catch {
                await MainActor.run {
                    delegate?.loginViewModel(self, didChangeLoadingState: false)
                    delegate?.loginViewModel(self, didFailWithError: error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Validation
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    // MARK: - Check Current User
    func checkCurrentUser() -> User? {
        return authService.getCurrentUser()
    }
}
