//
//  CreateViewModel.swift
//  dealMates
//
//  Created by Stanislav on 12.06.2023.
//

import Foundation
import Combine

final class CreateViewModel {
    enum Status: Equatable {
        case idle
        case created
        case error(String)
        case loading
    }
    
    let title: String
    let networkService: NetworkServiceCreation
    @Published var status: Status = .idle
    let onUpdateCategories = PassthroughSubject<Void, Never>()
    
    private let creationType: CreationType
    private(set) var categories = [Category]()
    private var cancellables = Set<AnyCancellable>()
    
    init(creationType: CreationType) {
        self.title = AppText.create()
        self.creationType = creationType
        self.networkService = NetworkService.shared
    }
    
    func getCategories() {
        networkService.getCategories()
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case .finished:
                    DispatchQueue.main.async {
                        self.onUpdateCategories.send()
                    }
                case .failure:
                    break
                }
            } receiveValue: { [weak self] response in
                self?.categories = response.result
            }.store(in: &cancellables)
    }
    
    func create(title: String, desc: String, category: String, price: String) {
        guard status != .loading else { return }
        status = .loading
        
        guard
            let categoryId = categories.first(where: { $0.name == category })?.id,
            let priceInt = Int(price)
        else { return }
        
        switch creationType {
        case .request:
            let priceFloat: Float = Float(integerLiteral: Int64(priceInt))
            let request = RequestCreation(title: title, body: desc, categoryId: categoryId, proposedPrice: priceFloat)
            createRequest(request: request)
            
        case .proposal:
            let priceFloat: Float = Float(integerLiteral: Int64(priceInt))
            let proposal = ProposalCreation(title: title, description: desc, categoryId: categoryId, minPrice: priceFloat, yearOfExperience: nil)
            createProposal(proposal: proposal)
        }
    }
    
    private func createProposal(proposal: ProposalCreation) {
        networkService.createProposal(proposal: proposal)
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    self.status = .error(error.errorDescription ?? "")
                }
            } receiveValue: { [weak self] reponse in
                guard let self else { return }
                self.status = .created
            }
            .store(in: &cancellables)
    }
    
    private func createRequest(request: RequestCreation) {
        networkService.createRequest(request: request)
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    self.status = .error(error.errorDescription ?? "")
                }
            } receiveValue: { [weak self] reponse in
                guard let self else { return }
                self.status = .created
            }
            .store(in: &cancellables)
    }
}
