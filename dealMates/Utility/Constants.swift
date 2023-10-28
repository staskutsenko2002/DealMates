//
//  Constants.swift
//  dealMates
//
//  Created by Stanislav on 07.06.2023.
//

import Foundation

typealias Margins = Constants.Margins
typealias Sizes = Constants.Sizes

enum Constants {
    /// Number of items in one pagination. 20
    static let paginationSize = 20
    
    enum Text {
        /// Max number of symbols for text view. 500
        static let textViewMaxNumberOfSymbols = 500
    }
}

extension Constants {
    enum Margins {
        /// 4
        static let xxSmall: CGFloat = 4
        /// 6
        static let xSmall: CGFloat = 6
        /// 8
        static let small: CGFloat = 8
        /// 10
        static let medium: CGFloat = 10
        /// 12
        static let xMedium: CGFloat = 12
        /// 16
        static let large: CGFloat = 16
        /// 20
        static let xLarge: CGFloat = 20
        
    }
}

extension Constants {
    enum Sizes {
        /// 200
        static let big: CGFloat = 200
    }
}
