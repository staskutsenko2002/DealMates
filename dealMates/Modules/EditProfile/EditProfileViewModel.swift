//
//  EditProfileViewModel.swift
//  dealMates
//
//  Created by Stanislav on 16.06.2023.
//

import Foundation
import Combine

final class EditProfileViewModel {
    
    private(set) var profileModel: ProfileModel
    private var cancellables = Set<AnyCancellable>()
    let onModelUpdate = PassthroughSubject<ProfileModel, Never>()
    private let networkService: NetworkServiceProfile & NetworkServiceUserInfo
    
    @Published var status: PageStatus = .idle
    
    init(
        profileModel: ProfileModel,
        networkService: NetworkServiceProfile & NetworkServiceUserInfo
    ) {
        self.profileModel = profileModel
        self.networkService = networkService
    }
    
    func update(firstName: String, lastName: String, location: String?) {
        guard status != .loading else { return }
        status = .loading
        
        guard let userId = networkService.userId else { return }
        
        networkService.updateProfile(userId: userId, firstName: firstName, lastName: lastName, location: location)
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case .finished:
                    self.status = .loaded
                    
                case .failure(let error):
                    self.status = .error(message: error.errorDescription ?? "")
                }
            } receiveValue: { [weak self] _ in
                guard let self else { return }
                self.profileModel.firstName = firstName
                self.profileModel.lastName = lastName
                self.profileModel.location = location ?? ""
            }.store(in: &cancellables)
    }
}
