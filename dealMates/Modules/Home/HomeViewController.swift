//
//  HomeViewController.swift
//  dealMates
//
//  Created by Stanislav on 13.05.2023.
//

import UIKit

typealias SegmentController = (title: String, controller: UIViewController)

final class HomeViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: HomeViewModel
    private let viewControllers: [SegmentController]
    private var currentElementIndex: Int
    
    // MARK: - UI
    private lazy var headerView: DMHomeSearchHeaderView = {
        let view = DMHomeSearchHeaderView()
        view.input = .init(title: AppText.projectName(),
                           shouldReturnAction:  { [weak self] query in
            self?.viewModel.openSearch(query: query)
        })
        return view
    }()
    
    private lazy var segmentedView: SegmentedView = {
        let segmentedView = SegmentedView()
        segmentedView.delegate = self
        segmentedView.setLabelsTitles(titles: viewControllers.map({ $0.title }))
        return segmentedView
    }()
    
    private let containerView = UIView()
    
    // MARK: - Life cycle
    init(viewModel: HomeViewModel,
         viewControllers: [SegmentController]) {
        self.viewModel = viewModel
        self.viewControllers = viewControllers
        self.currentElementIndex = 0
        super.init(nibName: nil, bundle: nil)
        self.title = viewModel.title
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

// MARK: - Setup function
private extension HomeViewController {
    func setupLayout() {
        if viewModel.isExecutor {
            setupLayoutForExecutor()
        } else {
            setupLayoutForUser()
        }
    }
    
    func setupLayoutForUser() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.add(views: [headerView, containerView], constraints: [
            headerView.heightAnchor.constraint(equalToConstant: 70),
            headerView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            containerView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        if let controller = viewControllers.first?.controller {
            containerView.add(views: [controller.view], constraints: [
                controller.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                controller.view.topAnchor.constraint(equalTo: containerView.topAnchor),
                controller.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                controller.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        }

    }
    
    func setupLayoutForExecutor() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.add(views: [headerView, segmentedView, containerView], constraints: [
            headerView.heightAnchor.constraint(equalToConstant: 70),
            headerView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            segmentedView.heightAnchor.constraint(equalToConstant: 50),
            segmentedView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            segmentedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            containerView.topAnchor.constraint(equalTo: segmentedView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        if let controller = viewControllers.first?.controller {
            containerView.add(views: [controller.view], constraints: [
                controller.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                controller.view.topAnchor.constraint(equalTo: containerView.topAnchor),
                controller.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                controller.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        }
    }
}

// MARK: - SegmentedViewDelegate
extension HomeViewController: SegmentedViewDelegate {
    func segmentedView(_ segmentedView: SegmentedView, didChangeSelectedSegmentAt index: Int) {
        viewControllers[currentElementIndex].controller.view?.removeFromSuperview()
        
        let controller = viewControllers[index].controller
        containerView.add(views: [controller.view], constraints: [
            controller.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            controller.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            controller.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            controller.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        currentElementIndex = index
    }
}
