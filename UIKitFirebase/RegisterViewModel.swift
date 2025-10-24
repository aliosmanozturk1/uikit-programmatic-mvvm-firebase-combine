//
//  RegisterViewModel.swift
//  UIKitFirebase
//
//  Created by Ali Osman Öztürk on 24.10.2025.
//

import Foundation
import UIKit
import FirebaseAuth

protocol RegisterViewModelDelegate: AnyObject {
    func registerViewModel(_ viewModel: RegisterViewModel, didRegisterSuccessfully user: User)
    func registerViewModel(_ viewModel: RegisterViewModel, didFailWithError error: String)
    func registerViewModel(_ viewModel: RegisterViewModel, didChangeLoadingState isLoading: Bool)
}

class RegisterViewModel {
    
    // MARK: - Properties
    private let authService: AuthServiceProtocol
    weak var delegate: RegisterViewModelDelegate?
    
    // MARK: - Initialization
    init(authService: AuthServiceProtocol = AuthService.shared) {
        self.authService = authService
    }
    
    // MARK: - Email Signup
    func signupWithEmail(email: String?, password: String?, confirmPassword: String?) {
        guard let email = email, !email.isEmpty,
              let password = password, !password.isEmpty,
              let confirmPassword = confirmPassword, !confirmPassword.isEmpty else {
            delegate?.registerViewModel(
                self,
                didFailWithError: NSLocalizedString("error.emailPasswordConfirmRequired", comment: "Missing sign up fields message")
            )
            return
        }
        
        guard isValidEmail(email) else {
            delegate?.registerViewModel(
                self,
                didFailWithError: NSLocalizedString("error.invalidEmail", comment: "Invalid email address message")
            )
            return
        }
        
        guard password.count >= 6 else {
            delegate?.registerViewModel(
                self,
                didFailWithError: NSLocalizedString("error.passwordTooShort", comment: "Password requirements not met message")
            )
            return
        }
        
        guard password == confirmPassword else {
            delegate?.registerViewModel(
                self,
                didFailWithError: NSLocalizedString("error.passwordMismatch", comment: "Passwords do not match message")
            )
            return
        }
        
        delegate?.registerViewModel(self, didChangeLoadingState: true)
        
        Task {
            do {
                let user = try await authService.signUpWithEmail(email, password: password)
                await MainActor.run {
                    delegate?.registerViewModel(self, didChangeLoadingState: false)
                    delegate?.registerViewModel(self, didRegisterSuccessfully: user)
                }
            } catch {
                await MainActor.run {
                    delegate?.registerViewModel(self, didChangeLoadingState: false)
                    delegate?.registerViewModel(self, didFailWithError: error.localizedDescription)
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
}
