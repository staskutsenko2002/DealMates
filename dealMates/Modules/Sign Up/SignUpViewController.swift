//
//  SignUpViewController.swift
//  dealMates
//
//  Created by Stanislav on 13.05.2023.
//

import UIKit
import Combine

enum AlertType {
    case error(String)
    case success(String)
    
    var title: String {
        switch self {
        case .error: return "Oops..."
        case .success: return "Success"
        }
    }
}

final class SignUpViewController: UIViewController {
    
    private var isContinued = false
    private var cancellables = Set<AnyCancellable>()
    
    private let viewModel: SignUpViewModel
    
    private lazy var firstLeadingConstraint = firstStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
    private lazy var firstTrailingConstraint = firstStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
    private lazy var secondLeadingConstraint = secondStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30 + view.frame.width)
    private lazy var secondTrailingConstraint = secondStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30 + view.frame.width)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = AppText.signUp()
        label.font = .handoSoft(size: 45, weight: .bold)
        return label
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(AppImage.arrowLeft(), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(didPressBack), for: .touchUpInside)
        return button
    }()
    
    private lazy var continueButton: DMButton = {
        let button = DMButton()
        button.variant = .filled
        button.setTitle(AppText.continue(), for: .normal)
        button.addTarget(self, action: #selector(didPressContinue), for: .touchUpInside)
        return button
    }()
    
    private lazy var signUpButton: DMButton = {
        let button = DMButton()
        button.variant = .filled
        button.setTitle(AppText.signUp(), for: .normal)
        button.addTarget(self, action: #selector(didPressSignUp), for: .touchUpInside)
        return button
    }()
    
    private let firstNameField = UIComponentsFactory.makeDMTextField(placeholder: AppText.firstName())
    private let lastNameField = UIComponentsFactory.makeDMTextField(placeholder: AppText.lastName())
    private let phoneField = UIComponentsFactory.makeDMTextField(placeholder: AppText.phone())
    private let birthdayField = UIComponentsFactory.makeDMTextField(placeholder: AppText.birthday())
    private let emailField = UIComponentsFactory.makeDMTextField(placeholder: AppText.email())
    private let passwordField = UIComponentsFactory.makeDMTextField(placeholder: AppText.password())
    private let repeatPasswordField = UIComponentsFactory.makeDMTextField(placeholder: AppText.repeatPassword())
    
    private lazy var fields = [firstNameField, lastNameField, phoneField, birthdayField, emailField, passwordField, repeatPasswordField]
    
    private let firstStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 15
        return stackView
    }()
    
    private let secondStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 15
        return stackView
    }()
    
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupTextField()
        view.backgroundColor = AppColor.white()
        bind()
    }
}

// MARK: - Setup functions
private extension SignUpViewController {
    func bind() {
        viewModel.onBack.sink { [weak self] _ in
            self?.dismiss(animated: true)
        }.store(in: &cancellables)
        
        viewModel.onSignUp.sink { [weak self] _ in
            self?.showAlert(type: .success("Account created!"), completion: { [weak self] in
                self?.dismiss(animated: true)
            })
        }.store(in: &cancellables)
        
        viewModel.onError.sink { [weak self] description in
            self?.showAlert(type: .error(description))
        }.store(in: &cancellables)
    }
    
    func setupTextField() {
        firstNameField.addValidationRule(.mandatory())
        lastNameField.addValidationRule(.mandatory())
        passwordField.addValidationRule(.mandatory())
        repeatPasswordField.addValidationRule(.mandatory())
        emailField.addValidationRule(.email)
        passwordField.textField.addTarget(self, action: #selector(passwordFieldDidChange), for: .editingChanged)
    }
    
    func setupLayout() {
        [titleLabel, backButton, firstStack, secondStack].forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subview)
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            backButton.heightAnchor.constraint(equalToConstant: 25),
            backButton.widthAnchor.constraint(equalToConstant: 25),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            backButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 50),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            firstStack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 80),
            firstLeadingConstraint,
            firstTrailingConstraint
        ])
        
        setupFirstStack()
        setupSecondStack()
    }
    
    func setupFirstStack() {
        [firstNameField, lastNameField, phoneField, birthdayField].forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            firstStack.addArrangedSubview(subview)
        }
        
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.heightAnchor.constraint(equalToConstant: 42).isActive = true
        firstStack.addArrangedSubview(continueButton, withSpacing: 35)
    }
    
    func setupSecondStack() {
        NSLayoutConstraint.activate([
            secondStack.topAnchor.constraint(equalTo: firstStack.topAnchor),
            secondLeadingConstraint,
            secondTrailingConstraint
        ])
        
        [emailField, passwordField, repeatPasswordField].forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            secondStack.addArrangedSubview(subview)
        }
        
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.heightAnchor.constraint(equalToConstant: 42).isActive = true
        secondStack.addArrangedSubview(signUpButton, withSpacing: 35)
    }
    
    func updateAnimatingConstraints(isActive: Bool) {
        firstLeadingConstraint.isActive = isActive
        firstTrailingConstraint.isActive = isActive
        secondLeadingConstraint.isActive = isActive
        secondTrailingConstraint.isActive = isActive
    }
    
    func showAlert(type: AlertType, completion: CommonAction? = nil) {
        
        var alert: UIAlertController
        
        switch type {
        case .error(let string):
            alert = .init(title: type.title, message: string, preferredStyle: .alert)
        case .success(let string):
            alert = .init(title: type.title, message: string, preferredStyle: .alert)
        }
        
        alert.addAction(.init(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true)
    }
}

// MARK: - Selector
@objc
private extension SignUpViewController {
    func didPressSignUp() {
        guard fields.allSatisfy({ $0.isValid }) else { return }
        
        viewModel.signUp(firstName: firstNameField.input, lastName: lastNameField.input, phone: nil, birthday: nil, email: emailField.input, password: passwordField.input)
    }
    
    func didPressBack() {
        if isContinued {
            isContinued = false
            updateAnimatingConstraints(isActive: false)
            firstLeadingConstraint = firstStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
            firstTrailingConstraint = firstStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            secondLeadingConstraint = secondStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20 + view.frame.width)
            secondTrailingConstraint = secondStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20 + view.frame.width)
            updateAnimatingConstraints(isActive: true)
            
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        } else {
            dismiss(animated: true)
        }
    }
    
    func didPressContinue() {
        isContinued = true
        updateAnimatingConstraints(isActive: false)
        firstLeadingConstraint = firstStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20 - view.frame.width)
        firstTrailingConstraint = firstStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20 - view.frame.width)
        secondLeadingConstraint = secondStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        secondTrailingConstraint = secondStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        updateAnimatingConstraints(isActive: true)
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func passwordFieldDidChange() {
        repeatPasswordField.resetValidationRules(updatingErrorMessageVisibility: false)
        guard !passwordField.input.isEmpty else { return }
        repeatPasswordField.addValidationRule(.equal(passwordField.input))
    }
}
