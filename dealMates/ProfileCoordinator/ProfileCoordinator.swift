//
//  ProfileCoordinator.swift
//  dealMates
//
//  Created by Stanislav on 16.06.2023.
//

import UIKit
import Combine

final class ProfileCoordinator {
    
    private var cancellables = Set<AnyCancellable>()
    private lazy var navigationController = makeNavigationController()
    private lazy var profileViewController = makeProfileViewController(didBecomeExecutor: self.didBecomeExecutor)
    
    let didBecomeExecutor: CommonAction
    
    init(didBecomeExecutor: @escaping CommonAction) {
        self.didBecomeExecutor = didBecomeExecutor
    }
    
    func start() -> UINavigationController {
        return navigationController
    }
}

// MARK: - Private methods
private extension ProfileCoordinator {
    func makeNavigationController() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: profileViewController)
        navigationController.navigationBar.isHidden = true
        return navigationController
    }
    
    func makeProfileViewController(didBecomeExecutor: @escaping CommonAction) -> UIViewController {
        let viewModel = ProfileViewModel(
            networkService: NetworkService.shared,
            didBecomeExecutor: didBecomeExecutor
        )
        
        viewModel.didPressEditProfile = { [weak self] profileModel in
            guard let self else { return }
            self.pushEditViewController(profileModel: profileModel, onModelUpdate: { profileModel in
                viewModel.didUpdateProfile.send(profileModel)
            })
        }
        
        let viewController = ProfileViewController(viewModel: viewModel)
        return viewController
    }
    
    func makeProfileEditViewController(profileModel: ProfileModel, onModelUpdate: @escaping ((ProfileModel) -> ())) -> UIViewController {
        let viewModel = EditProfileViewModel(profileModel: profileModel, networkService: NetworkService.shared)
        let viewController = EditProfileViewController(viewModel: viewModel)
        
        viewModel.onModelUpdate.sink { profileModel in
            onModelUpdate(profileModel)
        }.store(in: &cancellables)
        
        return viewController
    }
    
    func pushEditViewController(profileModel: ProfileModel, onModelUpdate: @escaping ((ProfileModel) -> ())) {
        let viewController = makeProfileEditViewController(profileModel: profileModel, onModelUpdate: onModelUpdate)
        navigationController.pushViewController(viewController, animated: true)
    }
}
