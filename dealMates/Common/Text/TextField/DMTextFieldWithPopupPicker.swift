//
//  DMTextFieldWithPopupPicker.swift
//  Tread Athletics
//
//  Created by Konstantin Bezzemelnyi on 07.07.2022.
//

import UIKit

final class DMTextFieldWithPopupPicker: DMTextField, Dropdownable {
	typealias DropdownPicker = DMPopUpPicker

	// MARK: - Properties
	lazy var picker: DMPopUpPicker = makePicker()

	var onClickAction: (() -> Void)?

	/// Default is set to false
	var shouldMoveNextAfterSelectAction: Bool = false

	// MARK: - Overrides
	override var canBecomeFirstResponder: Bool {
		return true
	}

	@discardableResult
	override func becomeFirstResponder() -> Bool {
        showDropdown()
		return true
	}

	override func rightIconClicked() {
		self.becomeFirstResponder()
	}

	override func connectIBDesignables() {
		setupRightIcon()
		super.connectIBDesignables()
	}

	convenience init(
		placeholder: String,
		input: String? = nil,
		items: [[String]],
		pickerSelection: UIViewPickerSelectedOption? = nil,
		pickerConfiguration: ((DMPopUpPicker) -> Void)? = nil,
		pickerSelectionHandler: ((DMPopUpPicker.SelectedItemsType) -> Void)? = nil,
		selectionMapper: (([String]) -> String)? = nil,
		abandonedPickerOptionsRow: [String]? = nil
	) {
		self.init(placeholder: placeholder, input: input)
		self.setupDropdownPicker(
			items: items,
			pickerSelection: pickerSelection,
			pickerConfiguration: pickerConfiguration,
			pickerSelectionHandler: pickerSelectionHandler,
			selectionMapper: selectionMapper,
			abandonedPickerOptionsRow: abandonedPickerOptionsRow
		)
	}

	private static var defaultSelectionMapper: ([String]) -> String {
		return { $0.joined(separator: " ") }
	}

	// MARK: - Methods
	func setupDropdownPicker(
		items: [[String]],
		pickerSelection: UIViewPickerSelectedOption? = nil,
		pickerConfiguration: ((DMPopUpPicker) -> Void)? = nil,
		pickerSelectionHandler: ((DMPopUpPicker.SelectedItemsType) -> Void)? = nil,
		selectionMapper: (([String]) -> String)? = nil,
		abandonedPickerOptionsRow: [String]? = nil
	) {
		self.picker = makePicker()
		self.picker.items = items
		pickerConfiguration?(self.picker)
		self.picker.selectedItemsHandler = { [weak self] newItems in
			guard let safeSelf = self else { return }
			safeSelf.input = (selectionMapper ?? Self.defaultSelectionMapper)(newItems.map { $0.string })
			safeSelf.updateErrorDisplaying()
			pickerSelectionHandler?(newItems)
		}
		self.picker.selectionButtonDidTap = { [weak self] in
			guard let safeSelf = self else { return }
			if safeSelf.shouldMoveNextAfterSelectAction {
				safeSelf.findNextResponder()?.becomeFirstResponder()
			}
		}
		self.picker.abandonedPickerOptionsRow = abandonedPickerOptionsRow

		if let pickerSelection = pickerSelection {
			selectRow(row: pickerSelection.row, inComponent: pickerSelection.component, animated: false)
		}
	}

	func selectRow(row: Int, inComponent: Int, animated: Bool) {
		picker.selectOption(selectedOption: .init(row: row, component: inComponent), animated: animated)
	}

	func showDropdown() {
		DispatchQueue.main.async { [weak self] in
			guard let safeSelf = self else { return }

			guard !safeSelf.picker.isBeingPresented else { return }

            guard let dropdownContext = safeSelf.parentContainerViewController else {
				print("Trying to present a dropdown while dropdownContext is nil.")
				return
			}

			dropdownContext.view.endEditing(true)
			dropdownContext.present(safeSelf.picker, animated: true)
		}
	}

	@discardableResult
	func selectOptions(_ options: DMPopUpPicker.SelectedItemsType) -> Bool {
		let foundItems = options.reduce(into: [String]()) { partialResult, pickerViewSelection in
			if let foundItem = picker.items
				.compactMap({ (stringArray: [String]) -> (String?) in
					stringArray.first(where: { $0 == pickerViewSelection.string })
				})
				.first(where: { $0 == pickerViewSelection.string }) {
				partialResult.append(foundItem)
			}
		}

		guard !foundItems.isEmpty else { return false }

		self.picker.selectOptionsInPicker(options)
		self.input = foundItems.joined(separator: " ")
		return true
	}

	private func setupRightIcon() {
//		rightIcon = AppImage.arrow_down()
	}

	private func makePicker() -> DMPopUpPicker {
        let popUpPicker = R.storyboard.dmPopUpPicker().instantiateController() as DMPopUpPicker
		popUpPicker.modalPresentationStyle = .overCurrentContext
		popUpPicker.modalTransitionStyle = .crossDissolve
		return popUpPicker
	}
}
