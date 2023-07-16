//
//  UIStackView+Extension.swift
//  dealMates
//
//  Created by Stanislav on 13.05.2023.
//

import UIKit

extension UIStackView {
    // MARK: - Initializers
    convenience init(arrangedSubviews: [UIView], setup: (UIStackView) -> Void) {
        self.init(arrangedSubviews: arrangedSubviews)
        setup(self)
    }

    convenience init(setup: (UIStackView) -> Void) {
        self.init(frame: .zero)
        setup(self)
    }

    // MARK: - Functions
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { view in
            self.addArrangedSubview(view)
        }
    }

    func addArrangedSubviews(views: [UIView]) {
        views.forEach { view in
            self.addArrangedSubview(view)
        }
    }

    func addArrangedSubview(_ view: UIView, withSpacing spacing: CGFloat) {
        let view = view
        addArrangedSubview(view)
        setCustomSpacing(spacing, after: view)
    }

    func removeAllSubviews() {
        self.subviews.forEach { view in
            view.removeFromSuperview()
        }
    }

    /// Makes gap with CGFloat parameter in UIStackView
    func addSpacer(withHeight height: CGFloat? = nil) {

        if let height = height {
            let view = UIView()
            view.backgroundColor = .clear
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: height).isActive = true
            addArrangedSubview(view)
        } else {
            addArrangedSubview(UIView())
        }
    }
}
