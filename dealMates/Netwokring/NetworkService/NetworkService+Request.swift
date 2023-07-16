//
//  NetworkService+Request.swift
//  dealMates
//
//  Created by Stanislav on 09.06.2023.
//

import Combine

protocol NetworkServiceRequest {
    func getRequests(userId: String, isFavourite: Bool, page: Int, paginationSize: Int) -> Future<RequestResponse, ApiClientError>
}

extension NetworkService: NetworkServiceRequest {
    func getRequests(userId: String, isFavourite: Bool, page: Int, paginationSize: Int) -> Future<RequestResponse, ApiClientError> {
        
        let target: RequestTarget
        
        if isFavourite {
            target = .favouriteRequests(userId: userId, page: page, paginationSize: paginationSize)
        } else {
            target = .requests(page: page, paginationSize: paginationSize)
        }
        
        let promise: Future<RequestResponse, ApiClientError> = apiClient.request(target: DynamicURLMultiTarget(baseURL: networkBaseURL, target: target))
        return promise
    }
}
