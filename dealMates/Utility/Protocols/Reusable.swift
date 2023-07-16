//
//  Reusable.swift
//  dealMates
//
//  Created by Stanislav on 13.05.2023.
//

import Foundation

protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
