//
//  StringValidationRules.swift
//  Tread Athletics
//
//  Created by Konstantin Bezzemelnyi on 29.04.2022.
//

import Foundation

typealias ValidationRule = (_ input: String) -> (isValid: Bool, errorMessage: String?)

extension Array where Element == ValidationRule {
	mutating func addRule(_ rule: StringValidationRules) {
		self.append(contentsOf: rule.value)
	}
}

enum StringValidationRules {
	case custom(ValidationRule)
	case email
	case password
    /// Cheecks if string is equal to another string. Ex: password and repeat password
    case equal(String)
	/// Checks if string's length is more or equal
	case minimumLength(length: Int, validIfEmpty: Bool = false)
	/// Checks if string's length is less or equal
	case maximumLength(length: Int, validIfEmpty: Bool = false)
	case exactLength(length: Int)
	case mandatory(customMessage: String? = "Mandatory field")
	/// Checks if string contains letters only in case it is not empty.
	/// - Parameter AZOnly: When set to false, can be used also letters from other languages, like ø,å....
	case letterOnly(AZOnly: Bool)
	/// Checks if string contains number only in case it is not empty.
	case numberOnly
	/// String with length from 2 to 50 symbols and letters only.
	case name
	case phoneNumber
	/// If input could not be casted to range type, will return true
	case matchesRange(_ range: ClosedRange<Int>)
	/// If input could not be casted to range type, will return true
	case matchesDoublesRange(_ Range: ClosedRange<Double>)

	var value: [ValidationRule] {
		switch self {
		case .custom(let rules):
			return [rules]
        case .equal(let value):
            var passwordValidationRules = [ValidationRule]()
            passwordValidationRules.append(contentsOf: [ { (password) in
                let password = password.trimmingCharacters(in: .whitespaces)
                guard !password.isEmpty else { return (true, nil) }

                let isMatch = password == value
                if isMatch {
                    return (isValid: true, nil)
                } else {
                    return (isValid: false, "Passwords don't match")
                }
            }])
            return passwordValidationRules
            
		case .email:
			var emailValidationRules = [ValidationRule]()
			emailValidationRules.append(contentsOf: [ { (email) in
				let email = email.trimmingCharacters(in: .whitespaces)
				guard !email.isEmpty else { return (true, nil) }

				let isMatchWithEmailFormatting = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]{2,50}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}").evaluate(with: email)
				if isMatchWithEmailFormatting {
					return (isValid: true, nil)
				} else {
					return (isValid: false, "Please, check you email")
				}
			}
			])
			return emailValidationRules
		case .password:
			var passwordValidations: [ValidationRule] = [ { (password) in
				return (
					!NSPredicate(format: "SELF MATCHES %@", ".*[0-9]+.*").evaluate(with: password)
						? (isValid: false, "Password must contain at least 1 digit")
						: (isValid: true, nil)
				)
			}, { (password) in
				return (
					!NSPredicate(format: "SELF MATCHES %@", ".*[a-zA-Z]+.*").evaluate(with: password)
						? (isValid: false, "Password must contain at least 1 letter")
						: (isValid: true, nil)
				)
			}
			]
			passwordValidations.append(contentsOf: StringValidationRules.mandatory().value)
			passwordValidations.append(contentsOf: StringValidationRules.minimumLength(length: 6).value)
			passwordValidations.append(contentsOf: StringValidationRules.maximumLength(length: 20).value)
			return passwordValidations
		case let .minimumLength(length, isValidIfEmpty):
			return [ { (input) in
				if input.isEmpty && isValidIfEmpty {
					return (isValid: true, nil)
				}

				if input.count < length {
					return (isValid: false, "Field should have least \(length) characters.")
				} else {
					return (isValid: true, nil)
				}
			}
			]
		case let .maximumLength(length, isValidIfEmpty):
			return [ { (input) in
				if input.isEmpty && isValidIfEmpty {
					return (isValid: true, nil)
				}

				if input.count > length {
					return (isValid: false, "Field should have no more than \(length) characters.")
				} else {
					return (isValid: true, nil)
				}
			}
			]
		case .exactLength(length: let length):
			return [ { (input) in
				return (
					input.count != length
						? (isValid: false, "Field should have \(length) characters.")
						: (isValid: true, nil))
			}
			]
		case .mandatory(let message):
			return [ { (input) in
				return (
					input
						.trimmingCharacters(in: .whitespacesAndNewlines)
						.isEmpty
						? (isValid: false, message)
						: (isValid: true, nil))
			}
			]
		case .letterOnly(AZOnly: let AZOnly):
			return [ { (input) in
				return !input.isEmpty && !NSPredicate(
					format: "SELF MATCHES %@",
					AZOnly
						? "[A-Za-z]{0,}"
						: "^[^\\W\\d_]+(?:-[^\\W\\d_]+)*\\.?${0,}"
				).evaluate(with: input)
					? (isValid: false, "Please, use letters only")
					: (isValid: true, nil)
			}
			]
		case .numberOnly:
			return [ { (input) in
				return !input.isEmpty && !NSPredicate(
					format: "SELF MATCHES %@",
					"[0-9]{0,}"
				).evaluate(with: input)
					? (isValid: false, "Please, use numbers only")
					: (isValid: true, nil)
			}
			]
		case .name:
			var rules: [ValidationRule] = []
			rules.append(contentsOf: StringValidationRules.minimumLength(length: 2, validIfEmpty: true).value)
			rules.append(contentsOf: StringValidationRules.maximumLength(length: 50, validIfEmpty: true).value)
			return rules
		case .phoneNumber:
			return [ { (input) in
				guard !input.isEmpty else { return (true, nil) }
				guard NSPredicate(format: "SELF MATCHES %@", "^\\+\\d{9,18}$").evaluate(with: input) else {
					return (isValid: false, "Please, check if your phone number is correct")
				}
				return (true, nil)
			}
			]
		case .matchesRange(let range):
			return [ { (input) in
				guard let int = Int(input) else { return (true, nil) }

				if range.contains(int) {
					return (isValid: true, nil)
				} else {
					return (isValid: false, "Value should be from \(range.lowerBound) to \(range.upperBound)")
				}
			}]

		case .matchesDoublesRange(let range):
			return [ { (input) in
				guard let double = Double(input) else { return (true, nil) }

				if range.contains(double) {
					return (isValid: true, nil)
				} else {
					return (isValid: false, "Value should be from \(range.lowerBound) to \(range.upperBound)")
				}
			}]
		}
	}
}
