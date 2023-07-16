//
//  Picker.swift
//  dealMates
//
//  Created by Stanislav on 12.06.2023.
//

import Foundation

protocol Picker {
    associatedtype ItemsType
    associatedtype SelectedItemsType

    var items: ItemsType { get }
    var selectionButtonDidTap: (() -> Void)? { get }
    var selectedItemsHandler: ((SelectedItemsType) -> Void)? { get set }
}
