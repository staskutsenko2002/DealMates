//
//  DMHeaderView.swift
//  dealMates
//
//  Created by Stanislav on 04.06.2023.
//

import UIKit

final class DMHeaderView: UIView {
    struct HeaderItem {
        let image: UIImage?
        let action: (() -> ())
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .handoSoft(size: 25, weight: .bold)
        label.textColor = AppColor.black()
        label.textAlignment = .center
        return label
    }()
    
    private let leftItem: HeaderItem?
    private let rightItem: HeaderItem?
    
    init(title: String? = nil, leftItem: HeaderItem? = nil, rightItem: HeaderItem? = nil) {
        self.leftItem = leftItem
        self.rightItem = rightItem
        super.init(frame: .zero)
        setupLayout()
        titleLabel.text = title
        
        if let leftItem {
            let button = UIButton()
            button.setImage(leftItem.image, for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.addTarget(self, action: #selector(didPressLeft), for: .touchUpInside)
            
            add(view: button, constraints: [
                button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                button.heightAnchor.constraint(equalToConstant: 16),
                button.widthAnchor.constraint(equalToConstant: 16),
                button.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
        
        if let rightItem {
            let button = UIButton()
            button.setImage(rightItem.image, for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.addTarget(self, action: #selector(didPressLeft), for: .touchUpInside)
            
            add(view: button, constraints: [
                button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                button.heightAnchor.constraint(equalToConstant: 16),
                button.widthAnchor.constraint(equalToConstant: 16),
                button.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(title: String) {
        titleLabel.text = title
    }
    
    private func setupLayout() {
        addSubview(titleLabel)
        
        add(view: titleLabel, constraints: [
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    @objc private func didPressLeft() {
        leftItem?.action()
    }
    
    @objc private func didPressRight() {
        rightItem?.action()
    }
}
