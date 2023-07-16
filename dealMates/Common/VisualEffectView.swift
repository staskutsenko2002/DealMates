//
//  VisualEffectView.swift
//  dealMates
//
//  Created by Stanislav on 12.06.2023.
//

import Foundation

import UIKit

final class VisualEffectView: UIVisualEffectView {
    // MARK: - Properties
    private let theEffect: UIVisualEffect
    private let customIntensity: CGFloat
    private var animator: UIViewPropertyAnimator?

    // MARK: - Initializers

    /// Create visual effect view with given effect and its intensity
    ///
    /// - Parameters:
    ///   - effect: visual effect, eg UIBlurEffect(style: .dark)
    ///   - intensity: custom intensity from 0.0 (no effect) to 1.0 (full effect) using linear scale
    init(effect: UIVisualEffect, intensity: CGFloat) {
        theEffect = effect
        customIntensity = intensity
        super.init(effect: nil)
    }

    required init?(coder aDecoder: NSCoder) { nil }

    deinit {
        animator?.stopAnimation(true)
    }

    // MARK: - Overrides
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        effect = nil
        animator?.stopAnimation(true)
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [unowned self] in
            self.effect = theEffect
        }
        animator?.fractionComplete = customIntensity
    }
}
