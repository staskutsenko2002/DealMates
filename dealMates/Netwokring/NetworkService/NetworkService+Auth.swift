//
//  NetworkService+Auth.swift
//  dealMates
//
//  Created by Stanislav on 03.06.2023.
//

import Combine

protocol NetworkServiceAuth {
    func signIn(email: String, password: String) -> Future<SignInResponse, ApiClientError>
    func signUp(params: RegisterParams) -> Future<SignUpResponse, ApiClientError>
}

extension NetworkService: NetworkServiceAuth {
    func signIn(email: String, password: String) -> Future<SignInResponse, ApiClientError> {
        let target = AuthTarget.login(.init(email: email, password: password))
        
        let promise: Future<SignInResponse, ApiClientError> = apiClient.request(target: .init(baseURL: networkBaseURL, target: target))
        return promise
    }
    
    func signUp(params: RegisterParams) -> Future<SignUpResponse, ApiClientError> {
        let target = AuthTarget.register(params)
        let promise: Future<SignUpResponse, ApiClientError> = apiClient.request(target: .init(baseURL: networkBaseURL, target: target))
        
        return promise
    }
}
