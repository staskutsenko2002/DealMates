//
//  UIStoryboard+Extension.swift
//  dealMates
//
//  Created by Stanislav on 12.06.2023.
//

import UIKit

extension UIStoryboard {
    func instantiateController<T: UIViewController>() -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: T.identifier) as? T else {
            fatalError("Could not load view controller with identifier\(T.identifier)")
        }
        return viewController
    }
}

protocol StoryboardIdentifiable {
    static var identifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIViewController: StoryboardIdentifiable {}
