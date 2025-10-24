//
//  RegisterView.swift
//  UIKitFirebase
//
//  Created by Ali Osman Öztürk on 24.10.2025.
//

import UIKit

protocol RegisterViewDelegate: AnyObject {
    func registerViewDidTapSignup(_ view: RegisterView, email: String?, password: String?, confirmPassword: String?)
    func registerViewDidTapLogin(_ view: RegisterView)
    func registerViewDidTapTerms(_ view: RegisterView)
    func registerViewDidTapPrivacy(_ view: RegisterView)
}

class RegisterView: UIView {
    
    // MARK: - Properties
    weak var delegate: RegisterViewDelegate?
    
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
        label.text = NSLocalizedString("register.title", comment: "Register screen title")
        label.font = UIFont(name: "SpaceGrotesk-Bold", size: 28)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("register.subtitle", comment: "Register screen subtitle")
        label.font = UIFont(name: "SpaceGrotesk-Regular", size: 16)
        label.textColor = UIColor(white: 0.7, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("register.emailLabel", comment: "Email field title")
        label.font = UIFont(name: "SpaceGrotesk-Medium", size: 14)
        label.textColor = .white
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let tf = UITextField()
        let placeholder = NSLocalizedString("register.emailPlaceholder", comment: "Email field placeholder")
        tf.placeholder = placeholder
        tf.textColor = .white
        tf.autocapitalizationType = .none
        tf.keyboardType = .emailAddress
        tf.setLeftPaddingPoints(16)
        tf.layer.cornerRadius = 20
        tf.backgroundColor = UIColor(red: 35/255, green: 36/255, blue: 54/255, alpha: 1)
        tf.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: UIColor(white: 0.6, alpha: 1)]
        )
        return tf
    }()
    
    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("register.passwordLabel", comment: "Password field title")
        label.font = UIFont(name: "SpaceGrotesk-Medium", size: 14)
        label.textColor = .white
        return label
    }()
    
    private lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        let placeholder = NSLocalizedString("register.passwordPlaceholder", comment: "Password field placeholder")
        tf.placeholder = placeholder
        tf.isSecureTextEntry = true
        tf.textColor = .white
        tf.setLeftPaddingPoints(16)
        tf.layer.cornerRadius = 20
        tf.backgroundColor = UIColor(red: 35/255, green: 36/255, blue: 54/255, alpha: 1)
        tf.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: UIColor(white: 0.6, alpha: 1)]
        )
        return tf
    }()
    
    private lazy var confirmPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("register.confirmPasswordLabel", comment: "Confirm password field title")
        label.font = UIFont(name: "SpaceGrotesk-Medium", size: 14)
        label.textColor = .white
        return label
    }()
    
    private lazy var confirmPasswordTextField: UITextField = {
        let tf = UITextField()
        let placeholder = NSLocalizedString("register.confirmPasswordPlaceholder", comment: "Confirm password field placeholder")
        tf.placeholder = placeholder
        tf.isSecureTextEntry = true
        tf.textColor = .white
        tf.setLeftPaddingPoints(16)
        tf.layer.cornerRadius = 20
        tf.backgroundColor = UIColor(red: 35/255, green: 36/255, blue: 54/255, alpha: 1)
        tf.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: UIColor(white: 0.6, alpha: 1)]
        )
        return tf
    }()
    
    private lazy var signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("register.button", comment: "Register action button title"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 127/255, green: 19/255, blue: 236/255, alpha: 1)
        button.titleLabel?.font = UIFont(name: "SpaceGrotesk-Bold", size: 18)
        button.layer.cornerRadius = 28
        button.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var orLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("login.or", comment: "Separator text")
        label.textColor = UIColor(white: 0.6, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont(name: "SpaceGrotesk-Regular", size: 14)
        return label
    }()
    
    
    private lazy var legalStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [termsButton, privacyButton])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .center
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var termsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("legal.terms", comment: "Terms of service action"), for: .normal)
        button.setTitleColor(UIColor(red: 127/255, green: 19/255, blue: 236/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "SpaceGrotesk-Medium", size: 14)
        button.addTarget(self, action: #selector(termsTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var privacyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("legal.privacy", comment: "Privacy policy action"), for: .normal)
        button.setTitleColor(UIColor(red: 127/255, green: 19/255, blue: 236/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "SpaceGrotesk-Medium", size: 14)
        button.addTarget(self, action: #selector(privacyTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("register.loginPrompt", comment: "Login prompt text")
        label.textColor = UIColor(white: 0.6, alpha: 1)
        label.font = UIFont(name: "SpaceGrotesk-Regular", size: 14)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("register.loginButton", comment: "Login action button title"), for: .normal)
        button.setTitleColor(UIColor(red: 127/255, green: 19/255, blue: 236/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "SpaceGrotesk-Regular", size: 14)
        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
        
        let loginStack = UIStackView(arrangedSubviews: [loginLabel, loginButton])
        loginStack.axis = .horizontal
        loginStack.spacing = 4
        loginStack.alignment = .center
        loginStack.distribution = .fill
        loginStack.translatesAutoresizingMaskIntoConstraints = false
        
        let loginContainer = UIView()
        loginContainer.addSubview(loginStack)
        
        NSLayoutConstraint.activate([
            loginStack.centerXAnchor.constraint(equalTo: loginContainer.centerXAnchor),
            loginStack.centerYAnchor.constraint(equalTo: loginContainer.centerYAnchor),
            loginStack.topAnchor.constraint(equalTo: loginContainer.topAnchor),
            loginStack.bottomAnchor.constraint(equalTo: loginContainer.bottomAnchor)
        ])
        
        contentStackView.addArrangedSubview(logoImageView)
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(subtitleLabel)
        contentStackView.addArrangedSubview(emailLabel)
        contentStackView.addArrangedSubview(emailTextField)
        contentStackView.addArrangedSubview(passwordLabel)
        contentStackView.addArrangedSubview(passwordTextField)
        contentStackView.addArrangedSubview(confirmPasswordLabel)
        contentStackView.addArrangedSubview(confirmPasswordTextField)
        contentStackView.addArrangedSubview(signupButton)
        contentStackView.addArrangedSubview(orLabel)
        contentStackView.addArrangedSubview(legalStackView)
        contentStackView.addArrangedSubview(loginContainer)
        
        addSubview(contentStackView)
        addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            logoImageView.heightAnchor.constraint(equalToConstant: 96),
            logoImageView.widthAnchor.constraint(equalToConstant: 96),
            
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            contentStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            emailTextField.heightAnchor.constraint(equalToConstant: 56),
            passwordTextField.heightAnchor.constraint(equalToConstant: 56),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 56),
            signupButton.heightAnchor.constraint(equalToConstant: 56),
    
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // MARK: - Public Methods
    func setLoading(_ isLoading: Bool) {
        contentStackView.isUserInteractionEnabled = !isLoading
        contentStackView.alpha = isLoading ? 0.5 : 1.0
        
        if isLoading {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }
    
    // MARK: - Actions
    @objc private func signupTapped() {
        delegate?.registerViewDidTapSignup(
            self,
            email: emailTextField.text,
            password: passwordTextField.text,
            confirmPassword: confirmPasswordTextField.text
        )
    }
    
    @objc private func loginTapped() {
        delegate?.registerViewDidTapLogin(self)
    }
    
    @objc private func termsTapped() {
        delegate?.registerViewDidTapTerms(self)
    }
    
    @objc private func privacyTapped() {
        delegate?.registerViewDidTapPrivacy(self)
    }

}
