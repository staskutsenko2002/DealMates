//
//  PageStateView.swift
//  dealMates
//
//  Created by Stanislav on 07.06.2023.
//

import UIKit

final class PageStateView: UIView {

    var state: State? {
        didSet {
            configure()
        }
    }

    private let titleLabel = UILabel()
    private let actionButton = UIButton(type: .system)

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}

// MARK: - Private
private extension PageStateView {
    func setupUI() {
        add(views: [titleLabel, actionButton], constraints: [
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            actionButton.heightAnchor.constraint(equalToConstant: 24),
            actionButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            actionButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40)
        ])



        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        titleLabel.textColor = AppColor.any_132_134_137()
        titleLabel.font = .handoSoft(size: 16, weight: .regular)

        actionButton.isHidden = true
        actionButton.setTitleColor(R.color.black(), for: .normal)
        actionButton.titleLabel?.font = .handoSoft(size: 16, weight: .bold)
        actionButton.addTarget(self, action: #selector(onAction), for: .touchUpInside)
    }

    func configure() {
        guard let state = state else { return erase() }

        titleLabel.text = state.title

        actionButton.isHidden = state.action == nil
        actionButton.setTitle(state.action?.title, for: .normal)
    }

    func erase() {
        titleLabel.text = nil

        actionButton.isHidden = true
        actionButton.setTitle(nil, for: .normal)
    }

    @objc
    func onAction() {
        state?.action?.onAction()
    }
}

// MARK: - State Object
extension PageStateView {
    struct State {
        let title: String
        let action: Action?
    }

    struct Action {
        let title: String
        let onAction: (() -> Void)
    }
}

