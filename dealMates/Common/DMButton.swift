//
//  DMButton.swift
//  dealMates
//
//  Created by Stanislav on 08.05.2023.
//

import UIKit

final class DMButton: UIButton {
    enum Variant {
        case filled
        case sketched(color: UIColor?)
    }

    private enum Constants {
        static let fontSize = CGFloat(18)
        static let font = UIFont.handoSoft(size: 18, weight: .bold)
        static let shimmerLayerName: String = "shimmerLayer"
    }

    // MARK: Properties
    var variant: DMButton.Variant = .filled {
        didSet {
            updateStyle()
        }
    }

    // MARK: - Overrides
    override var isEnabled: Bool {
        didSet {
            updateStyle()
        }
    }

    override var isHighlighted: Bool {
        didSet {
            updateStyle()
        }
    }

    override func draw(_ rect: CGRect) {
        self.updateStyle()
        super.draw(rect)
    }

    // MARK: - Initiazlizers
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupDefaultValues()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDefaultValues()
    }

    // MARK: - Functions
    private func setupDefaultValues() {
        layer.cornerRadius = 0
        clipsToBounds = true
    }

    private func updateStyle() {
        if let titleLabel = self.titleLabel {
            titleLabel.textAlignment = .center
            titleLabel.font = Constants.font
        }

        switch self.variant {
        case .sketched(let color):
            layer.borderWidth = 2
            layer.borderColor = color?.cgColor
            setTitleColor(color, for: .normal)
            backgroundColor = AppColor.white()

        case .filled:
            layer.borderWidth = 0
            switch state {
            case .normal:
                setTitleColor(AppColor.white(), for: state)
                backgroundColor = AppColor.black()
            default: break
            }
        }
    }
}
