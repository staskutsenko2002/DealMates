//
//  FavouriteCoodinator.swift
//  dealMates
//
//  Created by Stanislav on 07.06.2023.
//

import UIKit

final class FavouriteCoodinator {
    private lazy var navigationController = makeNavigationController()
    private lazy var homeViewController = makeFavouriteViewController()
    
    func start() -> UINavigationController {
        return navigationController
    }
}

// MARK: - Private
private extension FavouriteCoodinator {
    func makeNavigationController() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: homeViewController)
        navigationController.navigationBar.isHidden = true
        return navigationController
    }
    
    func makeFavouriteViewController() -> UIViewController {
        let viewModel = FavouriteViewModel(networkService: NetworkService.shared)
        let viewController = FavouriteViewController(
            viewModel: viewModel,
            viewControllers: [
                ("Proposals", makeProposalListViewController()),
                ("Requests", makeRequestsListViewController()),
            ]
        )
        return viewController
    }
    
    func makeProposalListViewController() -> UIViewController {
        let viewModel = ProposalListViewModel(
            isFavourites: true,
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
        let viewModel = RequestListViewModel(isFavourite: true, networkService: NetworkService.shared)
        let viewController = RequestListViewController(viewModel: viewModel)
        return viewController
    }
    
    func makeProposalViewController(cellModel: ProposalCellModel) -> UIViewController {
        let viewModel = ProposalViewModel(proposal: cellModel)
        let viewController = ProposalViewController(viewModel: viewModel)
        return viewController
    }
}
