//
//  AuthService.swift
//  UIKitFirebase
//
//  Created by Ali Osman Öztürk on 21.10.2025.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import CryptoKit
import AuthenticationServices

enum AuthError: LocalizedError {
    case noClientID
    case noUser
    case noIDToken
    case signInFailed(Error)
    case firebaseAuthFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .noClientID:
            return NSLocalizedString("auth.error.noClientID", comment: "Missing Firebase client ID error message")
        case .noUser:
            return NSLocalizedString("auth.error.noUser", comment: "Missing Google user data error message")
        case .noIDToken:
            return NSLocalizedString("auth.error.noIDToken", comment: "Missing Google ID token error message")
        case .signInFailed(let error):
            return String(
                format: NSLocalizedString("auth.error.signInFailed", comment: "Generic sign-in failed message"),
                error.localizedDescription
            )
        case .firebaseAuthFailed(let error):
            return String(
                format: NSLocalizedString("auth.error.firebaseAuthFailed", comment: "Firebase authentication failure message"),
                error.localizedDescription
            )
        }
    }
}

protocol AuthServiceProtocol {
    func signInWithGoogle(presenting viewController: UIViewController) async throws -> User
    func signInWithApple(idToken: String, nonce: String, fullName: PersonNameComponents?) async throws -> User
    func signInWithEmail(_ email: String, password: String) async throws -> User
    func signUpWithEmail(_ email: String, password: String) async throws -> User
    func signOut() throws
    func getCurrentUser() -> User?
}

class AuthService: AuthServiceProtocol {
    
    static let shared = AuthService()
    
    private init() {}
    
    // MARK: - Google Sign In
    func signInWithGoogle(presenting viewController: UIViewController) async throws -> User {
        // Get client ID
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw AuthError.noClientID
        }
        
        // Configure Google Sign In
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start sign in flow
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: viewController)
        
        guard let idToken = result.user.idToken?.tokenString else {
            throw AuthError.noIDToken
        }
        
        let accessToken = result.user.accessToken.tokenString
        
        // Create Firebase credential
        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: accessToken
        )
        
        // Sign in to Firebase
        do {
            let authResult = try await Auth.auth().signIn(with: credential)
            return authResult.user
        } catch {
            throw AuthError.firebaseAuthFailed(error)
        }
    }
    
    // MARK: - Apple Sign In
    func signInWithApple(idToken: String, nonce: String, fullName: PersonNameComponents?) async throws -> User {
        let credential = OAuthProvider.appleCredential(
            withIDToken: idToken,
            rawNonce: nonce,
            fullName: fullName
        )
        
        do {
            let authResult = try await Auth.auth().signIn(with: credential)
            return authResult.user
        } catch {
            throw AuthError.firebaseAuthFailed(error)
        }
    }
    
    // MARK: - Email Sign In
    func signInWithEmail(_ email: String, password: String) async throws -> User {
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            return authResult.user
        } catch {
            throw AuthError.firebaseAuthFailed(error)
        }
    }
    
    // MARK: - Email Sign Up
    func signUpWithEmail(_ email: String, password: String) async throws -> User {
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            return authResult.user
        } catch {
            throw AuthError.firebaseAuthFailed(error)
        }
    }
    
    // MARK: - Sign Out
    func signOut() throws {
        try Auth.auth().signOut()
        GIDSignIn.sharedInstance.signOut()
    }
    
    // MARK: - Get Current User
    func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }
}
