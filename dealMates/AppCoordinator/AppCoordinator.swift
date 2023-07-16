//
//  AppCoordinator.swift
//  dealMates
//
//  Created by Stanislav on 06.05.2023.
//

import UIKit
import Combine

final class AppCoordinator {
    
    var tabBarController: UITabBarController?
    
    private var window: UIWindow
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var authCoordinator = makeAuthCoodinator()
    private lazy var homeCoordinator: HomeCoordinator? = makeHomeCoordinator()
    private lazy var favouriteCoordinator: FavouriteCoodinator? = makeFavouriteCoordinator()
    private lazy var createCoordinator: CreateCoordinator? = makeCreateCoordinator()
    private lazy var profileCoordinator: ProfileCoordinator? = makeProfileCoordinator()
    
    private let networkService: NetworkServiceToken
    
    init(window: UIWindow) {
        self.window = window
        self.networkService = NetworkService.shared
        self.tabBarController = UITabBarController()
    }
    
    func start() {
        window.makeKeyAndVisible()
        if let accessToken: String = StorageService.loadValue(for: .accessToken, storage: .keychain) {
            networkService.update(token: accessToken)
            tabBarController = makeTabBarController()
            window.rootViewController = tabBarController
        } else {
            window.rootViewController = authCoordinator.start()
        }
    }
}

// MARK: - Private
private extension AppCoordinator {
    func makeTabBarController() -> TabBarController {
        return .init(
            items: [
                .init(controller: homeCoordinator!.start(), page: .home),
                .init(controller: favouriteCoordinator!.start(), page: .favourites),
                .init(controller: createCoordinator!.start(), page: .create),
                .init(controller: DependencyProvider.makeDealListViewController(), page: .deals),
                .init(controller: profileCoordinator!.start(), page: .profile)
            ]
        )
    }
    
    func startMainFlow() {
        window.rootViewController = tabBarController
    }
    
    func startAuthFlow() {
        window.rootViewController = authCoordinator.start()
    }
    
    func makeAuthCoodinator() -> AuthCoordinator {
        let authCoodinator = AuthCoordinator()
        
        authCoodinator.onSignIn.sink { [weak self] _ in
            guard let self else { return }
            self.homeCoordinator = self.makeHomeCoordinator()
            self.favouriteCoordinator = self.makeFavouriteCoordinator()
            self.createCoordinator = self.makeCreateCoordinator()
            self.profileCoordinator = self.makeProfileCoordinator()
            self.tabBarController = self.makeTabBarController()
            self.startMainFlow()
        }.store(in: &cancellables)
        
        return authCoodinator
    }
    
    func makeHomeCoordinator() -> HomeCoordinator {
        return HomeCoordinator()
    }
    
    func makeFavouriteCoordinator() -> FavouriteCoodinator {
        return FavouriteCoodinator()
    }
    
    func makeCreateCoordinator() -> CreateCoordinator {
        return CreateCoordinator()
    }
    
    func makeProfileCoordinator() -> ProfileCoordinator {
        let profileCoordinator = ProfileCoordinator(didBecomeExecutor: { [weak self] in
            guard let self else { return }
            StorageService.removeAllValue(storage: .keychain)
            self.homeCoordinator = nil
            self.favouriteCoordinator = nil
            self.createCoordinator = nil
            self.profileCoordinator = nil
            self.tabBarController = nil
            self.startAuthFlow()
        })
        return profileCoordinator
    }
}
