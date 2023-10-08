//
//  DMSearchHeaderView.swift
//  dealMates
//
//  Created by Stanislav on 08.10.2023.
//

import UIKit

final class DMSearchHeaderView: UIView {
    // MARK: - Properties
    var input: Input? {
        didSet {
            configure()
        }
    }
    
    // MARK: - UI
    private let searchView: UISearchTextField = {
        let view = UISearchTextField()
        view.placeholder = "I'm looking for..."
        view.tintColor = AppColor.lightGray()
        view.backgroundColor = AppColor.superLightGray()
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didPressBackSelector), for: .touchUpInside)
        button.setImage(AppImage.arrowLeft(), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didPressFilterSelector), for: .touchUpInside)
        button.setImage(AppImage.filter(), for: .normal)
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
private extension DMSearchHeaderView {
    func setupUI() {
        add(views: [searchView, backButton, filterButton], constraints: [
            backButton.heightAnchor.constraint(equalToConstant: 22),
            backButton.widthAnchor.constraint(equalTo: backButton.heightAnchor),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            searchView.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 10),
            searchView.trailingAnchor.constraint(equalTo: filterButton.leadingAnchor, constant: -10),
            searchView.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchView.heightAnchor.constraint(equalToConstant: 36),
            
            filterButton.heightAnchor.constraint(equalToConstant: 22),
            filterButton.widthAnchor.constraint(equalTo: filterButton.heightAnchor),
            filterButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            filterButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configure() {
        guard let input else { return erase() }
        searchView.text = input.query
    }
    
    func erase() {
        searchView.text = ""
    }
}

// MARK: - Selectors
@objc
private extension DMSearchHeaderView {
    func didPressBackSelector() {
        input?.onBackAction()
    }
    
    func didPressFilterSelector() {
        input?.onFilterAction()
    }
}

// MARK: - Input
extension DMSearchHeaderView {
    struct Input {
        let query: String
        let onBackAction: VoidCallback
        let onFilterAction: VoidCallback
        let onSearchAction: StringCallback
    }
}
