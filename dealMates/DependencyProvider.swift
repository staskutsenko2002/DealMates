//
//  DependencyProvider.swift
//  dealMates
//
//  Created by Stanislav on 13.05.2023.
//

import UIKit

final class DependencyProvider {
    
    static func makeDealListViewController() -> UIViewController {
        let viewController = DealListViewController()
        viewController.title = AppText.deals()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.isHidden = true
        return navigationController
    }
}
