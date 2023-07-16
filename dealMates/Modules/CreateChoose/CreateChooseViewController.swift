//
//  CreateChooseViewController.swift
//  dealMates
//
//  Created by Stanislav on 15.06.2023.
//

import UIKit

enum CreationType {
    case proposal
    case request
}

final class CreateChooseViewController: UIViewController {
    
    private lazy var headerView: DMHeaderView = {
        let view = DMHeaderView(title: AppText.create())
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .handoSoft(size: 24, weight: .bold)
        label.text = AppText.createQuestion()
        label.textAlignment = .center
        label.textColor = AppColor.black()
        return label
    }()
    
    private lazy var proposalButton: DMButton = {
        let button = DMButton()
        button.addTarget(self, action: #selector(didPressProposal), for: .touchUpInside)
        button.setTitle("Proposal", for: .normal)
        button.variant = .sketched(color: AppColor.black())
        button.setTitleColor(AppColor.black(), for: .normal)
        return button
    }()
    
    private lazy var requestButton: DMButton = {
        let button = DMButton()
        button.addTarget(self, action: #selector(didPressRequest), for: .touchUpInside)
        button.setTitle("Request", for: .normal)
        button.variant = .filled
        button.setTitleColor(AppColor.white(), for: .normal)
        return button
    }()
    
    private let didPressChoose: ((CreationType) -> ())
    
    init(didPressChoose: @escaping ((CreationType) -> ())) {
        self.didPressChoose = didPressChoose
        super.init(nibName: nil, bundle: nil)
        self.title = "Create"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        view.backgroundColor = AppColor.white()
    }
}
                        
// MARK: - Setup methods
private extension CreateChooseViewController {
    func setupLayout() {
        
        let safeArea = view.safeAreaLayoutGuide
        
        view.add(views: [titleLabel, proposalButton, requestButton], constraints: [
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 180),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            proposalButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            proposalButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            proposalButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 180),
            proposalButton.heightAnchor.constraint(equalToConstant: 40),
            
            requestButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            requestButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            requestButton.topAnchor.constraint(equalTo: proposalButton.bottomAnchor, constant: 30),
            requestButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}

// MARK: - Selector
@objc private extension CreateChooseViewController {
    func didPressProposal() {
        didPressChoose(.proposal)
    }
    
    func didPressRequest() {
        didPressChoose(.request)
    }
}
