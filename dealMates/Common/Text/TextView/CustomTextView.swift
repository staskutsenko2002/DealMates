//
//  CustomTextView.swift
//  dealMates
//
//  Created by Stanislav on 28.10.2023.
//

import UIKit

final class CustomTextView: UITextView {
    // MARK: - Exposed properties
    var textSelectionEnabled: Bool = true

    // MARK: - Init
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }

    // MARK: - Override methods
    override func becomeFirstResponder() -> Bool {
        if let safeSuperview = superview,
           let safeSuperview2 = safeSuperview.superview,
           let safeSuperview3 = safeSuperview2.superview,
           safeSuperview3.canBecomeFirstResponder {
            safeSuperview3.becomeFirstResponder()
            return false
        }
        return super.becomeFirstResponder()
    }

    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        if textSelectionEnabled {
            return super.selectionRects(for: range)
        } else {
            return []
        }
    }

    override func caretRect(for position: UITextPosition) -> CGRect {
        if textSelectionEnabled {
            return super.caretRect(for: position)
        } else {
            return .null
        }
    }
}

// MARK: - Private methods
private extension CustomTextView {
    func commonInit() {
        textContainerInset = UIEdgeInsets(top: Margins.xMedium, left: Margins.xMedium, bottom: Margins.xMedium, right: Margins.xMedium)
        font = .handoSoft(size: 16, weight: .bold)
    }
}
