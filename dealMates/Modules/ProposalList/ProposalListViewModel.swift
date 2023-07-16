//
//  ProposalListViewModel.swift
//  dealMates
//
//  Created by Stanislav on 04.06.2023.
//

import Foundation
import Combine

enum PageStatus: Equatable {
    case loading
    case error(message: String)
    case idle
    case empty
    case loaded
}

final class ProposalListViewModel {
    
    private(set) var cellModels = [ProposalCellModel]()
    @Published var status: PageStatus = .idle
    let onRemoveLiked = PassthroughSubject<Void, Never>()
    
    private var page = 0
    private let isFavourites: Bool
    private var cancellables = Set<AnyCancellable>()
    private var didSelectProposal: ((ProposalCellModel) -> Void)
    private let networkService: NetworkServiceProposal & NetworkServiceUserInfo
    
    init(
        isFavourites: Bool,
        networkService: NetworkServiceProposal & NetworkServiceUserInfo,
        didSelectProposal: @escaping ((ProposalCellModel) -> Void)
    ) {
        self.isFavourites = isFavourites
        self.networkService = networkService
        self.didSelectProposal = didSelectProposal
    }
    
    func getProposals() {
        guard status != .loading, let userId = networkService.userId else { return }
        status = .loading
        if !isFavourites {
            networkService.getProposals(userId: userId, isFavourite: isFavourites, page: page, paginationSize: Constants.paginationSize)
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
                    self.cellModels = response.result.map(map(proposal:))
                })
                .store(in: &cancellables)
        } else {
            networkService.getLikedProposals(userId: userId, isFavourite: isFavourites, page: page, paginationSize: Constants.paginationSize)
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
                    self.cellModels = response.result.map(map(likeProposal:))
                })
                .store(in: &cancellables)
        }
        
    }
    
    func select(item: Int) {
        didSelectProposal(cellModels[item])
    }
    
    private func map(likeProposal: LikedProposal) -> ProposalCellModel {
        DateFormatter.formatter.format = .yyyy_mm_dd_t_hh_mm_ss_sssz
        let date = DateFormatter.formatter.date(from: likeProposal.proposal.dateCreated)
        DateFormatter.formatter.format = .dd_mmmm_yyyy
        var publishDate: String?
        
        if let date {
            publishDate = DateFormatter.formatter.string(from: date)
        } else {
            publishDate = nil
        }
        
        return .init(
            id: likeProposal.proposal.id,
            title: likeProposal.proposal.title,
            description: likeProposal.proposal.description,
            avatarURL: URL(string: likeProposal.proposal.executor.photoUrl ?? ""),
            imageURL: URL(string: likeProposal.proposal.photos.first?.fileUrl ?? ""),
            category: likeProposal.proposal.category,
            publishDate: publishDate,
            location: nil,
            price: "\(likeProposal.proposal.minPrice)$",
            isLiked: likeProposal.proposal.isLiked,
            likeId: likeProposal.id,
            onLikeClick: { [weak self] isLiked in
                self?.processLike(isLiked: isLiked, proposalId: likeProposal.proposal.id)
            })
    }
    
    private func map(proposal: Proposal) -> ProposalCellModel {
        DateFormatter.formatter.format = .yyyy_mm_dd_t_hh_mm_ss_sssz
        let date = DateFormatter.formatter.date(from: proposal.dateCreated)
        DateFormatter.formatter.format = .dd_mmmm_yyyy
        var publishDate: String?
        
        if let date {
            publishDate = DateFormatter.formatter.string(from: date)
        } else {
            publishDate = nil
        }
        
        return .init(
            id: proposal.id,
            title: proposal.title,
            description: proposal.description,
            avatarURL: URL(string: proposal.executor.photoUrl ?? ""),
            imageURL: URL(string: proposal.photos.first?.fileUrl ?? ""),
            category: proposal.category,
            publishDate: publishDate,
            location: nil,
            price: "\(proposal.minPrice)$",
            isLiked: proposal.isLiked,
            onLikeClick: { [weak self] isLiked in
                self?.processLike(isLiked: isLiked, proposalId: proposal.id)
            })
    }
    
    private func processLike(isLiked: Bool, proposalId: String) {
        if isLiked {
            like(proposalId: proposalId)
        } else {
            unlike(proposalId: proposalId)
        }
    }
    
    private func like(proposalId: String) {
        networkService.like(proposalId: proposalId)
            .sink { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    self.status = .error(message: error.errorDescription ?? "")
                }
            } receiveValue: { [weak self] response in
                guard let self, let index = cellModels.firstIndex(where: { $0.id == proposalId }) else { return }
                self.cellModels[index].likeId = response.result
            }.store(in: &cancellables)

    }
    
    private func unlike(proposalId: String) {
        guard let likeId = cellModels.first(where: { $0.id == proposalId })?.likeId else { return }
        
        networkService.unlike(likeId: likeId)
            .sink { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    self.status = .error(message: error.errorDescription ?? "")
                }
            } receiveValue: { [weak self] _ in
                guard let self, let index = cellModels.firstIndex(where: { $0.id == proposalId }) else { return }
                self.cellModels[index].likeId = nil
                self.cellModels.remove(at: index)
                self.onRemoveLiked.send()
            }.store(in: &cancellables)
    }
}
