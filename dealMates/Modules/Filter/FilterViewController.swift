//
//  FilterViewController.swift
//  dealMates
//
//  Created by Stanislav on 28.10.2023.
//

import UIKit

final class FilterViewController: UIViewController {
    // MARK: - UI
    private lazy var headerView: DMHeaderView = {
        let headerView = DMHeaderView(title: AppText.filterTitle(),
                                      leftItem: .init(image: AppImage.cross(),
                                                      action: { [weak self] in
            self?.dismiss(animated: true)
        }))
                                      
        return headerView
    }()
    
    private let segmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [AppText.filterRequest(), AppText.filterProposal()])
        control.selectedSegmentIndex = 0
        control.tintColor = AppColor.mediumLightGray()
        control.selectedSegmentTintColor = AppColor.black()
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        return control
    }()
    
    private let scrollView = UIScrollView()
    
    private let containerView = UIView()
    
    private let categoryLabel = UIComponentsFactory.makeLabel(text: AppText.category(), font: .handoSoft(size: 20, weight: .bold))
    
    private let categoryField: DMTextFieldWithPopupPicker = {
        let field = DMTextFieldWithPopupPicker(placeholder: AppText.category(), items: [["washing", "repair"]])
        return field
    }()
    
    private let priceLabel = UIComponentsFactory.makeLabel(text: AppText.filterPrice(), font: .handoSoft(size: 20, weight: .bold))
    private let currencyField = UIComponentsFactory.makeDMTextField(placeholder: AppText.filterCurrency())
    private let minPriceField = UIComponentsFactory.makeDMTextFieldWithNumericPad(placeholder: AppText.filterMinPrice())
    private let maxPriceField = UIComponentsFactory.makeDMTextFieldWithNumericPad(placeholder: AppText.filterMaxPrice())
    
    private let experienceLabel = UIComponentsFactory.makeLabel(text: AppText.filterExperience(), font: .handoSoft(size: 20, weight: .bold))
    private let minExperienceField = UIComponentsFactory.makeDMTextFieldWithNumericPad(placeholder: AppText.filterMinExperience())
    private let maxExperienceField = UIComponentsFactory.makeDMTextFieldWithNumericPad(placeholder: AppText.filterMaxExperience())
    
    private lazy var applyButton = UIComponentsFactory.makeButton(title: AppText.filterApplyButton(),
                                                                  variant: .filled,
                                                                  action: { [weak self] in
        guard let self else { return }
        self.viewModel.applyFilters()
        self.dismiss(animated: true)
    })
    
    // MARK: - Private properties
    private let viewModel: FilterViewModel

    // MARK: - Life cycle
    init(viewModel: FilterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK: - Setup methods
private extension FilterViewController {
    func setup() {
        setupLayout()
        setupUI()
    }
    
    func setupLayout() {
        view.add(views: [headerView, segmentControl, scrollView], constraints: [
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 48),
            
            segmentControl.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: Margins.xMedium),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Margins.large),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Margins.large),
            
            scrollView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: Margins.xMedium),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        scrollView.add(view: containerView, constraints: [
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            containerView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
        
        containerView.add(views: [categoryLabel, categoryField, priceLabel, currencyField, minPriceField, maxPriceField, experienceLabel, minExperienceField, maxExperienceField, applyButton], constraints: [
            categoryLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            categoryLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Margins.large),
            categoryLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Margins.large),
            
            categoryField.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: Margins.medium),
            categoryField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Margins.large),
            categoryField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Margins.large),
            
            priceLabel.topAnchor.constraint(equalTo: categoryField.bottomAnchor, constant: Margins.large),
            priceLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Margins.large),
            priceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Margins.large),
            
            currencyField.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: Margins.medium),
            currencyField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Margins.large),
            currencyField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Margins.large),
            
            minPriceField.topAnchor.constraint(equalTo: currencyField.bottomAnchor, constant: Margins.xMedium),
            minPriceField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Margins.large),
            minPriceField.widthAnchor.constraint(equalTo: maxPriceField.widthAnchor),
            
            maxPriceField.topAnchor.constraint(equalTo: currencyField.bottomAnchor, constant: Margins.xMedium),
            maxPriceField.leadingAnchor.constraint(equalTo: minPriceField.trailingAnchor, constant: Margins.large),
            maxPriceField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Margins.large),
            
            experienceLabel.topAnchor.constraint(equalTo: maxPriceField.bottomAnchor, constant: Margins.large),
            experienceLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Margins.large),
            experienceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Margins.large),
            
            minExperienceField.topAnchor.constraint(equalTo: experienceLabel.bottomAnchor, constant: Margins.xMedium),
            minExperienceField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Margins.large),
            minExperienceField.widthAnchor.constraint(equalTo: maxExperienceField.widthAnchor),
            
            maxExperienceField.topAnchor.constraint(equalTo: experienceLabel.bottomAnchor, constant: Margins.xMedium),
            maxExperienceField.leadingAnchor.constraint(equalTo: minExperienceField.trailingAnchor, constant: Margins.large),
            maxExperienceField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Margins.large),
            
            applyButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Margins.large),
            applyButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Margins.large),
            applyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Margins.large),
            applyButton.heightAnchor.constraint(equalToConstant: Sizes.medium),
        ])
    }
    
    func setupUI() {
        view.backgroundColor = AppColor.white()
        scrollView.backgroundColor = AppColor.white()
    }
}
