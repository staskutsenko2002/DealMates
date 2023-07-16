//
//  ProposalViewController.swift
//  dealMates
//
//  Created by Stanislav on 15.06.2023.
//

import UIKit

final class ProposalViewController: UIViewController {
    
    private let viewModel: ProposalViewModel
    
    private lazy var headerView: DMHeaderView = {
        let view = DMHeaderView(
            title: AppText.proposals(),
            leftItem: .init(image: AppImage.arrowLeft(), action: { [weak self] in
                guard let self else { return }
                self.navigationController?.popViewController(animated: true)
            })
        )
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionLayout = UICollectionViewCompositionalLayout(sectionProvider: { [weak self] index, environment in
            guard let self else { fatalError() }
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: NSCollectionLayoutDimension.absolute(240))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: NSCollectionLayoutDimension.estimated(240))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            return section
        })
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        return collectionView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .handoSoft(size: 18, weight: .bold)
        label.textColor = AppColor.black()
        label.numberOfLines = 2
        label.numberOfLines = 10
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .handoSoft(size: 16, weight: .regular)
        label.textColor = AppColor.black()
        label.numberOfLines = 10
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .handoSoft(size: 14, weight: .bold)
        label.textColor = AppColor.any_132_134_137()
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .handoSoft(size: 14, weight: .bold)
        label.textColor = AppColor.any_132_134_137()
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .handoSoft(size: 14, weight: .bold)
        label.textColor = AppColor.any_132_134_137()
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .handoSoft(size: 20, weight: .bold)
        label.textColor = AppColor.black()
        return label
    }()
    
    private lazy var contactButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didPressContactButton), for: .touchUpInside)
        button.setTitle("Conversation", for: .normal)
        button.backgroundColor = AppColor.black()
        button.setTitleColor(AppColor.white(), for: .normal)
        button.titleLabel?.font = .handoSoft(size: 18, weight: .bold)
        return button
    }()
    
    init(viewModel: ProposalViewModel) {
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
    }
}

// MARK: - Setup methods
private extension ProposalViewController {
    func setupUI() {
        view.backgroundColor = AppColor.white()
        titleLabel.text = viewModel.proposal.title
        categoryLabel.text = viewModel.proposal.category.name
        dateLabel.text = viewModel.proposal.publishDate
        descriptionLabel.text = viewModel.proposal.description
        locationLabel.text = viewModel.proposal.location
        priceLabel.text = viewModel.proposal.price
    }
    
    func setupLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.add(views: [headerView, collectionView, titleLabel, priceLabel, dateLabel, locationLabel, categoryLabel, descriptionLabel, contactButton], constraints: [
            headerView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 5),
            collectionView.heightAnchor.constraint(equalToConstant: 240),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: -10),
            
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            priceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            categoryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            
            dateLabel.leadingAnchor.constraint(equalTo: categoryLabel.trailingAnchor, constant: 16),
            dateLabel.topAnchor.constraint(equalTo: categoryLabel.topAnchor),
            
            locationLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 16),
            locationLabel.topAnchor.constraint(equalTo: categoryLabel.topAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            contactButton.heightAnchor.constraint(equalToConstant: 40),
            contactButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contactButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            contactButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20)
        ])
    }
}

// MARK: - Selectors
@objc private extension ProposalViewController {
    func didPressContactButton() {
        
    }
}
