//
//  CreateViewController.swift
//  dealMates
//
//  Created by Stanislav on 13.05.2023.
//

import UIKit
import Combine

final class CreateViewController: UIViewController {
    
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var headerView: DMHeaderView = {
        let item = DMHeaderView.HeaderItem(image: AppImage.arrowLeft(), action: { [weak self] in
            guard let self else { return }
            self.navigationController?.popViewController(animated: true)
        })
        
        let view = DMHeaderView(title: AppText.create(), leftItem: viewModel.isBackHidden ? nil : item)
        return view
    }()
    
    private lazy var photoUploadView: DMPhotoUploadView = {
        let view = DMPhotoUploadView(buttonAction: { [weak self] in
            self?.viewModel.addImage()
        })
        return view
    }()
    
    private let titleField = UIComponentsFactory.makeDMTextField(placeholder: AppText.createTitlePlaceholder())
    private let categoryField = UIComponentsFactory.makeDMTextFieldWithPopUpPicker(placeholder: AppText.category(), items: [])

    private let descriptionField = UIComponentsFactory.makeDMTextView(placeholder: AppText.description())
    private let priceField = UIComponentsFactory.makeDMTextFieldWithNumericPad(placeholder: AppText.price())
    
    private lazy var createButton: DMButton = {
        let button = DMButton()
        button.variant = .filled
        button.setTitle(AppText.create(), for: .normal)
        button.addTarget(self, action: #selector(didPressCreate), for: .touchUpInside)
        return button
    }()
    
    private let loadingIndincator = UIActivityIndicatorView()
    
    // MARK: - Private properties
    private let viewModel: CreateViewModel
    
    // MARK: - Life cycle
    init(viewModel: CreateViewModel) {
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
        viewModel.getCategories()
        view.backgroundColor = AppColor.white()
    }
}

// MARK: - Setup Methods
private extension CreateViewController {
    func setupLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.add(views: [headerView, photoUploadView, titleField, categoryField, descriptionField, priceField, createButton], constraints: [
            headerView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60),
            
            photoUploadView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: Margins.xLarge),
            photoUploadView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Margins.large),
            photoUploadView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Margins.large),
            
            titleField.topAnchor.constraint(equalTo: photoUploadView.bottomAnchor, constant: Margins.xMedium),
            titleField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Margins.large),
            titleField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Margins.large),
            
            categoryField.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: Margins.xMedium),
            categoryField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Margins.large),
            categoryField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Margins.large),
            
            descriptionField.topAnchor.constraint(equalTo: categoryField.bottomAnchor, constant: Margins.medium),
            descriptionField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Margins.large),
            descriptionField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Margins.large),
            
            priceField.topAnchor.constraint(equalTo: descriptionField.bottomAnchor, constant: Margins.xMedium),
            priceField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Margins.large),
            priceField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Margins.large),
            
            createButton.topAnchor.constraint(equalTo: priceField.bottomAnchor, constant: Margins.xMedium),
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Margins.large),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Margins.large),
            createButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    func setupSubscription() {
        viewModel.$status.sink { [weak self] status in
            guard let self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                switch status {
                case .error(let message):
                    self.stopLoading()
                    let alert = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
                    let action = UIAlertAction(title: AppText.okay(), style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                    
                case .created:
                    let alert = UIAlertController(title: "Success!", message: "Creation went successful!", preferredStyle: .alert)
                    let action = UIAlertAction(title: AppText.okay(), style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                    
                    self.titleField.input = ""
                    self.priceField.input = ""
                    self.categoryField.input = ""
                    self.descriptionField.input = ""
                    self.stopLoading()
                    
                case .idle:
                    break
                case .loading:
                    self.startLoading()
                }
            }
        }.store(in: &cancellables)
        
        viewModel.onUpdateCategories.sink { [weak self] _ in
            guard let self else { return }
            self.categoryField.picker.items = [self.viewModel.categories.map({ $0.name })]
        }.store(in: &cancellables)
    }
    
    func startLoading() {
        view.add(view: loadingIndincator, constraints: [
            loadingIndincator.heightAnchor.constraint(equalToConstant: 60),
            loadingIndincator.widthAnchor.constraint(equalToConstant: 60),
            
            loadingIndincator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndincator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        loadingIndincator.startAnimating()
    }
    
    func stopLoading() {
        loadingIndincator.stopAnimating()
        loadingIndincator.removeFromSuperview()
    }
}

// MARK: - Selector
@objc private extension CreateViewController {
    func didPressCreate() {
        guard !titleField.input.isEmpty, !descriptionField.input.isEmpty, !categoryField.input.isEmpty,
              !priceField.input.isEmpty else {
            let alert = UIAlertController(title: "Oops!", message: "Some fields are empty!", preferredStyle: .alert)
            let action = UIAlertAction(title: AppText.okay(), style: .default)
            alert.addAction(action)
            present(alert, animated: true)
            return
        }
        
        viewModel.create(title: titleField.input, desc: descriptionField.input, category: categoryField.input, price: priceField.input)
    }
}
