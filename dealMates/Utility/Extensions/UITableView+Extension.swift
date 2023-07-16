//
//  UITableView+Extension.swift
//  dealMates
//
//  Created by Stanislav on 10.06.2023.
//

import UIKit

extension UITableView {
    // MARK: - UITableViewCell
    func register<T: UITableViewCell>(_: T.Type) where T: Reusable {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }

    func dequeue<T: UITableViewCell>(_: T.Type, for indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            abort()
        }
        return cell
    }

    // MARK: - UITableViewHeaderFooterView
    func dequeue<T: UITableViewHeaderFooterView>(_: T.Type) -> T where T: Reusable {
        guard let header = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
            abort()
        }
        return header
    }
}
