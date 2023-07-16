//
//  DMPopUpPicker.swift
//  Tread Athletics
//
//  Created by Konstantin Bezzemelnyi on 03.05.2022.
//

import UIKit

struct UIViewPickerSelectedOption {
	let row: Int
	let component: Int
}

typealias DMPopUpPickerSelection = ((string: String, pickerSelectionOption: UIViewPickerSelectedOption))

final class DMPopUpPicker: UIViewController, Picker {
	typealias ItemsType = [[String]]
	typealias SelectedItemsType = [DMPopUpPickerSelection]

	var items: ItemsType = []
	var selectionButtonDidTap: (() -> Void)?
	var selectedItemsHandler: ((SelectedItemsType) -> Void)?
	private var defaultSelectedOptions: [UIViewPickerSelectedOption] = []
	var selectedOptions: SelectedItemsType? {
		didSet {
			guard let pickerView = pickerView,
			      let selectedOptions = selectedOptions
			else { return }

			selectedItemsHandler?(selectedOptions)
			pickerView.selectOptionsInPicker(selectedOptions.map { $0.pickerSelectionOption })
		}
	}

	/// If it ==  pickerView's selectedStrings(f.i., ["0 hours", "0 minutes"]), the option can not be selected
	var abandonedPickerOptionsRow: [String]?
	var selectButtonShouldBeHidden: Bool {
		guard let abandonedPickerOptions = abandonedPickerOptionsRow
		else { return false }

		return abandonedPickerOptions == pickerSelectedOptions.map { $0.string }
	}

	var optionsFont: UIFont = .handoSoft(size: 22, weight: .regular)

	@IBOutlet private var selectButton: UIButton!
	@IBOutlet private var pickerView: UIPickerView!

	override func viewDidLoad() {
		super.viewDidLoad()
		pickerView.delegate = self
		pickerView.dataSource = self
		setupViews()

		defaultSelectedOptions.forEach { defaultSelectedOption in
			selectOption(selectedOption: defaultSelectedOption, animated: false)
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		selectButton.isHidden = selectButtonShouldBeHidden
	}

	private func setupViews() {
		let blur = view.addBlur(intensity: 0.1, blurStyle: .dark)
		view.sendSubviewToBack(blur)
		if let selectedOptions = selectedOptions {
			self.pickerView.selectOptionsInPicker(selectedOptions.map { $0.pickerSelectionOption })
		}
	}

	@IBAction private func onChooseButtonClicked(_ sender: Any) {
		guard !selectButtonShouldBeHidden else { return }

		let selectedOptions = pickerSelectedOptions
		self.selectedItemsHandler?(selectedOptions)
		self.selectedOptions = selectedOptions

		selectionButtonDidTap?()
		dismiss(animated: true)
	}

	@IBAction private func onTouchOutsideOfPicker(_ sender: Any) {
		dismiss(animated: true)
	}

	func selectOptionsInPicker(_ options: SelectedItemsType) {
		guard let pickerView = self.pickerView else {
			self.selectedOptions = options
			return
		}

		pickerView.selectOptionsInPicker(options.map { ($0.pickerSelectionOption) })
	}

	func selectOption(selectedOption: UIViewPickerSelectedOption, animated: Bool) {

		guard isViewLoaded else {
			self.defaultSelectedOptions.append(selectedOption)
			return
		}

		pickerView.selectRow(selectedOption.row, inComponent: selectedOption.component, animated: animated)
	}
}

extension UIPickerView {
	func selectOptionsInPicker(_ options: [UIViewPickerSelectedOption]) {
		options.forEach { option in
			self.selectRow(
				option.row,
				inComponent: option.component,
				animated: true
			)
		}
	}
}

extension DMPopUpPicker: UIPickerViewDelegate, UIPickerViewDataSource {
	var pickerSelectedOptions: SelectedItemsType {
		items.enumerated().reduce(into: SelectedItemsType()) { partialResult, element in
			let pickerComponent = element.offset
			let selectedRow = pickerView.selectedRow(inComponent: pickerComponent)
			partialResult.append((
				string: items[pickerComponent][selectedRow],
				pickerSelectionOption: .init(row: selectedRow, component: pickerComponent)
			))
		}
	}

	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return items.count
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return items[component].count
	}

	func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
		let label = UILabel()
		label.textAlignment = .center
		label.attributedText = NSAttributedString(
			string: items.safelyRetrieve(elementAt: component)?.safelyRetrieve(elementAt: row) ?? "",
			attributes: [
				NSAttributedString.Key.foregroundColor: AppColor.white() ?? .white,
				.font: optionsFont
			])
		return label
	}

	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		selectButton.isHidden = selectButtonShouldBeHidden
	}
}
