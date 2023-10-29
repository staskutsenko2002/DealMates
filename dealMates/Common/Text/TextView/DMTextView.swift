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

final class DMTextView: UIView, Validatable {
	// MARK: - UI
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
        textView.layer.cornerRadius = 10
        textView.font = .handoSoft(size: 18, weight: .bold)
		return textView
	}()

	private lazy var errorMessageLabel: UILabel = {
		let label = UILabel()
		label.font = .handoSoft(size: 18, weight: .bold)
		return label
	}()

	// MARK: - NSLayoutConstraints
	private lazy var placeholderToPlaceInTextView = NSLayoutConstraint(item: placeholderLabel, attribute: .top, relatedBy: .equal, toItem: textView, attribute: .top, multiplier: 1, constant: 14)

	private lazy var placeholderBottomToTextFieldTop: NSLayoutConstraint = placeholderLabel.bottomAnchor.constraint(equalTo: textView.topAnchor, constant: -Margins.xSmall)
		
	private lazy var placeholderLeadingConstraint: NSLayoutConstraint = placeholderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Margins.large)

	// MARK: - Exposed properties
	var validationRules = [ValidationRule]()
    var shouldMoveToNextResponder: Bool = true

	var isValid: Bool {
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
    
    var inputNullable: String? {
        return self.input.isEmpty ? nil : self.input
    }

	var autocapitalizationType: UITextAutocapitalizationType {
		get {
			return textView.autocapitalizationType
		}
		set {
			textView.autocapitalizationType = newValue
		}
	}

	var returnKeyType: UIReturnKeyType {
		get {
			return textView.returnKeyType
		}
		set {
			textView.returnKeyType = newValue
		}
	}

	var textContentType: UITextContentType {
		get {
			return textView.textContentType
		}
		set {
			textView.textContentType = newValue
		}
	}

	var keyboardType: UIKeyboardType {
		get {
			return textView.keyboardType
		}
		set {
			textView.keyboardType = newValue
		}
	}
    
    var textViewBackgroundColor: UIColor? {
        get {
            return textView.backgroundColor
        }
        
        set {
            textView.backgroundColor = newValue
        }
    }

    var errorMessage: String? {
        get {
            return errorMessageLabel.text
        }
        
        set {
            errorMessageLabel.text = newValue
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

    var textContainerInset: UIEdgeInsets {
        get {
            return textView.textContainerInset
        }
        
        set {
            textView.textContainerInset = newValue
            placeholderLeadingConstraint.isActive = false
            placeholderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: newValue.left).isActive = true
        }
    }

    var placeholder: String? {
        set {
            placeholderLabel.text = newValue
        }
        
        get {
            return placeholderLabel.text
        }
    }
    
    // MARK: - Overrides
    override var isUserInteractionEnabled: Bool {
        get {
            return super.isUserInteractionEnabled
        }
        
        set {
            super.isUserInteractionEnabled = newValue
            self.textView.textColor = isUserInteractionEnabled ? AppColor.black() : AppColor.any_132_134_137()
        }
    }
    
    override var tag: Int {
        get {
            return textView.tag
        }
        set {
            textView.tag = newValue
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let height = Margins.large + Sizes.bigPlus + Margins.xSmall + errorMessageLabel.intrinsicContentSize.height
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }
    
    // MARK: - Private properties
    private var isSecureTextEntry: Bool {
        get {
            return textView.isSecureTextEntry
        }
        set {
            textView.isSecureTextEntry = newValue
        }
    }

    private var isPlaceholderLocked: Bool = false

    // MARK: - Callbacks
	var didChangeCallback: ((String) -> Void)?
	var onFinishedEditingCallback: ((String) -> Void)?

	// MARK: - Init
	override init(frame: CGRect = .zero) {
		super.init(frame: frame)
        setup()
	}

	convenience init(placeholder: String) {
		self.init(frame: .zero)
		self.placeholderLabel.text = placeholder
	}

	required init?(coder: NSCoder) {
		fatalError("Not implemented")
	}
    
    // MARK: - Override methods
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        return textView.becomeFirstResponder()
    }
    
    // MARK: - Exposed methods
    func addValidationRule(_ rule: StringValidationRules) {
        self.validationRules.addRule(rule)
    }

    func addValidationRules(_ rules: [StringValidationRules]) {
        rules.forEach { rule in
            self.validationRules.addRule(rule)
        }
    }

   func finishEditing() {
        textView.endEditing(true)
    }

	func updateErrorDisplaying(forceValid: Bool? = nil) {
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
}

// MARK: - Setup methods
private extension DMTextView {
    func setup() {
        setupLayout()
        setupUI()
    }
    
    func setupLayout() {
        addSubview(contentView)
        contentView.pinToSuperview()
        
        contentView.addSubview(textView)
        contentView.addSubview(placeholderLabel)
        contentView.addSubview(errorMessageLabel)
        
        contentView.add(views: [textView, placeholderLabel, errorMessageLabel], constraints: [
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: +15),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            textView.heightAnchor.constraint(equalToConstant: Sizes.bigPlus),

            placeholderToPlaceInTextView,
            placeholderLeadingConstraint,
            placeholderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Margins.large),

            errorMessageLabel.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: Margins.xSmall),
            errorMessageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Margins.large),
            errorMessageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Margins.large)
        ])
    }
    
    func setupUI() {
        textView.delegate = self
        addShadowAround()
    }
}

// MARK: - Selectors
@objc private extension DMTextView {
    func textViewDidChanged() {
        didChangeCallback?(input)
    }
    
    func moveToNextResponder() {
        guard shouldMoveToNextResponder else { return }

        if let next = findNextResponder() {
            next.becomeFirstResponder()
        }
    }
}

// MARK: - UITextViewDelegate
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
        return newText.count <= Constants.Text.textViewMaxNumberOfSymbols
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


// MARK: - TextView Placeholder
private extension DMTextView {
	// MARK: Floating placeholder
	func floatPlaceholder() {
		guard isPlaceholderLocked == false else {
			return
		}
		placeholderLabel.font = .handoSoft(size: 12, weight: .bold)
		placeholderToPlaceInTextView.isActive = false
		placeholderBottomToTextFieldTop.isActive = true
		placeholderLabel.numberOfLines = 1
	}

	func unfloatPlaceholder() {
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

	func animatePlaceholder(transform: CGAffineTransform = CGAffineTransform(scaleX: 1, y: 1)) {
		UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
			self.placeholderLabel.transform = transform
			self.layoutIfNeeded()
		}, completion: nil)
	}
}
