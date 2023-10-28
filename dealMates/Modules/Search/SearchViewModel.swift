//
//  SearchViewModel.swift
//  dealMates
//
//  Created by Stanislav on 08.10.2023.
//

import Foundation

final class SearchViewModel {
    // MARK: - Exposed properties
    private(set) var query: String
    private let filterAction: VoidCallback
    
    // MARK: - Init
    init(query: String, filterAction: @escaping VoidCallback) {
        self.query = query
        self.filterAction = filterAction
    }
    
    // MARK: - Exposed methods
    func pressFilter() {
        filterAction()
    }
}
