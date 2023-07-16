//
//  UIComponentsFactory.swift
//  dealMates
//
//  Created by Stanislav on 13.05.2023.
//

import UIKit

final class UIComponentsFactory {
    static func makeDMTextField(input: String? = nil, placeholder: String?) -> DMTextField {
        return DMTextField(placeholder: placeholder ?? "", input: input)
    }
    
    static func makeDMTextFieldWithPopUpPicker(input: String? = nil, placeholder: String?, items: [String]) -> DMTextFieldWithPopupPicker {
        let picker = DMTextFieldWithPopupPicker(placeholder: placeholder ?? "", input: input, items: [items])
        return picker
    }
    
    static func makeDMTextView(input: String? = nil, placeholder: String?) -> DMTextView {
        let textView = DMTextView(placeholder: placeholder ?? "")
        if let input {
            textView.input = input
        }
        return textView
    }
    
    static func makeDMTextFieldWithNumericPad(input: String? = nil, placeholder: String?) -> DMTextField {
        let textField = Self.makeDMTextField(input: input, placeholder: placeholder)
        textField.keyboardType = .numberPad
        return textField
    }
}
