//
//  RequestListViewModel.swift
//  dealMates
//
//  Created by Stanislav on 04.06.2023.
//

import Foundation
import Combine

final class RequestListViewModel {
    
    private(set) var cellModels = [RequestCellModel]()
    @Published var status: PageStatus = .idle
    
    private var page = 0
    private var isFavourite: Bool
    private var cancellables = Set<AnyCancellable>()
    private let networkService: NetworkServiceRequest & NetworkServiceUserInfo
    
    init(
        isFavourite: Bool,
        networkService: NetworkServiceRequest & NetworkServiceUserInfo
    ) {
        self.isFavourite = isFavourite
        self.networkService = networkService
    }
    
    func getRequests() {
        guard status != .loading, let userId = networkService.userId else { return }
        status = .loading
        
        networkService.getRequests(userId: userId, isFavourite: isFavourite, page: page, paginationSize: Constants.paginationSize)
            .sink(receiveCompletion: { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .finished:
                    self.status = self.cellModels.isEmpty ? .empty : .loaded
                    
                case .failure(let error):
                    guard let message = error.errorDescription else {
                        self.status = .idle
                        return
                    }
                    self.status = .error(message: message)
                }
            }, receiveValue: { [weak self] response in
                guard let self else { return }
                self.cellModels = response.result.map(self.map(request:))
            })
            .store(in: &cancellables)
    }
    
    private func map(request: Request) -> RequestCellModel {
        return .init(
            title: request.title,
            description: request.body,
            avatarURL: URL(string: request.client.photoUrl ?? ""),
            userName: request.client.firstName + " " + request.client.lastName,
            publishDate: "Date",
            location: "Location",
            price: "\(request.proposedPrice)",
            isLiked: isFavourite
        )
    }
}
