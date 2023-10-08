//
//  HomeViewModel.swift
//  dealMates
//
//  Created by Stanislav on 04.06.2023.
//

import Foundation

final class HomeViewModel {
    
    let title: String
    var isExecutor: Bool {
        networkService.isExecutor ?? false
    }
    
    private let networkService: NetworkServiceUserInfo
    
    // MARK: - Callbacks
    private let didPressSearchCallback: StringCallback
    
    init(networkService: NetworkServiceUserInfo, didPressSearchCallback: @escaping StringCallback) {
        self.networkService = networkService
        self.didPressSearchCallback = didPressSearchCallback
        self.title = AppText.home()
    }
    
    func openSearch(query: String) {
        didPressSearchCallback(query)
    }
}
