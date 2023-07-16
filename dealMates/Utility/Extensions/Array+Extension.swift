//
//  Array+Extension.swift
//  dealMates
//
//  Created by Stanislav on 12.06.2023.
//

import Foundation

extension Array {
    func safelyRetrieve(elementAt index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        return self[index]
    }
}
