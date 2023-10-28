//
//  HomeCoordinator.swift
//  dealMates
//
//  Created by Stanislav on 04.06.2023.
//

import UIKit

final class HomeCoordinator {
    private lazy var navigationController = makeNavigationController()
    private lazy var homeViewController = makeHomeViewController()
    
    // MARK: - Exposed methods
    func start() -> UINavigationController {
        return navigationController
    }
}

// MARK: - Private methods
private extension HomeCoordinator {
    func makeNavigationController() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: homeViewController)
        navigationController.navigationBar.isHidden = true
        return navigationController
    }
    
    func makeHomeViewController() -> UIViewController {
        let viewModel = HomeViewModel(networkService: NetworkService.shared,
                                      didPressSearchCallback: { [weak self] query in
            guard let self else { return }
            let viewController = self.makeSearchViewController(query: query)
            self.navigationController.pushViewController(viewController, animated: true)
        })
        let viewController = HomeViewController(
            viewModel: viewModel,
            viewControllers: [
                (AppText.proposals(), makeProposalListViewController()),
                (AppText.requests(), makeRequestsListViewController()),
            ]
        )
        return viewController
    }
    
    func makeProposalListViewController() -> UIViewController {
        let viewModel = ProposalListViewModel(
            isFavourites: false,
            networkService: NetworkService.shared,
            didSelectProposal: { [weak self] cellModel in
                guard let self else { return }
                let viewController = self.makeProposalViewController(cellModel: cellModel)
                self.navigationController.pushViewController(viewController, animated: true)
            })
        let viewController = ProposalListViewController(viewModel: viewModel)
        return viewController
    }
    
    func makeRequestsListViewController() -> UIViewController {
        let viewModel = RequestListViewModel(isFavourite: false, networkService: NetworkService.shared)
        let viewController = RequestListViewController(viewModel: viewModel)
        return viewController
    }
    
    func makeProposalViewController(cellModel: ProposalCellModel) -> UIViewController {
        let viewModel = ProposalViewModel(proposal: cellModel)
        let viewController = ProposalViewController(viewModel: viewModel)
        return viewController
    }
    
    func makeSearchViewController(query: String) -> UIViewController {
        let viewModel = SearchViewModel(query: query, filterAction: { [weak self] in
            self?.presentFilter()
        })
        let viewController = SearchViewController(viewModel: viewModel)
        return viewController
    }
    
    func presentFilter() {
        let viewModel = FilterViewModel()
        let viewContoller = FilterViewController(viewModel: viewModel)
        viewContoller.modalPresentationStyle = .fullScreen
        navigationController.present(viewContoller, animated: true)
    }
}
