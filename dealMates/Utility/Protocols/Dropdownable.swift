//
//  Dropdownable.swift
//  dealMates
//
//  Created by Stanislav on 12.06.2023.
//

import Foundation

protocol Dropdownable {
    associatedtype DropdownPicker: Picker

    var picker: DropdownPicker { get }

    func showDropdown()
}
