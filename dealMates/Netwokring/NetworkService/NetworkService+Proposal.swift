//
//  NetworkService+Proposal.swift
//  dealMates
//
//  Created by Stanislav on 07.06.2023.
//

import Combine
import Moya

protocol NetworkServiceProposal {
    func getProposals(userId: String, isFavourite: Bool, page: Int, paginationSize: Int) -> Future<ProposalResponse, ApiClientError>
    func getLikedProposals(userId: String, isFavourite: Bool, page: Int, paginationSize: Int) -> Future<LikedProposalResponse, ApiClientError>
    func like(proposalId: String) -> Future<LikeResponse, ApiClientError>
    func unlike(likeId: String) -> Future<EmptyResponse, ApiClientError>

}

extension NetworkService: NetworkServiceProposal {
    func getProposals(userId: String, isFavourite: Bool, page: Int, paginationSize: Int) -> Future<ProposalResponse, ApiClientError> {
        
        let target = ProposalTarget.proposals(page: page, paginationSize: paginationSize)
        
        let promise: Future<ProposalResponse, ApiClientError> = apiClient.request(target: .init(baseURL: networkBaseURL, target: target))
        return promise
    }
    
    func getLikedProposals(userId: String, isFavourite: Bool, page: Int, paginationSize: Int) -> Future<LikedProposalResponse, ApiClientError> {
        let target = ProposalTarget.favouriteProposals(userId: userId, page: page, paginationSize: paginationSize)
        let promise: Future<LikedProposalResponse, ApiClientError> = apiClient.request(target: .init(baseURL: networkBaseURL, target: target))
        return promise
    }
    
    func like(proposalId: String) -> Future<LikeResponse, ApiClientError> {
        let target = ProposalTarget.like(proposalId: proposalId)
        let promise: Future<LikeResponse, ApiClientError> = apiClient.request(target: .init(baseURL: networkBaseURL, target: target))
        return promise
    }
    
    func unlike(likeId: String) -> Future<EmptyResponse, ApiClientError> {
        let target = ProposalTarget.unlike(likeId: likeId)
        let promise: Future<EmptyResponse, ApiClientError> = apiClient.request(target: .init(baseURL: networkBaseURL, target: target))
        return promise
    }
}

struct LikeResponse: Decodable {
    let result: String
}

struct LikedProposalResponse: Decodable {
    let result: [LikedProposal]
}

struct LikedProposal: Decodable {
    let id: String
    let proposal: Proposal
}
