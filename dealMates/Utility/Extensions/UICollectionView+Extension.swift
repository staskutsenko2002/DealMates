//
//  UICollectionView+Extension.swift
//  dealMates
//
//  Created by Stanislav on 13.05.2023.
//

import UIKit

extension UICollectionView {

    func register<T: UICollectionViewCell>(_: T.Type) where T: Reusable {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    func dequeue<T: UICollectionViewCell>(_: T.Type, for indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            abort()
        }

        return cell
    }

    func registeHeader<T: UICollectionReusableView>(_: T.Type) where T: Reusable {
        register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.reuseIdentifier)
    }

    func dequeue<T: UICollectionReusableView>(_: T.Type, for indexPath: IndexPath) -> T where T: Reusable {
        guard let header = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            abort()
        }
        return header
    }
}
