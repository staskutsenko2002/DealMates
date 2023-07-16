//
//  NetworkService+Creation.swift
//  dealMates
//
//  Created by Stanislav on 15.06.2023.
//

import Foundation
import Combine

protocol NetworkServiceCreation {
    func createProposal(proposal: ProposalCreation) -> Future<EmptyResponse, ApiClientError>
    func createRequest(request: RequestCreation) -> Future<EmptyResponse, ApiClientError>
    func getCategories() -> Future<CategoriesResponse, ApiClientError>
}

extension NetworkService: NetworkServiceCreation {
    func getCategories() -> Future<CategoriesResponse, ApiClientError> {
        let target = CreationTarget.getCategories
        let promise: Future<CategoriesResponse, ApiClientError> = apiClient.request(target: DynamicURLMultiTarget(baseURL: networkBaseURL, target: target))
        return promise
    }
    
    func createRequest(request: RequestCreation) -> Future<EmptyResponse, ApiClientError> {
        let target = CreationTarget.createRequest(request)
        
        let promise: Future<EmptyResponse, ApiClientError> = apiClient.request(target: DynamicURLMultiTarget(baseURL: networkBaseURL, target: target))
        return promise
    }
    
    func createProposal(proposal: ProposalCreation) -> Future<EmptyResponse, ApiClientError> {
        let target = CreationTarget.createProposal(proposal)
        
        let promise: Future<EmptyResponse, ApiClientError> = apiClient.request(target: DynamicURLMultiTarget(baseURL: networkBaseURL, target: target))
        return promise
    }
}
