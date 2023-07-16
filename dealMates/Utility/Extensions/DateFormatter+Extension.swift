//
//  DateFormatter+Extension.swift
//  dealMates
//
//  Created by Stanislav on 11.06.2023.
//

import Foundation

extension DateFormatter {
    
    static var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.format = .mm_dd_yyyy_hyphen
        return formatter
    }()

    var format: Format? {
        set { self.dateFormat = newValue?.rawValue }
        get { Format(rawValue: self.dateFormat) }
    }

    enum Format: String {
        /// 12.03
        case dd_mm = "dd.MM"
        /// May 3, 2023
        case mmm_dd_yyyy = "MMM dd, yyyy"
        /// 12/31/1992
        case mm_dd_yyyy_slash = "MM/dd/yyyy"
        /// 12-31-1992
        case mm_dd_yyyy_hyphen = "MM-dd-yyyy"
                
        /// 10 June 2023
        case dd_mmmm_yyyy = "dd MMMM yyyy"

        /// 03/17/2023, 12:46 PM
        case mm_dd_yyyy_hh_mm_a = "MM/dd/YYYY, hh:mm a"

        /// Feb 16, 2023 at 10:07 AM
        case mmm_dd_yyyy_at_hh_mm_a = "MMM dd,YYYY 'at' hh:mm a"

        case yyyy_mm_dd_t_hh_mm_ss_sssz = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    }
}
