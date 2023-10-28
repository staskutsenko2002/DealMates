//
//  RequestListViewController.swift
//  dealMates
//
//  Created by Stanislav on 04.06.2023.
//

import UIKit
import Combine

final class RequestListViewController: UIViewController {
    
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: RequestListViewModel
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(RequestTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(didPullToRequest), for: .valueChanged)
        return control
    }()
    
    init(viewModel: RequestListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        setupSubscription()
        viewModel.getRequests()
    }
    
    private func setupLayout() {
        view.add(view: tableView, constraints: [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupSubscription() {
        viewModel.$status.sink(receiveValue: { [weak self] status in
            guard let self else { return }
            DispatchQueue.main.async {
                switch status {
                case .empty:
                    self.showEmptyView()
                    self.tableView.reloadData()
                        
                case .error(let message):
                    self.showError(title: message)
                    self.tableView.reloadData()
                    
                case .loaded:
                    self.hideStateView()
                    self.tableView.reloadData()

                case .loading:
                    self.startLoading()
                    
                case .idle:
                    break
                }
            }
        })
        .store(in: &cancellables)
    }
}

// MARK: - StateView methods
private extension RequestListViewController {
    func startLoading() {
        let loadingView = PageStateView()
        loadingView.state = .init(title: "Loading", action: nil)
        showStateView(loadingView)
    }

    func showEmptyView() {
        let emptyView = PageStateView()
        emptyView.state = .init(title: "No requests for now...", action: nil)
        showStateView(emptyView)
    }

    func showError(title: String) {
        let errorView = PageStateView()
        errorView.state = .init(
            title: title,
            action: .init(title: "Retry", onAction: { [weak self] in
                self?.hideStateView()
            self?.viewModel.getRequests()
            }))
        showStateView(errorView)
    }

    func showStateView(_ stateView: PageStateView) {
        tableView.backgroundView = stateView
    }

    func hideStateView() {
        tableView.backgroundView?.removeFromSuperview()
        tableView.backgroundView = nil
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension RequestListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(RequestTableViewCell.self, for: indexPath)
        cell.setup(cellModel: viewModel.cellModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - Selectors
@objc private extension RequestListViewController {
    func didPullToRequest() {
        viewModel.getRequests()
    }
}
