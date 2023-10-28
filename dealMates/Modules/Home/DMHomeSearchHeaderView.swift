//
//  DMHomeSearchHeaderView.swift
//  dealMates
//
//  Created by Stanislav on 08.10.2023.
//

import UIKit

final class DMHomeSearchHeaderView: UIView {
    // MARK: - Properties
    var input: Input? {
        didSet {
            update()
        }
    }
    
    var isSearching: Bool = false {
        didSet {
            updateSearchingState()
        }
    }
    
    // MARK: - UI
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = AppColor.black()
        title.font = .handoSoft(size: 25, weight: .bold)
        return title
    }()
    
    private lazy var searchView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.layer.cornerRadius = 8
        view.backgroundColor = AppColor.superLightGray()
        return view
    }()
    
    private lazy var searchField: UITextField = {
        let view = UITextField()
        view.placeholder = "I'm looking for..."
        view.tintColor = AppColor.lightGray()
        view.delegate = self
        view.returnKeyType = .search
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didPressCloseSelector), for: .touchUpInside)
        button.setImage(AppImage.cross(), for: .normal)
        return button
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didPressSearchSelector), for: .touchUpInside)
        button.setImage(AppImage.search(), for: .normal)
        return button
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods
private extension DMHomeSearchHeaderView {
    func setupUI() {
        add(views: [searchView, titleLabel, searchButton], constraints: [
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            searchView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            searchView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            searchView.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchView.heightAnchor.constraint(equalToConstant: 36),
            
            searchButton.heightAnchor.constraint(equalToConstant: 22),
            searchButton.widthAnchor.constraint(equalTo: searchButton.heightAnchor),
            searchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            searchButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        searchView.add(views: [searchField, closeButton], constraints: [
            searchField.leadingAnchor.constraint(equalTo: searchView.leadingAnchor, constant: 10),
            searchField.topAnchor.constraint(equalTo: searchView.topAnchor),
            searchField.bottomAnchor.constraint(equalTo: searchView.bottomAnchor),
            searchField.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -10),
            
            closeButton.trailingAnchor.constraint(equalTo: searchView.trailingAnchor, constant: -10),
            closeButton.centerYAnchor.constraint(equalTo: searchView.centerYAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: 18),
            closeButton.widthAnchor.constraint(equalTo: closeButton.heightAnchor)
        ])
    }
    
    func update() {
        titleLabel.text = input?.title
    }
    
    func updateSearchingState() {
        titleLabel.isHidden = isSearching
        searchView.isHidden = !isSearching
        searchButton.isHidden = isSearching
    }
}

// MARK: - Selectors
@objc
private extension DMHomeSearchHeaderView {
    func didPressSearchSelector() {
        guard !isSearching else { return }
        isSearching = true
        searchField.becomeFirstResponder()
    }
    
    func didPressCloseSelector() {
        guard isSearching else { return }
        isSearching = false
        searchField.text = ""
        searchField.resignFirstResponder()
    }
}

// MARK: - UITextFieldDelegate
extension DMHomeSearchHeaderView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        input?.shouldReturnAction(textField.text ?? "")
        isSearching = false
        searchField.text = ""
        return textField.resignFirstResponder()
    }
}

// MARK: - Input
extension DMHomeSearchHeaderView {
    struct Input {
        let title: String
        let shouldReturnAction: StringCallback
    }
}
