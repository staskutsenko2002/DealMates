//
//  NetworkService+Profile.swift
//  dealMates
//
//  Created by Stanislav on 13.06.2023.
//

import Combine

protocol NetworkServiceProfile {
    func getProfile(userId: String) -> Future<ProfileResponse, ApiClientError>
    func updateProfile(userId: String, firstName: String, lastName: String, location: String?) -> Future<EmptyResponse, ApiClientError>
    func becomeExecutor(userId: String) -> Future<EmptyResponse, ApiClientError>
}

extension NetworkService: NetworkServiceProfile {
    func updateProfile(userId: String, firstName: String, lastName: String, location: String?) -> Future<EmptyResponse, ApiClientError> {
        let params = UpdateProfileParams(firstName: firstName, lastName: lastName, location: location, birthday: nil, nickName: nil, phone: nil)
        let target = ProfileTarget.updateProfile(userId: userId, params: params)
        let promise: Future<EmptyResponse, ApiClientError> = apiClient.request(target: DynamicURLMultiTarget(baseURL: networkBaseURL, target: target))
        return promise
    }
    
    func getProfile(userId: String) -> Future<ProfileResponse, ApiClientError> {
        let target = ProfileTarget.getProfile(userId: userId)
        let promise: Future<ProfileResponse, ApiClientError> = apiClient.request(target: DynamicURLMultiTarget(baseURL: networkBaseURL, target: target))
        return promise
    }
    
    func becomeExecutor(userId: String) -> Future<EmptyResponse, ApiClientError> {
        let target = ProfileTarget.becomeExecutor(userId: userId, params: .init(executorWorkType: 0, executorStatus: 0, selfPresentation: "selfPresentation selfPresentation selfPresentation selfPresentation selfPresentation", cv: "selfPresentation selfPresentation selfPresentation selfPresentation selfPresentation"))
        
        let promise: Future<EmptyResponse, ApiClientError> = apiClient.request(target: DynamicURLMultiTarget(baseURL: networkBaseURL, target: target))
        return promise
    }
}

struct UpdateProfileParams: Encodable {
    let firstName: String
    let lastName: String
    let location: String?
    let birthday: String?
    let nickName: String?
    let phone: String?
}
