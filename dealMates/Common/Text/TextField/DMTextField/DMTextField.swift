//
//  DMTextField.swift
//  dealMates
//
//  Created by Stanislav Kutsenko on 01.04.2022.
//
import UIKit
import Combine

@IBDesignable
class DMTextField: UIView {
	// MARK: UI States
	private enum TextFieldState {
		case normal(isEmpty: Bool?)
		case error(errorMessage: String)
	}

	// MARK: - Constants
	enum Constants {
        static let placeholderDefaultColor: UIColor = AppColor.black() ?? .black
        static let errorColor: UIColor = .red
        static let rightLabelFont = UIFont.handoSoft(size: 18, weight: .regular)
		static let maximumNumberOfSymbols = 100
	}

	private static let niName = "DMTextField"
	private let textSize = CGFloat(18)
	private let floatingPlacheholderTextSize = CGFloat(12)
	private let prefferedTextFieldHeight = CGFloat(42)
	private let topMarginFromTextFieldToSuperiew = CGFloat(15)
	private let errorMessageLabelTopMargin = CGFloat(5)

	// MARK: - @IBOutlets
	@IBOutlet weak var contentView: UIView!
	@IBOutlet weak var placeholderLabel: UILabel!
	@IBOutlet weak var textField: DMCustomTextField!
	@IBOutlet weak var errorMessageLabel: UILabel!

	// MARK: - NSLayoutConstraints
	// swiftlint:disable force_unwrapping
	private lazy var placeholderCenterYToTextFieldCenterY = NSLayoutConstraint(item: placeholderLabel!, attribute: .centerY, relatedBy: .equal, toItem: textField, attribute: .centerY, multiplier: 1, constant: 0)
	private lazy var placeholderBottomToTextFieldTop = NSLayoutConstraint(item: placeholderLabel!, attribute: .bottom, relatedBy: .equal, toItem: textField, attribute: .top, multiplier: 1, constant: -2)
	// swiftlint:enable force_unwrapping
	private lazy var setupConstraints: [NSLayoutConstraint] = [
		placeholderCenterYToTextFieldCenterY,
		textField.trailingAnchor.constraint(equalTo: trailingAnchor),
		textField.leadingAnchor.constraint(equalTo: leadingAnchor),
		textField.heightAnchor.constraint(greaterThanOrEqualToConstant: prefferedTextFieldHeight),
		errorMessageLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: errorMessageLabelTopMargin)
	]

	var viewInput: String { input }

	public var autocapitalizationType: UITextAutocapitalizationType {
		get {
            textField.autocapitalizationType
        }
		set {
            textField.autocapitalizationType = newValue
        }
	}

	public var returnKeyType: UIReturnKeyType {
		get {
			return textField.returnKeyType
		}
		set {
			textField.returnKeyType = newValue
		}
	}

	public var textContentType: UITextContentType {
		get {
			return textField.textContentType
		}
		set {
			textField.textContentType = newValue
		}
	}

	public override var tag: Int {
		get {
			return textField.tag
		}
		set {
			textField.tag = newValue
		}
	}

	public var keyboardType: UIKeyboardType {
		get {
			return textField.keyboardType
		}
		set {
			textField.keyboardType = newValue
		}
	}

	public var rightView: UIView? {
		get {
			return textField.rightView
		}
		set {
			textField.rightView = newValue
		}
	}

	public var rightViewMode: UITextField.ViewMode {
		get {
			return textField.rightViewMode
		}
		set {
			textField.rightViewMode = newValue
		}
	}


	public var input: String {
		get {
			textField.text ?? ""
		}
		set {
			newValue.isEmpty ? unfloatPlaceholder() : floatPlaceholder()
			textField.text = newValue
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

	@Published private var state: TextFieldState = .normal(isEmpty: nil)

	var isFloatingPlaceholder: Bool {
		return placeholderBottomToTextFieldTop.isActive
	}

	// MARK: Private properties

	private var subscriptions = Set<AnyCancellable>()
	private lazy var rightIconImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.tintColor = AppColor.black()
		imageView.contentMode = .scaleAspectFit
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(rightIconClicked))
		imageView.isUserInteractionEnabled = true
		imageView.addGestureRecognizer(tapGesture)
		return imageView
	}()

	var errorMessage: String? {
		set {
			if errorMessage == nil {
				self.state = .normal(isEmpty: input.isEmpty)
			}
			errorMessageLabel.text = newValue
		}
		get {
			return errorMessageLabel.text
		}
	}

	private var isSecureTextEntry: Bool {
		get {
			return textField.isSecureTextEntry
		}
		set {
			textField.isSecureTextEntry = newValue
			rightIconImageView.image = UIImage(systemName: isSecureTextEntry ? "eye" : "eye.slash")
            rightIconImageView.tintColor = AppColor.black() ?? .black
		}
	}

	/// If set to true, placholder will be set on the top of text field and will not perform any animations
	private var isPlaceholderLocked: Bool = false

	// MARK: @IBInspectables
	@IBInspectable var placeholder: String? {
		didSet {
			if let placeholderLabel = placeholderLabel {
				placeholderLabel.text = placeholder
			}
		}
	}

	var placeholderColor: UIColor? {
		didSet { placeholderLabel.textColor = placeholderColor }
	}

	/// Placeholder that appears inside a text field if it is empty and floating placeholder is in it's floating position.
	/// Hides when user types.
	var innerPlaceholder: String? {
		didSet {
			updateInnerPlaceholder(placeholderText: innerPlaceholder ?? "", for: state)
		}
	}
    
    private var validationRules = [ValidationRule]()
    /// Rules which are used to check the correctness of user input
    public var isValid: Bool {
        var isAllRulesValid = true
        validationRules.forEach({ (isValidForRule) in
            let validationRule = isValidForRule(input)
            if !validationRule.isValid {
                isAllRulesValid = false
                errorMessage = validationRule.errorMessage
                errorMessageLabel.textColor = AppColor.red()
                textField.layer.borderColor = AppColor.red()?.cgColor
            }
        })
        state = isAllRulesValid
            ? .normal(isEmpty: input.isEmpty)
            : .error(errorMessage: errorMessage ?? "")
        return isAllRulesValid
    }

	@IBInspectable var rightIcon: UIImage? {
		didSet {
			if isPasswordField {
				rightIcon = nil
			}
			if superview != nil {
				textField.rightView = rightIconImageView
				rightIconImageView.image = rightIcon
				textField.rightViewMode = .always
				connectIBDesignables()
			}
		}
	}

	@IBInspectable var isPasswordField: Bool = false

	// MARK: - Overrides
	@discardableResult
	override func becomeFirstResponder() -> Bool {
		return textField.becomeFirstResponder()
	}

	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
	}

	override func awakeFromNib() {
		super.awakeFromNib()
		xibSetup()
	}

	override var intrinsicContentSize: CGSize {
		let calculatedHeight =
			topMarginFromTextFieldToSuperiew
				+ prefferedTextFieldHeight
				+ errorMessageLabelTopMargin
				+ errorMessageLabel.intrinsicContentSize.height
		return CGSize(width: UIView.noIntrinsicMetric, height: calculatedHeight)
	}

	override var isUserInteractionEnabled: Bool {
		get { super.isUserInteractionEnabled }
		set {
			super.isUserInteractionEnabled = newValue

		}
	}

	var textFieldBackgroundColor: UIColor? {
		get { textField.backgroundColor }
		set { textField.backgroundColor = newValue }
	}

	// MARK: - Methods
	// MARK: Public methods

	public func finishEditing() {
		textField.endEditing(true)
	}

	public func addRightViewLabel(text: String, rightViewMode: UITextField.ViewMode = .always) {
		let label = UILabel()
		label.font = Constants.rightLabelFont
		label.text = text
		self.rightView = label
		self.rightViewMode = rightViewMode
	}

	// MARK: - Initializers
	override init(frame: CGRect = .zero) {
		super.init(frame: frame)
		xibSetup()
	}

	init(frame: CGRect = .zero, beforeXibSetup: @escaping (DMTextField) -> Void) {
		super.init(frame: frame)
		beforeXibSetup(self)
		xibSetup()
	}

	convenience init(placeholder: String, input: String? = nil) {
		self.init { it in
			it.placeholder = placeholder
		}
		if let input = input {
			self.input = input
		}
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	// MARK: Xib and nib setups
	private func xibSetup() {
		guard let view = loadViewFromNib() else { return }
		view.translatesAutoresizingMaskIntoConstraints = false
		view.frame = self.bounds
		self.addSubview(view)
		setupConstraints.forEach { $0.isActive = true }
		connectIBDesignables()
		textField.delegate = self
        textField.layer.cornerRadius = 10
        textField.tintColor = .black
        textField.font = .handoSoft(size: 18, weight: .bold)
        textField.addShadowAround()
        textField.leftView = UIView(frame: .init(x: 0, y: 0, width: 15, height: 0))
        textField.leftViewMode = .always
		textField.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
	}

	private func loadViewFromNib() -> UIView? {
		let nib = UINib(nibName: DMTextField.niName, bundle: Bundle(for: type(of: self)))
		return nib.instantiate(withOwner: self, options: nil).first as? UIView
	}
    
    public func addValidationRule(_ rule: StringValidationRules, resetingPreviousRules: Bool = false) {
        if resetingPreviousRules {
            self.resetValidationRules(updatingErrorMessageVisibility: false)
        }
        self.validationRules.addRule(rule)
    }

    public func addValidationRules(_ rules: [StringValidationRules], resetingPreviousRules: Bool = false) {
        if resetingPreviousRules {
            self.resetValidationRules(updatingErrorMessageVisibility: false)
        }
        rules.forEach { rule in
            self.validationRules.addRule(rule)
        }
    }

    public func resetValidationRules(updatingErrorMessageVisibility: Bool) {
        self.validationRules.removeAll()
        if updatingErrorMessageVisibility {
            updateErrorDisplaying()
        }
    }

	func connectIBDesignables() {
		placeholderLabel.text = placeholder
		$state
			.receive(on: DispatchQueue.main)
			.sink { [weak self] state in
				guard let self = self else { return }
				self.updateInnerPlaceholder(placeholderText: self.innerPlaceholder ?? "", for: state, shouldHide: !self.isFloatingPlaceholder)
			}.store(in: &subscriptions)

		textField.attributedPlaceholder = NSAttributedString(
			string: innerPlaceholder ?? "",
			attributes: [.foregroundColor: AppColor.black()!]
		)
		if let rightIcon = rightIcon {
			textField.rightView = rightIconImageView
			rightIconImageView.image = rightIcon
			textField.rightViewMode = .always
		}
		if isPasswordField {
			textField.rightView = rightIconImageView
			textContentType = .password
			isSecureTextEntry = true
			textField.rightViewMode = .whileEditing
		}
	}

	// MARK: UI methods
	/// Moves to the next responder if exists
	@objc func moveToNextResponder() {
		guard shouldMoveToNextResponder else { return }

		if let next = findNextResponder() {
			next.becomeFirstResponder()
		}
	}

	// MARK: RightIcon methods
	@objc func rightIconClicked() {
        if isPasswordField {
            isSecureTextEntry.toggle()
        }
	}

	// MARK: ErrorMessageLabel UI mehtods
	public func updateErrorDisplaying() {
		if self.isValid {
			errorMessageLabel.text = " "
            textField.layer.borderColor = AppColor.black()?.cgColor

		} else {
			errorMessageLabel.textColor = AppColor.red()
            textField.layer.borderColor = AppColor.red()?.cgColor
		}
	}

	private func updateInnerPlaceholder(
		placeholderText text: String,
		for state: TextFieldState,
		shouldHide: Bool = false
	) {
		guard shouldHide == false else {
			textField.attributedPlaceholder = NSAttributedString(string: "")
			return
		}
		switch state {
		case .normal:
			textField.attributedPlaceholder = NSAttributedString(
				string: text,
				attributes: [.foregroundColor: Constants.placeholderDefaultColor]
			)
		case .error:
            break
//			textField.attributedPlaceholder = NSAttributedString(
//				string: text,
//				attributes: [.foregroundColor: AppColor.any_236_83_83()!]
//			)
		}
	}

	@objc func textFieldDidChanged() {
		didChangeCallback?(input)
	}
}

// MARK: - Custom delegate class
extension DMTextField: UITextFieldDelegate {
	func textFieldDidBeginEditing(_ textField: UITextField) {
		floatPlaceholder()
		animatePlaceholder()
	}

	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

		let currentString = (textField.text ?? "") as NSString
		let newString = currentString.replacingCharacters(in: range, with: string)

		return newString.count <= Constants.maximumNumberOfSymbols
	}

	func textFieldDidEndEditing(_ textField: UITextField) {
//		if let ceilingPrecision = ceilingPrecision {
//			if input.isNotEmpty {
//				input = input.preciceCeil(to: ceilingPrecision)
//			}
//		}
		onFinishedEditing()
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		onFinishedEditing()
		moveToNextResponder()
		textField.resignFirstResponder()
		return false
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
		if input.isEmpty {
			unfloatPlaceholder()
			animatePlaceholder()
		}
		if isPasswordField {
			isSecureTextEntry = true
		}
		invalidateIntrinsicContentSize()
		onFinishedEditingCallback?(input)
	}
}

// MARK: - Custom textField class
final class DMCustomTextField: UITextField {
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

	public var textSelectionEnabled: Bool = true
	private let horizontalPadding: CGFloat = 15
	private let sideViewToTextInset: CGFloat = 15
	private var leftHorizontalTextRectPadding: CGFloat {
		var leftHorizontalTextRectPadding: CGFloat = horizontalPadding
		if let leftView = leftView {
			leftHorizontalTextRectPadding += leftView.frame.size.width
			leftHorizontalTextRectPadding += 15
		}
		return leftHorizontalTextRectPadding
	}

	private var rightHorizontalTextRectPadding: CGFloat {
		var rightHorizontalTextRectPadding: CGFloat = horizontalPadding
		if let rightView = rightView {
			rightHorizontalTextRectPadding += rightView.frame.size.width
			rightHorizontalTextRectPadding += 15
		}
		return rightHorizontalTextRectPadding
	}

	private let prefferedSideViewHeight: CGFloat = 16
	private let sideViewToTextSpacing: CGFloat = 15

	override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: Margins.large, bottom: 0, right: Margins.large))
	}

	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		return textRect(forBounds: bounds)
	}

	override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
		return textRect(forBounds: bounds)
	}

	override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
		return CGRect(
			x: bounds.minX + horizontalPadding,
			y: bounds.maxY / 2 - prefferedSideViewHeight / 2,
			width: super.leftViewRect(forBounds: bounds).width,
			height: prefferedSideViewHeight
		)
	}

	override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
		return CGRect(
			x: bounds.maxX - horizontalPadding - super.rightViewRect(forBounds: bounds).width,
			y: bounds.maxY / 2 - prefferedSideViewHeight / 2,
			width: super.rightViewRect(forBounds: bounds).width,
			height: prefferedSideViewHeight
		)
	}

	override func buildMenu(with builder: UIMenuBuilder) {
		builder.remove(menu: .lookup)
		super.buildMenu(with: builder)
	}

	override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
		guard textSelectionEnabled else { return false }

        guard text != nil, text?.isEmpty == false else {
			return action == #selector(paste(_:))
		}

		return true
	}

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

// MARK: - TreadStyleTextFields UI Setup
extension DMTextField {
	// MARK: Floating placeholder
	private func floatPlaceholder() {
		guard isPlaceholderLocked == false else {
			return
		}
		placeholderLabel.font = placeholderLabel.font?.withSize(floatingPlacheholderTextSize)
		placeholderCenterYToTextFieldCenterY.isActive = false
		placeholderBottomToTextFieldTop.isActive = true
	}

	private func unfloatPlaceholder() {
		guard isPlaceholderLocked == false else {
			return
		}
		placeholderBottomToTextFieldTop.isActive = false
		placeholderCenterYToTextFieldCenterY.isActive = true
		placeholderLabel.font = placeholderLabel.font?.withSize(textSize)
	}

	func lockPlaceholderOnTop() {
		placeholderLabel.font = placeholderLabel.font?.withSize(floatingPlacheholderTextSize)
		placeholderCenterYToTextFieldCenterY.isActive = false
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
