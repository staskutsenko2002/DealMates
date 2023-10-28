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
    
    // MARK: - Exposed Properties
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
    
    // MARK: - Init
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupDefaultValues()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDefaultValues()
    }
    
    // MARK: - Override methods
    override func draw(_ rect: CGRect) {
        self.updateStyle()
        super.draw(rect)
    }
}

// MARK: - Private methods
private extension DMButton {
    func setupDefaultValues() {
        layer.cornerRadius = 10
        clipsToBounds = true
    }

    func updateStyle() {
        if let titleLabel = self.titleLabel {
            titleLabel.textAlignment = .center
            titleLabel.font = .handoSoft(size: 18, weight: .bold)
        }

        switch self.variant {
        case .sketched(let color):
            layer.borderWidth = 1
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
