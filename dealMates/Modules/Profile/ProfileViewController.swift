//
//  ProfileViewController.swift
//  dealMates
//
//  Created by Stanislav on 13.05.2023.
//

import UIKit
import Combine

final class ProfileViewController: UIViewController {
    
    private var cancellables = Set<AnyCancellable>()
    
    private let headerView: DMHeaderView = {
        let view = DMHeaderView(title: AppText.profile())
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 80
        imageView.image = AppImage.profile_avatarPlaceholder()
        return imageView
    }()
    
    private let imageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.layer.cornerRadius = 80
        view.layer.borderWidth = 2
        view.layer.borderColor = AppColor.black()?.cgColor
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .handoSoft(size: 24, weight: .bold)
        label.textAlignment = .center
        label.textColor = AppColor.black()
        return label
    }()
    
    private let rateLabel: UILabel = {
        let label = UILabel()
        label.font = .handoSoft(size: 16, weight: .bold)
        label.textColor = AppColor.any_132_134_137()
        label.textAlignment = .center
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .handoSoft(size: 16, weight: .bold)
        label.textAlignment = .center
        label.textColor = AppColor.black()
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = .handoSoft(size: 14, weight: .regular)
        label.textAlignment = .center
        label.textColor = AppColor.any_132_134_137()
        return label
    }()
    
    private let approveImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(AppColor.black(), for: .normal)
        button.setTitle(AppText.editProfile(), for: .normal)
        button.titleLabel?.font = .handoSoft(size: 16, weight: .bold)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didPressEdit), for: .touchUpInside)
        return button
    }()
    
    private let buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    private lazy var proposalsButton = makeButton(title: "Your proposals")
    private lazy var requestsButton = makeButton(title: "Your requests")
    private lazy var becomeExecutorButton: DMButton = {
        let button = DMButton()
        button.setTitle("Become Executor", for: .normal)
        button.variant = .filled
        button.setTitleColor(AppColor.white(), for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()
    
    private lazy var signOutButton: DMButton = {
        let button = DMButton()
        button.setTitle("Sign Out", for: .normal)
        button.variant = .sketched(color: AppColor.red())
        button.setTitleColor(AppColor.red(), for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()
    
    
    private let viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.title = viewModel.title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupSubscription()
        view.backgroundColor = AppColor.white()
        viewModel.getUserInfo()
        editButton.addShadowForSquareView(opacity: 0.35, width: 5, height: 5)
        proposalsButton.isHidden = !viewModel.isExecutor
        becomeExecutorButton.isHidden = viewModel.isExecutor
        proposalsButton.addTarget(self, action: #selector(didPressProposals), for: .touchUpInside)
        requestsButton.addTarget(self, action: #selector(didPressRequests), for: .touchUpInside)
        becomeExecutorButton.addTarget(self, action: #selector(didPressBecomeExecutor), for: .touchUpInside)
        signOutButton.addTarget(self, action: #selector(didPressSignOut), for: .touchUpInside)
    }
}

// MARK: - Setup Methods
private extension ProfileViewController {
    func setupLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.add(views: [headerView, imageContainerView, nameLabel, typeLabel, locationLabel, rateLabel, approveImageView, editButton, buttonsStack], constraints: [
            headerView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60),
            
            imageContainerView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            imageContainerView.heightAnchor.constraint(equalToConstant: 160),
            imageContainerView.widthAnchor.constraint(equalTo: imageContainerView.heightAnchor),
            imageContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            locationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 15),
            locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            rateLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 15),
            rateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            rateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            typeLabel.topAnchor.constraint(equalTo: rateLabel.bottomAnchor, constant: 15),
            typeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            typeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            approveImageView.heightAnchor.constraint(equalToConstant: 20),
            approveImageView.widthAnchor.constraint(equalToConstant: 20),
            approveImageView.leadingAnchor.constraint(equalTo: rateLabel.trailingAnchor, constant: 10),
            approveImageView.centerYAnchor.constraint(equalTo: rateLabel.centerYAnchor),
            
            editButton.heightAnchor.constraint(equalToConstant: 30),
            editButton.widthAnchor.constraint(equalToConstant: 130),
            editButton.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 20),
            editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsStack.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 50)
        ])
        
        imageContainerView.add(view: profileImageView, constraints: [
            profileImageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor),
            profileImageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor),
            profileImageView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor)
        ])
        
        buttonsStack.addArrangedSubviews(proposalsButton, requestsButton, becomeExecutorButton, signOutButton)
        
        NSLayoutConstraint.activate([
            proposalsButton.heightAnchor.constraint(equalToConstant: 40),
            requestsButton.heightAnchor.constraint(equalToConstant: 40),
            becomeExecutorButton.heightAnchor.constraint(equalToConstant: 40),
            signOutButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    private func makeButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.backgroundColor = AppColor.white()
        button.setTitleColor(AppColor.black(), for: .normal)
        button.layer.cornerRadius = 12
        button.layer.borderColor = AppColor.black()?.cgColor
        button.layer.borderWidth = 2
        return button
    }
    
    func setupSubscription() {
        viewModel.$status.sink { [weak self] status in
            guard let self else { return }
            DispatchQueue.main.async {
                switch status {
                case .empty, .idle, .loading:
                    break
                    
                case .error(let message):
                    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                    alert.addAction(.init(title: "OK", style: .default))
                    self.present(alert, animated: true)
                    
                case .loaded:
                    let name = "\(self.viewModel.profileModel?.firstName ?? "") \(self.viewModel.profileModel?.lastName ?? "")"
                    self.nameLabel.text = name
                    self.rateLabel.text = AppText.rate("4.9")
                    self.locationLabel.text = self.viewModel.profileModel?.location
                    self.typeLabel.text = self.viewModel.profileModel?.hasExecutorProfile == true ? "Executor" : "User"
                }
            }
        }.store(in: &cancellables)
    }
}

// MARK: - Selectors
@objc private extension ProfileViewController {
    func didPressProposals() {
        
    }
    
    func didPressRequests() {
        
    }
    
    func didPressBecomeExecutor() {
        viewModel.becomeExecutor()
    }
    
    func didPressEdit() {
        viewModel.editProfile()
    }
    
    func didPressSignOut() {
        viewModel.didBecomeExecutor()
    }
}
