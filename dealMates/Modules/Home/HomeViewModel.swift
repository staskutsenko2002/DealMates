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
    
    init(networkService: NetworkServiceUserInfo) {
        self.networkService = networkService
        self.title = AppText.home()
    }
}
