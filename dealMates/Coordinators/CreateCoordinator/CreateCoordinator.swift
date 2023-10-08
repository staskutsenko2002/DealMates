//
//  CreateCoordinator.swift
//  dealMates
//
//  Created by Stanislav on 12.06.2023.
//

import UIKit

final class CreateCoordinator {
    
    private lazy var navigationController = makeNavigationController()
    private var creationChooseViewController: UIViewController?
    private let networkService: NetworkServiceUserInfo = NetworkService.shared
    
    func start() -> UINavigationController {
        return navigationController
    }
}

// MARK: - Private
private extension CreateCoordinator {
    func makeNavigationController() -> UINavigationController {
        if networkService.isExecutor == true {
            creationChooseViewController = makeCreateChooseViewController(didPressChoose: { [weak self] type in
                guard let self else { return }
                let viewController = self.makeCreateViewController(creationType: type)
                self.navigationController.pushViewController(viewController, animated: true)
            })
            
            guard let creationChooseViewController else { return .init() }
            let navigationController = UINavigationController(rootViewController: creationChooseViewController)
            navigationController.navigationBar.isHidden = true
            return navigationController
        } else {
            let navigationController = UINavigationController(rootViewController: makeCreateViewController(creationType: .request))
            navigationController.navigationBar.isHidden = true
            return navigationController
        }
        
    }
    
    func makeCreateViewController(creationType: CreationType) -> UIViewController {
        let viewModel = CreateViewModel(creationType: creationType)
        let viewController = CreateViewController(viewModel: viewModel)
        return viewController
    }
    
    func makeCreateChooseViewController(didPressChoose: @escaping (CreationType) -> ()) -> UIViewController {
        let viewController = CreateChooseViewController(didPressChoose: didPressChoose)
        return viewController
    }
}
