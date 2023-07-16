//
//  DMTextView.swift
//  Tread Athletics
//
//  Created by Konstantin Bezzemelnyi on 31.08.2022.
//

import UIKit

protocol Validatable {
    var isValid: Bool { get }
}

class DMTextView: UIView, Validatable {
	// MARK: - Constants
	enum Constants {
		static let prefferedTextFieldHeight = CGFloat(200)
		static let textViewBorderWidth = CGFloat(1)
		static let textViewBorderRadius = CGFloat(8)
		static let textViewHorizontalPadding = CGFloat(15)
		static let maximumNumberOfSymbols = 500

		enum Layout {
			static let topMarginFromTextFieldToSuperiew = CGFloat(15)
			static let errorMessageLabelTopMargin = CGFloat(5)
		}
	}

	// MARK: - Subviews
	private lazy var contentView: UIView = {
		let view = UIView()
		view.backgroundColor = .clear
		return view
	}()

	private lazy var placeholderLabel: UILabel = {
		let label = UILabel()
        label.textColor = AppColor.black()
		label.numberOfLines = 0
        label.font = .handoSoft(size: 18, weight: .bold)
		return label
	}()

	private lazy var textView: CustomTextView = {
		let textView = CustomTextView()
		textView.textColor = AppColor.black()
		textView.tintColor = AppColor.black()
        textView.backgroundColor = AppColor.white()
        textView.layer.borderWidth = 2
        textView.layer.borderColor = AppColor.black()?.cgColor
        textView.font = .handoSoft(size: 18, weight: .bold)
		return textView
	}()

	private lazy var errorMessageLabel: UILabel = {
		let label = UILabel()
		label.font = .handoSoft(size: 18, weight: .bold)
		return label
	}()

	// MARK: - NSLayoutConstraints
	private lazy var placeholderToPlaceInTextView = NSLayoutConstraint(
		item: placeholderLabel,
		attribute: .top,
		relatedBy: .equal,
		toItem: textView,
		attribute: .top,
		multiplier: 1,
		constant: 14
	)

	private lazy var placeholderBottomToTextFieldTop: NSLayoutConstraint = {
		let constraint = placeholderLabel.bottomAnchor.constraint(equalTo: textView.topAnchor, constant: -Constants.Layout.errorMessageLabelTopMargin)
		return constraint
	}()

	private lazy var placeholderLeadingConstraint: NSLayoutConstraint =
		placeholderLabel.leadingAnchor.constraint(
			equalTo: contentView.leadingAnchor,
			constant: Constants.textViewHorizontalPadding)

	private lazy var setupConstraints: [NSLayoutConstraint] = [

		textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
		textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
		textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: +15),
		textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

		textView.heightAnchor.constraint(equalToConstant: Constants.prefferedTextFieldHeight),

		placeholderToPlaceInTextView,
		placeholderLeadingConstraint,
		placeholderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.textViewHorizontalPadding),

		errorMessageLabel.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: Constants.Layout.errorMessageLabelTopMargin),
		errorMessageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.textViewHorizontalPadding),
		errorMessageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.textViewHorizontalPadding)
	]

	// MARK: - Properties
	// MARK: Public properties
	public var validationRules = [ValidationRule]()

	/// Rules which are used to check the correctness of user input
	public var isValid: Bool {
		var isAllRulesValid = true
		validationRules.forEach({ (isValidForRule) in
			let validationRule = isValidForRule(input)
			if !validationRule.isValid {
				isAllRulesValid = false
				errorMessage = validationRule.errorMessage
                errorMessageLabel.textColor = AppColor.red()
                textView.layer.borderColor = AppColor.red()?.cgColor
				placeholderLabel.textColor = AppColor.red()
			}
		})
		return isAllRulesValid
	}

	public var autocapitalizationType: UITextAutocapitalizationType {
		get {
			return textView.autocapitalizationType
		}
		set {
			textView.autocapitalizationType = newValue
		}
	}

	public var returnKeyType: UIReturnKeyType {
		get {
			return textView.returnKeyType
		}
		set {
			textView.returnKeyType = newValue
		}
	}

	public var textContentType: UITextContentType {
		get {
			return textView.textContentType
		}
		set {
			textView.textContentType = newValue
		}
	}

	public override var tag: Int {
		get {
			return textView.tag
		}
		set {
			textView.tag = newValue
		}
	}

	public var keyboardType: UIKeyboardType {
		get {
			return textView.keyboardType
		}
		set {
			textView.keyboardType = newValue
		}
	}

	@objc public dynamic var input: String {
		get {
			return textView.text ?? ""
		}
		set {
			newValue.isEmpty ? unfloatPlaceholder() : floatPlaceholder()
			textView.text = newValue
			didChangeCallback?(newValue)
		}
	}

	/// Returns nil if input is 0 symbols or input if more
	public var inputNullable: String? {
		return self.input.isEmpty ? nil : self.input
	}

	public var didChangeCallback: ((String) -> Void)?

	public var onFinishedEditingCallback: ((String) -> Void)?

	public var shouldMoveToNextResponder: Bool = true

	public var textContainerInset: UIEdgeInsets {
		get { textView.textContainerInset }
		set {
			textView.textContainerInset = newValue
			placeholderLeadingConstraint.isActive = false
			placeholderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: newValue.left).isActive = true
		}
	}

	var textViewBackgroundColor: UIColor? {
		get { textView.backgroundColor }
		set { textView.backgroundColor = newValue }
	}

	var errorMessage: String? {
		set { errorMessageLabel.text = newValue }
		get { return errorMessageLabel.text }
	}

	private var isSecureTextEntry: Bool {
		get {
			return textView.isSecureTextEntry
		}
		set {
			textView.isSecureTextEntry = newValue
		}
	}

	/// If set to true, placholder will be set on the top of text field and will not perform any animations
	private var isPlaceholderLocked: Bool = false

	var placeholder: String? {
		didSet {
			placeholderLabel.text = placeholder
		}
	}

	// MARK: - Overrides
	override var isUserInteractionEnabled: Bool {
		get { super.isUserInteractionEnabled }
		set {
			super.isUserInteractionEnabled = newValue
			self.textView.textColor = isUserInteractionEnabled ? AppColor.black() : AppColor.any_132_134_137()
		}
	}

	@discardableResult
	override func becomeFirstResponder() -> Bool {
		return textView.becomeFirstResponder()
	}

	override var intrinsicContentSize: CGSize {
		let calculatedHeight =
			Constants.Layout.topMarginFromTextFieldToSuperiew
				+ Constants.prefferedTextFieldHeight
				+ Constants.Layout.errorMessageLabelTopMargin
				+ errorMessageLabel.intrinsicContentSize.height
		return CGSize(width: UIView.noIntrinsicMetric, height: calculatedHeight)
	}

	// MARK: - Methods
	// MARK: Public methods

	public func addValidationRule(_ rule: StringValidationRules) {
		self.validationRules.addRule(rule)
	}

	public func addValidationRules(_ rules: [StringValidationRules]) {
		rules.forEach { rule in
			self.validationRules.addRule(rule)
		}
	}

	public func finishEditing() {
		textView.endEditing(true)
	}

	// MARK: - Initializers
	override init(frame: CGRect = .zero) {
		super.init(frame: frame)

		// Prepare for AL
		self.prepareForAutoLayout()
		contentView.prepareForAutoLayout()
		textView.prepareForAutoLayout()
		placeholderLabel.prepareForAutoLayout()
		errorMessageLabel.prepareForAutoLayout()

		self.addSubview(contentView)
		contentView.pinToSuperview()

		contentView.addSubview(textView)
		contentView.addSubview(placeholderLabel)
		contentView.addSubview(errorMessageLabel)

		setupConstraints.forEach { $0.isActive = true }

		textView.delegate = self
	}

	convenience init(placeholder: String) {
		self.init(frame: .zero)
		self.placeholderLabel.text = placeholder
	}

	required init?(coder: NSCoder) {
		fatalError("Not implemented")
	}

	// MARK: UI methods
	/// Moves to the next responder if exists
	@objc func moveToNextResponder() {
		guard shouldMoveToNextResponder else { return }

		if let next = findNextResponder() {
			next.becomeFirstResponder()
		}
	}

	// MARK: ErrorMessageLabel UI mehtods
	public func updateErrorDisplaying(forceValid: Bool? = nil) {
		if forceValid ?? self.isValid {
			errorMessageLabel.text = " "
            textView.layer.borderColor = AppColor.black()?.cgColor
			placeholderLabel.textColor = AppColor.black()

		} else {
            errorMessageLabel.textColor = AppColor.red()
            textView.layer.borderColor = AppColor.red()?.cgColor
			placeholderLabel.textColor = AppColor.red()
		}
	}

	// MARK: TextView methods
	@objc func textViewDidChanged() {
		didChangeCallback?(input)
	}
}

// MARK: - Custom delegate class
extension DMTextView: UITextViewDelegate {
	func textViewDidChange(_ textView: UITextView) {
		textViewDidChanged()
		input = textView.text
	}

	func textViewDidBeginEditing(_ textView: UITextView) {
		floatPlaceholder()
		animatePlaceholder()
	}

	func textViewDidEndEditing(_ textView: UITextView) {
		onFinishedEditing()
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		onFinishedEditing()
		moveToNextResponder()
		textField.resignFirstResponder()
		return false
	}

	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
		return newText.count <= Constants.maximumNumberOfSymbols
	}

	/// Finds next UIResponder using tags strategy (searches +1 as a view's tag)
	@objc func findNextResponder() -> UIResponder? {
		let nextTag = self.tag + 1
		if let nextResponder = self.superview?.viewWithTag(nextTag) as? UIResponder {
			return nextResponder
		}
		// Check one more superview, if text field is placed in another view (f.i., UIStackView)
		if let nextResponder = self.superview?.superview?.viewWithTag(nextTag) as? UIResponder {
			return nextResponder
		}
		return nil
	}

	private func onFinishedEditing() {
		updateErrorDisplaying()
		if input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
			unfloatPlaceholder()
			animatePlaceholder()
		}
		invalidateIntrinsicContentSize()
		onFinishedEditingCallback?(input)
	}
}

// MARK: - Custom textField class
final class CustomTextView: UITextView {
	override func becomeFirstResponder() -> Bool {
		if let safeSuperview = superview,
		   let safeSuperview2 = safeSuperview.superview,
		   let safeSuperview3 = safeSuperview2.superview,
		   safeSuperview3.canBecomeFirstResponder {
			safeSuperview3.becomeFirstResponder()
			return false
		}
		return super.becomeFirstResponder()
	}

	override init(frame: CGRect, textContainer: NSTextContainer?) {
		super.init(frame: frame, textContainer: textContainer)
		commonInit()
	}

	required init?(coder: NSCoder) {
		fatalError("Not implemented")
	}

	private func commonInit() {
		self.textContainerInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        self.font = .handoSoft(size: 16, weight: .bold)
	}

	public var textSelectionEnabled: Bool = true

	private let padding = CGFloat(12)

	override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
		if textSelectionEnabled {
			return super.selectionRects(for: range)
		} else {
			return []
		}
	}

	override func caretRect(for position: UITextPosition) -> CGRect {
		if textSelectionEnabled {
			return super.caretRect(for: position)
		} else {
			return .null
		}
	}
}

// MARK: - TextView Placeholder
extension DMTextView {
	// MARK: Floating placeholder
	private func floatPlaceholder() {
		guard isPlaceholderLocked == false else {
			return
		}
		placeholderLabel.font = .handoSoft(size: 12, weight: .bold)
		placeholderToPlaceInTextView.isActive = false
		placeholderBottomToTextFieldTop.isActive = true
		placeholderLabel.numberOfLines = 1
	}

	private func unfloatPlaceholder() {
		guard isPlaceholderLocked == false else {
			return
		}
		placeholderBottomToTextFieldTop.isActive = false
		placeholderToPlaceInTextView.isActive = true
		placeholderLabel.font = .handoSoft(size: 18, weight: .bold)
		placeholderLabel.numberOfLines = 0
	}

	func lockPlaceholderOnTop() {
		placeholderLabel.font = .handoSoft(size: 12, weight: .bold)
		placeholderToPlaceInTextView.isActive = false
		placeholderBottomToTextFieldTop.isActive = true
		isPlaceholderLocked = true
	}

	private func animatePlaceholder(transform: CGAffineTransform = CGAffineTransform(scaleX: 1, y: 1)) {
		UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
			self.placeholderLabel.transform = transform
			self.layoutIfNeeded()
		}, completion: nil)
	}
}
