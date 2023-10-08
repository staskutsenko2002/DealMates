//
//  AuthCoodrinator.swift
//  dealMates
//
//  Created by Stanislav on 03.06.2023.
//

import UIKit
import Combine

final class AuthCoordinator {
    
    let onSignIn = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var navigationController = makeNavigationController()
    private lazy var signInViewController = makeSignInViewController()

    
    func start() -> UINavigationController {
        return navigationController
    }
}

// MARK: - Setup methods
private extension AuthCoordinator {
    func makeNavigationController() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: signInViewController)
        navigationController.navigationBar.isHidden = true
        return navigationController
    }
    
    func makeSignInViewController() -> UIViewController {
        let viewModel = SignInViewModel(networkService: NetworkService.shared)
        
        viewModel.onSignUp.sink { [weak self] _ in
            self?.presentSignUpViewController()
        }.store(in: &cancellables)
        
        viewModel.onSignIn.sink { [weak self] _ in
            self?.onSignIn.send()
        }.store(in: &cancellables)
        
        let viewController = SignInViewController(viewModel: viewModel)
        return viewController
    }
    
    func presentSignUpViewController() {
        let viewController = makeSignUpViewController()
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .coverVertical
        navigationController.present(viewController, animated: true)
    }
    
    func makeSignUpViewController() -> UIViewController {
        let viewModel = SignUpViewModel(networService: NetworkService.shared)
        return SignUpViewController(viewModel: viewModel)
    }
}
