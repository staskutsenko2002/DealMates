//
//  DMPhotoUploadView.swift
//  dealMates
//
//  Created by Stanislav on 28.10.2023.
//

import UIKit

final class DMPhotoUploadView: UIView {
    // MARK: - UI
    private lazy var addButton: DMUnderlinedButton = {
        let button = UIComponentsFactory.makeUnderlinedButton(title: AppText.addPhotosButton())
        button.addTarget(self, action: #selector(didPressAddSelector), for: .touchUpInside)
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    // MARK: - Private properties
    private let buttonAction: VoidCallback
    
    // MARK: - Init
    init(buttonAction: @escaping VoidCallback) {
        self.buttonAction = buttonAction
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods
private extension DMPhotoUploadView {
    func setup() {
        setupLayout()
        setupUI()
    }
    
    func setupLayout() {
        add(views: [collectionView, addButton], constraints: [
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: Margins.medium),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Margins.medium),
            
            addButton.heightAnchor.constraint(equalToConstant: Sizes.medium),
            addButton.widthAnchor.constraint(equalToConstant: Sizes.bigPlus),
            addButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            heightAnchor.constraint(equalToConstant: Sizes.big)
        ])
    }
    
    func setupUI() {
        backgroundColor = AppColor.mediumLightGray()
        layer.cornerRadius = 8
        isUserInteractionEnabled = true
        addShadowAround()
    }
}

// MARK: - Selectors
@objc private extension DMPhotoUploadView {
    func didPressAddSelector() {
        buttonAction()
    }
}
