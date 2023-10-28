//
//  UIView+Extension.swift
//  dealMates
//
//  Created by Stanislav on 13.05.2023.
//

import UIKit

extension UIView {
    func add(views: [UIView], constraints: [NSLayoutConstraint]) {
        views.forEach {
            $0.prepareForAutoLayout()
            addSubview($0)
        }

        NSLayoutConstraint.activate(constraints)
    }

    func add(view: UIView, constraints: [NSLayoutConstraint]) {
        add(views: [view], constraints: constraints)
    }
    
    func prepareForAutoLayout() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// Add a VisualEffectLayer with UIBlurEffect. Intensity can be in range from 0.0 to 1.0
    func addBlur(intensity: CGFloat = 0.1, blurStyle: UIBlurEffect.Style) -> UIVisualEffectView {
        let blurEffect = VisualEffectView(effect: UIBlurEffect(style: blurStyle), intensity: intensity)
        self.addSubview(blurEffect)
        blurEffect.frame = self.bounds
        blurEffect.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffect
    }
    
    func pinToSuperview(insets: UIEdgeInsets = .zero) {
        guard let superview = self.superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: insets.bottom),
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left),
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: insets.right)
        ])
    }
    
    func addShadowForSquareView(opacity: Float, width: CGFloat, height: CGFloat) {
        layer.shadowOpacity = opacity
        layer.shadowOffset = CGSize(width: width, height: height)
    }
    
    func addShadowAround() {
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.6
        layer.shadowRadius = 5
        layer.shadowColor  = UIColor.black.cgColor
    }
}
