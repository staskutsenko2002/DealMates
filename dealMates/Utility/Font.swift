//
//  Font.swift
//  dealMates
//
//  Created by Stanislav on 06.05.2023.
//

import UIKit

extension UIFont {
    @propertyWrapper
    struct HandoSoft {
        enum Weight {
            case bold
            case regular
        }

        let size: CGFloat
        let weight: Weight

        var wrappedValue: UIFont {
            switch weight {
            case .bold:
                return provideFont(with: "HandoSoftTrial-Bold")
            case .regular:
                return provideFont(with: "HandoSoftTrial-Regular")
            }
        }

        private func provideFont(with name: String) -> UIFont {
            UIFont(name: name, size: size)!
        }
    }
    
    @propertyWrapper
    struct Nunito {
        enum Weight {
            case bold
            case regular
            case light
            case medium
        }

        let size: CGFloat
        let weight: Weight

        var wrappedValue: UIFont {
            switch weight {
            case .bold:
                return provideFont(with: "Nunito-Bold")
            case .regular:
                return provideFont(with: "Nunito-Regular")
            case .light:
                return provideFont(with: "Nunito-Light")
            case .medium:
                return provideFont(with: "Nunito-Medium")
            }
        }

        private func provideFont(with name: String) -> UIFont {
            UIFont(name: name, size: size)!
        }
    }
    
    static func nunito(size: CGFloat, weight: Nunito.Weight) -> UIFont {
        Nunito(size: size, weight: weight).wrappedValue
    }

    static func handoSoft(size: CGFloat, weight: HandoSoft.Weight) -> UIFont {
        HandoSoft(size: size, weight: weight).wrappedValue
    }
}
