//
//  SignInViewModel.swift
//  dealMates
//
//  Created by Stanislav on 13.05.2023.
//

import Foundation
import Combine

final class SignInViewModel {
    
    let onSignUp = PassthroughSubject<Void, Never>()
    let onSignIn = PassthroughSubject<Void, Never>()
    let onError = PassthroughSubject<ApiClientError, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    private let networkService: NetworkServiceToken & NetworkServiceAuth
    
    init(networkService: NetworkServiceToken & NetworkServiceAuth) {
        self.networkService = networkService
    }
    
    func signIn(email: String, password: String) {
        networkService.signIn(email: email, password: password).sink(
            receiveCompletion: { [weak self] result in
                guard let self else { return }
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    self.onError.send(error)
                }
            },
            receiveValue: { [weak self] response in
                guard let self else { return }
                self.networkService.update(token: response.result.token)
                DispatchQueue.main.async {
                    self.onSignIn.send()
                }
                
            }
        ).store(in: &cancellables)
    }
}
