//
//  EditProfileViewController.swift
//  dealMates
//
//  Created by Stanislav on 16.06.2023.
//

import UIKit
import Combine

final class EditProfileViewController: UIViewController {
    
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var headerView: DMHeaderView = {
        let view = DMHeaderView(title: AppText.profile(), leftItem: .init(image: AppImage.arrowLeft(), action: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }))
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 60
        imageView.image = AppImage.profile_avatarPlaceholder()
        return imageView
    }()
    
    private lazy var updateButton: DMButton = {
        let button = DMButton()
        button.setTitle("Update Profile", for: .normal)
        button.variant = .filled
        button.setTitleColor(AppColor.white(), for: .normal)
        button.addTarget(self, action: #selector(didPressUpdate), for: .touchUpInside)
        button.layer.cornerRadius = 12
        return button
    }()
    
    private let firstNameField: DMTextField
    private let lastNameField: DMTextField
    private let locationField: DMTextField
    
    private let buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    private let viewModel: EditProfileViewModel
    
    init(viewModel: EditProfileViewModel) {
        self.viewModel = viewModel
        self.firstNameField = UIComponentsFactory.makeDMTextField(input: viewModel.profileModel.firstName, placeholder: "First name")
        self.lastNameField = UIComponentsFactory.makeDMTextField(input: viewModel.profileModel.lastName, placeholder: "Last name")
        self.locationField = UIComponentsFactory.makeDMTextField(input: viewModel.profileModel.location, placeholder: "Location")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupSubscription()
        view.backgroundColor = AppColor.white()
    }
}

// MARK: - Setup methods
private extension EditProfileViewController {
    func setupLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.add(views: [headerView, profileImageView, buttonsStack, updateButton], constraints: [
            headerView.heightAnchor.constraint(equalToConstant: 50),
            headerView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            profileImageView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 40),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 120),
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            
            buttonsStack.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 40),
            buttonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            buttonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            updateButton.topAnchor.constraint(equalTo: buttonsStack.bottomAnchor, constant: 30),
            updateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            updateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            updateButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        buttonsStack.addArrangedSubviews(firstNameField, lastNameField, locationField)
        
        NSLayoutConstraint.activate([
            firstNameField.heightAnchor.constraint(equalToConstant: 40),
            lastNameField.heightAnchor.constraint(equalToConstant: 40),
            locationField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setupSubscription() {
        viewModel.$status.sink { [weak self] status in
            guard let self else { return }
            DispatchQueue.main.async {
                switch status {
                case .empty, .idle:
                    break
                    
                case .loading:
                    break
                
                case .loaded:
                    let alert = UIAlertController(title: "Success!", message: "Profile updated!", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                        guard let self else { return }
                        self.viewModel.onModelUpdate.send(self.viewModel.profileModel)
                        self.navigationController?.popViewController(animated: true)
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true)
                    
                    
                case .error(message: let message):
                    let alert = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                }
            }
            
        }.store(in: &cancellables)
    }
}

// MARK: - Selectors
@objc private extension EditProfileViewController {
    func didPressUpdate() {
        guard !firstNameField.input.isEmpty, !lastNameField.input.isEmpty
        else {
            let alert = UIAlertController(title: "Oops!", message: "Some fields are empty!", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alert.addAction(action)
            present(alert, animated: true)
            return
        }
        
        viewModel.update(firstName: firstNameField.input, lastName: lastNameField.input, location: locationField.input.isEmpty ? nil : locationField.input)
    }
}
