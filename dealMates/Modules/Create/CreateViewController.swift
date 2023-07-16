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
        let view = DMHeaderView(title: AppText.create(), leftItem: .init(image: AppImage.arrowLeft(), action: { [weak self] in
            guard let self else { return }
            self.navigationController?.popViewController(animated: true)
        }))
        return view
    }()
    
    private let loadingIndincator = UIActivityIndicatorView()
    
    private let titleField = UIComponentsFactory.makeDMTextField(placeholder: "Title")
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
    
    private let viewModel: CreateViewModel
    
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
        
        view.add(views: [headerView, titleField, categoryField, descriptionField, priceField, createButton], constraints: [
            headerView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60),
            
            titleField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 30),
            titleField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleField.heightAnchor.constraint(equalToConstant: 50),
            
            categoryField.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 30),
            categoryField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            categoryField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            categoryField.heightAnchor.constraint(equalToConstant: 50),
            
            descriptionField.topAnchor.constraint(equalTo: categoryField.bottomAnchor, constant: 30),
            descriptionField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionField.heightAnchor.constraint(equalToConstant: 150),
            
            priceField.topAnchor.constraint(equalTo: descriptionField.bottomAnchor, constant: 30),
            priceField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            priceField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            priceField.heightAnchor.constraint(equalToConstant: 50),
            
            createButton.topAnchor.constraint(equalTo: priceField.bottomAnchor, constant: 30),
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
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
                    stopLoading()
                    let alert = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default)
                    alert.addAction(action)
                    present(alert, animated: true)
                    
                case .created:
                    let alert = UIAlertController(title: "Success!", message: "Creation went successfully!", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default)
                    alert.addAction(action)
                    present(alert, animated: true)
                    
                    titleField.input = ""
                    priceField.input = ""
                    categoryField.input = ""
                    descriptionField.input = ""
                    stopLoading()
                    
                case .idle:
                    break
                case .loading:
                    startLoading()
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
            let action = UIAlertAction(title: "OK", style: .default)
            alert.addAction(action)
            present(alert, animated: true)
            return
        }
        
        viewModel.create(title: titleField.input, desc: descriptionField.input, category: categoryField.input, price: priceField.input)
    }
}
