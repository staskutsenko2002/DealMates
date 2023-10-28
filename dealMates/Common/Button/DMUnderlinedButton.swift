//
//  DMUnderlinedButton.swift
//  dealMates
//
//  Created by Stanislav on 28.10.2023.
//

import UIKit

final class DMUnderlinedButton: UIButton {
    
    // MARK: - Override methods
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        setup(title: title)
    }
}

// MARK: - Private methods
private extension DMUnderlinedButton {
    func setup(title: String?) {
        guard let title else {
            titleLabel?.attributedText = .init(string: "")
            return
        }
        let attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue,
            NSAttributedString.Key.baselineOffset: Margins.xSmall,
            NSAttributedString.Key.font: UIFont.handoSoft(size: 20, weight: .bold)]
        let attributedString = NSAttributedString(string: title, attributes: attributes)
        titleLabel?.attributedText = attributedString
    }
}
