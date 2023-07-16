//
//  SignUpViewModel.swift
//  dealMates
//
//  Created by Stanislav on 13.05.2023.
//

import Foundation
import Combine

final class SignUpViewModel {
    
    let onBack = PassthroughSubject<Void, Never>()
    let onSignUp = PassthroughSubject<Void, Never>()
    let onError = PassthroughSubject<String, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    private let networService: NetworkServiceAuth
    
    init(networService: NetworkServiceAuth) {
        self.networService = networService
    }
    
    func signUp(firstName: String, lastName: String, phone: String?, birthday: String?, email: String, password: String) {
            let signUpParams = RegisterParams(firstname: firstName, lastname: lastName, email: email, password: password, phone: phone, birthday: birthday)
        
        networService.signUp(params: signUpParams).sink(
            receiveCompletion: { [weak self] result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    guard let desciption = error.errorDescription else { return }
                    DispatchQueue.main.async {
                        self?.onError.send(desciption)
                    }
                }
            },
            receiveValue: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.onSignUp.send()
                }
            }).store(in: &cancellables)
    }
}
