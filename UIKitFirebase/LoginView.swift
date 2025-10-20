//
//  LoginViewDelegate.swift
//  UIKitFirebase
//
//  Created by Ali Osman Öztürk on 21.10.2025.
//

import UIKit

protocol LoginViewDelegate: AnyObject {
    func loginViewDidTapLogin(_ view: LoginView, email: String?, password: String?)
    func loginViewDidTapForgotPassword(_ view: LoginView)
    func loginViewDidTapGoogle(_ view: LoginView)
    func loginViewDidTapApple(_ view: LoginView)
    func loginViewDidTapSignup(_ view: LoginView)
}

class LoginView: UIView {
    
    // MARK: - Properties
    weak var delegate: LoginViewDelegate?
    
    // MARK: - UI Elements
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "login-logo")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 48
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome Back!"
        label.font = UIFont(name: "SpaceGrotesk-Bold", size: 28)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Log in to try new looks."
        label.font = UIFont(name: "SpaceGrotesk-Regular", size: 16)
        label.textColor = UIColor(white: 0.7, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.font = UIFont(name: "SpaceGrotesk-Medium", size: 14)
        label.textColor = .white
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter your email"
        tf.textColor = .white
        tf.autocapitalizationType = .none
        tf.keyboardType = .emailAddress
        tf.setLeftPaddingPoints(16)
        tf.layer.cornerRadius = 20
        tf.backgroundColor = UIColor(red: 35/255, green: 36/255, blue: 54/255, alpha: 1)
        tf.attributedPlaceholder = NSAttributedString(
            string: "Enter your email",
            attributes: [.foregroundColor: UIColor(white: 0.6, alpha: 1)]
        )
        return tf
    }()
    
    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.font = UIFont(name: "SpaceGrotesk-Medium", size: 14)
        label.textColor = .white
        return label
    }()
    
    private lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter your password"
        tf.isSecureTextEntry = true
        tf.textColor = .white
        tf.setLeftPaddingPoints(16)
        tf.layer.cornerRadius = 20
        tf.backgroundColor = UIColor(red: 35/255, green: 36/255, blue: 54/255, alpha: 1)
        tf.attributedPlaceholder = NSAttributedString(
            string: "Enter your password",
            attributes: [.foregroundColor: UIColor(white: 0.6, alpha: 1)]
        )
        return tf
    }()
    
    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forgot Password?", for: .normal)
        button.setTitleColor(UIColor(red: 127/255, green: 19/255, blue: 236/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "SpaceGrotesk-Medium", size: 14)
        button.contentHorizontalAlignment = .right
        button.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 127/255, green: 19/255, blue: 236/255, alpha: 1)
        button.titleLabel?.font = UIFont(name: "SpaceGrotesk-Bold", size: 18)
        button.layer.cornerRadius = 28
        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var orLabel: UILabel = {
        let label = UILabel()
        label.text = "OR"
        label.textColor = UIColor(white: 0.6, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont(name: "SpaceGrotesk-Regular", size: 14)
        return label
    }()
    
    private lazy var googleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue with Google", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 35/255, green: 36/255, blue: 54/255, alpha: 1)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont(name: "SpaceGrotesk-Medium", size: 16)
        button.addTarget(self, action: #selector(googleTapped), for: .touchUpInside)
        
        let googleIcon = UIImageView(image: UIImage(named: "google"))
        googleIcon.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(googleIcon)
        NSLayoutConstraint.activate([
            googleIcon.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 20),
            googleIcon.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            googleIcon.widthAnchor.constraint(equalToConstant: 20),
            googleIcon.heightAnchor.constraint(equalToConstant: 20)
        ])
        return button
    }()
    
    private lazy var appleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue with Apple", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont(name: "SpaceGrotesk-Medium", size: 16)
        button.addTarget(self, action: #selector(appleTapped), for: .touchUpInside)
        
        let appleIcon = UIImageView(image: UIImage(systemName: "applelogo"))
        appleIcon.tintColor = .white
        appleIcon.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(appleIcon)
        NSLayoutConstraint.activate([
            appleIcon.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 20),
            appleIcon.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            appleIcon.widthAnchor.constraint(equalToConstant: 20),
            appleIcon.heightAnchor.constraint(equalToConstant: 20)
        ])
        return button
    }()
    
    private lazy var signupLabel: UILabel = {
        let label = UILabel()
        label.text = "Don't have an account?"
        label.font = UIFont(name: "SpaceGrotesk-Regular", size: 14)
        label.textColor = UIColor(white: 0.6, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign up", for: .normal)
        button.setTitleColor(UIColor(red: 127/255, green: 19/255, blue: 236/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "SpaceGrotesk-Regular", size: 14)
        button.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = UIColor(red: 20/255, green: 14/255, blue: 34/255, alpha: 1)
        
        // Signup stack
        let signupStack = UIStackView(arrangedSubviews: [signupLabel, signupButton])
        signupStack.axis = .horizontal
        signupStack.spacing = 4
        signupStack.alignment = .center
        signupStack.distribution = .fill
        signupStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Container view to center the signup stack
        let signupContainer = UIView()
        signupContainer.addSubview(signupStack)
        
        NSLayoutConstraint.activate([
            signupStack.centerXAnchor.constraint(equalTo: signupContainer.centerXAnchor),
            signupStack.centerYAnchor.constraint(equalTo: signupContainer.centerYAnchor),
            signupStack.topAnchor.constraint(equalTo: signupContainer.topAnchor),
            signupStack.bottomAnchor.constraint(equalTo: signupContainer.bottomAnchor)
        ])
        
        let stack = UIStackView(arrangedSubviews: [
            logoImageView,
            titleLabel,
            subtitleLabel,
            emailLabel,
            emailTextField,
            passwordLabel,
            passwordTextField,
            forgotPasswordButton,
            loginButton,
            orLabel,
            googleButton,
            appleButton,
            signupContainer
        ])
        
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            logoImageView.heightAnchor.constraint(equalToConstant: 96),
            logoImageView.widthAnchor.constraint(equalToConstant: 96),
            
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            emailTextField.heightAnchor.constraint(equalToConstant: 56),
            passwordTextField.heightAnchor.constraint(equalToConstant: 56),
            loginButton.heightAnchor.constraint(equalToConstant: 56),
            googleButton.heightAnchor.constraint(equalToConstant: 56),
            appleButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    // MARK: - Actions
    @objc private func loginTapped() {
        delegate?.loginViewDidTapLogin(self, email: emailTextField.text, password: passwordTextField.text)
    }
    
    @objc private func forgotPasswordTapped() {
        delegate?.loginViewDidTapForgotPassword(self)
    }
    
    @objc private func googleTapped() {
        delegate?.loginViewDidTapGoogle(self)
    }
    
    @objc private func appleTapped() {
        delegate?.loginViewDidTapApple(self)
    }
    
    @objc private func signupTapped() {
        delegate?.loginViewDidTapSignup(self)
    }
}

// MARK: - UITextField Padding Helper
extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
