//
//  SearchViewController.swift
//  dealMates
//
//  Created by Stanislav on 08.10.2023.
//

import UIKit

final class SearchViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: SearchViewModel
    
    // MARK: - UI
    private lazy var headerView: DMSearchHeaderView = {
        let headerView = DMSearchHeaderView()
        headerView.input = .init(query: viewModel.query,
                                 onBackAction: { [weak self] in
            self?.close()
        }, onFilterAction: { [weak self] in
            self?.filter()
        }, onSearchAction: { [weak self] query in
            
        })
        return headerView
    }()
    
    private lazy var requestTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(RequestTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var proposalCollectionView: UICollectionView = {
        let collectionLayout = UICollectionViewCompositionalLayout(sectionProvider: { [weak self] index, environment in
            guard let self else { fatalError() }
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(self.view.frame.width / 2), heightDimension: NSCollectionLayoutDimension.absolute(300))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(self.view.frame.width), heightDimension: NSCollectionLayoutDimension.absolute(300))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            return section
        })
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.refreshControl = refreshControl
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProposalCollectionViewCell.self)
        return collectionView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(didPullToRequestSelector), for: .valueChanged)
        return control
    }()
    
    // MARK: - Life cycle
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Private methods
private extension SearchViewController {
    func setupUI() {
        view.add(views: [headerView, requestTableView, proposalCollectionView], constraints: [
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 48),
            
            requestTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            requestTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            requestTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            requestTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            proposalCollectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            proposalCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            proposalCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            proposalCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        view.backgroundColor = .white
    }
    
    func close() {
        navigationController?.popViewController(animated: true)
    }
    
    func filter() {
        viewModel.pressFilter()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(RequestTableViewCell.self, for: indexPath)
//        cell.setup(cellModel: viewModel.cellModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(ProposalCollectionViewCell.self, for: indexPath)
//        cell.setup(cellModel: viewModel.cellModels[indexPath.item])
        return cell
    }
    
    
}

@objc
private extension SearchViewController {
    func didPullToRequestSelector() {
        
    }
}
