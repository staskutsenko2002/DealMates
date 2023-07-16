//
//  SignInViewController.swift
//  dealMates
//
//  Created by Stanislav on 06.05.2023.
//

import UIKit
import Combine

final class SignInViewController: UIViewController {
    
    private let viewModel: SignInViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.text = AppText.projectName()
        label.font = .handoSoft(size: 45, weight: .bold)
        return label
    }()
    
    private let emailField = UIComponentsFactory.makeDMTextField(placeholder: AppText.email())
    
    private let passwordField = UIComponentsFactory.makeDMTextField(placeholder: AppText.password())
    
    private lazy var signInButton: DMButton = {
        let button = DMButton()
        button.variant = .filled
        button.setTitle(AppText.signIn(), for: .normal)
        button.addTarget(self, action: #selector(didPressSignIn), for: .touchUpInside)
        return button
    }()
    
    private let alternativeSignInLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .handoSoft(size: 14, weight: .bold)
        label.textAlignment = .center
        label.isHidden = true
        label.text = AppText.otherSignIn()
        return label
    }()
    
    private lazy var appleButton = makeSocialButton(type: .apple)
    
    private lazy var googleButton = makeSocialButton(type: .google)
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 30
        return stackView
    }()
    
    private let dontHaveAccountLabel: UILabel = {
        let label = UILabel()
        label.font = .handoSoft(size: 13, weight: .bold)
        label.textColor = AppColor.any_132_134_137()
        label.text = AppText.dontHaveAccount()
        return label
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle(AppText.signUp(), for: .normal)
        button.titleLabel?.font = .handoSoft(size: 13, weight: .bold)
        button.setTitleColor(AppColor.black(), for: .normal)
        button.addTarget(self, action: #selector(didPressSignUp), for: .touchUpInside)
        return button
    }()
    
    private let signUpStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        setupSubsription()
    }
}

// MARK: - Setup methods
private extension SignInViewController {
    func setupUI() {
        view.backgroundColor = AppColor.white()
    }
    
    func setupSubsription() {
        viewModel.onSignIn.sink { [weak self] _ in
            guard let self else { return }
            emailField.input = ""
            passwordField.input = ""
        }.store(in: &cancellables)
    }
    
    func setupLayout() {
        [logoLabel, emailField, passwordField, signInButton, alternativeSignInLabel, buttonStackView, signUpStackView].forEach { subView in
            subView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subView)
        }
        
        buttonStackView.addArrangedSubview(appleButton)
        buttonStackView.addArrangedSubview(googleButton)
        
        signUpStackView.addArrangedSubview(dontHaveAccountLabel)
        signUpStackView.addArrangedSubview(signUpButton)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            logoLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 80),
            logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            emailField.heightAnchor.constraint(equalToConstant: 55),

            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 30),
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            passwordField.heightAnchor.constraint(equalToConstant: 55),
            
            signInButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 30),
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            signInButton.heightAnchor.constraint(equalToConstant: 42),
            
            alternativeSignInLabel.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 15),
            alternativeSignInLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonStackView.topAnchor.constraint(equalTo: alternativeSignInLabel.bottomAnchor, constant: 20),
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            signUpStackView.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 15),
            signUpStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -50)
        ])
    }
    
    func makeSocialButton(type: SocialType) -> UIButton {
        let button = UIButton()
        button.backgroundColor = AppColor.black()
        button.layer.cornerRadius = 5
        button.setImage(type.image, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.isHidden = true
        
        switch type {
        case .apple:
            button.addTarget(self, action: #selector(didPressApple), for: .touchUpInside)
        case .google:
            button.addTarget(self, action: #selector(didPressGoogle), for: .touchUpInside)
        }
        
        return button
    }
}

// MARK: - Selectors
@objc
private extension SignInViewController {
    func didPressApple() {}
    
    func didPressGoogle() {}
    
    func didPressSignIn() {
        guard !emailField.input.isEmpty, !passwordField.input.isEmpty else { return }
        viewModel.signIn(email: emailField.input, password: passwordField.input)
    }
    
    func didPressSignUp() {
        viewModel.onSignUp.send()
    }
}

// MARK: - SocialType
fileprivate enum SocialType {
    case apple
    case google
    
    var image: UIImage? {
        switch self {
        case .apple: return AppImage.appleButton()
        case .google: return AppImage.googleButton()
        }
    }
}
