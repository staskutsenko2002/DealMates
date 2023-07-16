//
//  TabController.swift
//  dealMates
//
//  Created by Stanislav on 06.05.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
    convenience init(items: [TabBarItem]) {
        self.init(nibName: nil, bundle: nil)
        self.setViewControllers(items.map({ $0.controller }), animated: true)
        tabBar.items?.enumerated().forEach({ (index, item) in
            item.image = items[index].page.image
            item.selectedImage = items[index].page.imageSelected
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = .black
        tabBar.isTranslucent = true
    }
}

