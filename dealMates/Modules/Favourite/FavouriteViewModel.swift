//
//  FavouriteViewModel.swift
//  dealMates
//
//  Created by Stanislav on 07.06.2023.
//

import Foundation

final class FavouriteViewModel {
    
    let title: String
    
    var isExecutor: Bool {
        networkService.isExecutor ?? false
    }
    
    private let networkService: NetworkServiceUserInfo
    
    init(networkService: NetworkServiceUserInfo) {
        self.networkService = networkService
        self.title = AppText.favourites()
    }
}
