//
//  ProposalListViewController.swift
//  dealMates
//
//  Created by Stanislav on 13.05.2023.
//

import UIKit
import Combine

final class ProposalListViewController: UIViewController {
    
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: ProposalListViewModel
    
    private lazy var collectionView: UICollectionView = {
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
        control.addTarget(self, action: #selector(didPullToRequest), for: .valueChanged)
        return control
    }()
    
    
    // MARK: - Lifecycle
    init(viewModel: ProposalListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupSubscription()
        view.backgroundColor = .white
        viewModel.getProposals()
    }
}

// MARK: - Setup functions
private extension ProposalListViewController {
    func setupLayout() {
        view.add(views: [collectionView], constraints: [
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupSubscription() {
        viewModel.$status.sink(receiveValue: { [weak self] status in
            guard let self else { return }
            DispatchQueue.main.async {
                switch status {
                case .empty:
                    self.showEmptyView()
                    self.refreshControl.endRefreshing()
                        
                case .error(let message):
                    self.showError(title: message)
                    self.refreshControl.endRefreshing()
                    
                case .loaded:
                    self.hideStateView()
                    self.refreshControl.endRefreshing()

                case .loading:
                    self.startLoading()
                    
                case .idle:
                    self.refreshControl.endRefreshing()
                }
                self.collectionView.reloadData()
            }
        })
        .store(in: &cancellables)
        
        viewModel.onRemoveLiked.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }.store(in: &cancellables)
    }
}

// MARK: - StateView methods
private extension ProposalListViewController {
    func startLoading() {
        let loadingView = PageStateView()
        loadingView.state = .init(title: "Loading", action: nil)
        showStateView(loadingView)
    }

    func showEmptyView() {
        let emptyView = PageStateView()
        emptyView.state = .init(title: "No proposals for now...", action: nil)
        showStateView(emptyView)
    }

    func showError(title: String) {
        let errorView = PageStateView()
        errorView.state = .init(
            title: title,
            action: .init(title: "Retry", onAction: { [weak self] in
                self?.hideStateView()
            self?.viewModel.getProposals()
            }))
        showStateView(errorView)
    }

    func showStateView(_ stateView: PageStateView) {
        collectionView.backgroundView = stateView
    }

    func hideStateView() {
        collectionView.backgroundView?.removeFromSuperview()
        collectionView.backgroundView = nil
    }
}

// MARK: - Selectors
@objc private extension ProposalListViewController {
    func didPullToRequest() {
        viewModel.getProposals()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ProposalListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cellModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(ProposalCollectionViewCell.self, for: indexPath)
        cell.setup(cellModel: viewModel.cellModels[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.select(item: indexPath.item)
    }
}
