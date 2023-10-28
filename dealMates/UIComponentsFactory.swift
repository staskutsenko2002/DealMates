//
//  UIComponentsFactory.swift
//  dealMates
//
//  Created by Stanislav on 13.05.2023.
//

import UIKit

final class UIComponentsFactory {
    // MARK: - TextField
    static func makeDMTextField(input: String? = nil, placeholder: String?) -> DMTextField {
        return DMTextField(placeholder: placeholder ?? "", input: input)
    }
    
    static func makeDMTextFieldWithPopUpPicker(input: String? = nil, placeholder: String?, items: [String]) -> DMTextFieldWithPopupPicker {
        let picker = DMTextFieldWithPopupPicker(placeholder: placeholder ?? "", input: input, items: [items])
        return picker
    }
    
    static func makeDMTextFieldWithNumericPad(input: String? = nil, placeholder: String?) -> DMTextField {
        let textField = Self.makeDMTextField(input: input, placeholder: placeholder)
        textField.keyboardType = .numberPad
        return textField
    }
    
    // MARK: - TextView
    static func makeDMTextView(input: String? = nil, placeholder: String?) -> DMTextView {
        let textView = DMTextView(placeholder: placeholder ?? "")
        if let input {
            textView.input = input
        }
        return textView
    }
    
    // MARK: - Label
    static func makeLabel(text: String, font: UIFont, textColor: UIColor = .black, numberOfLines: Int = 1) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.numberOfLines = numberOfLines
        label.textColor = textColor
        return label
    }
    
    // MARK: - Button
    static func makeButton(title: String, variant: DMButton.Variant, action: VoidCallback? = nil) -> DMButton {
        let button = DMButton()
        button.variant = variant
        button.addAction(.init(handler: { _ in
            action?()
        }), for: .touchUpInside)
        button.setTitle(title, for: .normal)
        return button
    }
    
    static func makeUnderlinedButton(title: String, textColor: UIColor = .black, selectedTextColor: UIColor? = AppColor.lightGray()) -> DMUnderlinedButton {
        let button = DMUnderlinedButton()
        button.setTitleColor(textColor, for: .normal)
        button.setTitleColor(selectedTextColor, for: .selected)
        button.setTitle(title, for: .normal)
        return button
    }
}
