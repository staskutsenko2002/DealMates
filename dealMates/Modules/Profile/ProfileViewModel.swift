//
//  ProfileViewModel.swift
//  dealMates
//
//  Created by Stanislav on 13.06.2023.
//

import Foundation
import Combine

final class ProfileViewModel {
    
    let title: String
    private(set) var profileModel: ProfileModel?
    @Published var status: PageStatus = .idle
    let didUpdateProfile = PassthroughSubject<ProfileModel, Never>()
    
    let didBecomeExecutor: VoidCallback
    var didPressEditProfile: ((ProfileModel) -> ())?
    
    var isExecutor: Bool {
        networkService.isExecutor ?? false
    }
    
    private var cancellables = Set<AnyCancellable>()
    private let networkService: NetworkServiceUserInfo & NetworkServiceProfile
    
    init(networkService: NetworkServiceUserInfo & NetworkServiceProfile,
         didBecomeExecutor: @escaping VoidCallback) {
        self.networkService = networkService
        self.didBecomeExecutor = didBecomeExecutor
        self.title = AppText.profile()
        setupSubscription()
    }
    
    func getUserInfo() {
        guard status != .loading else { return }
        status = .loading
        
        guard let userId = networkService.userId else { return }
        
        networkService.getProfile(userId: userId)
            .sink(receiveCompletion: { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .finished:
                    self.status = .loaded
                    
                case .failure(let error):
                    self.status = .error(message: error.errorDescription ?? "")
                }
            },
            receiveValue: { [weak self] response in
                guard let self else { return }
                self.profileModel = self.map(profile: response.result)
            }).store(in: &cancellables)
    }
    
    func showProposals() {
        
    }
    
    func showRequests() {
        
    }
    
    func editProfile() {
        guard let profileModel else { return }
        didPressEditProfile?(profileModel)
    }
    
    func becomeExecutor() {
        guard status != .loading else { return }
        status = .loading
        
        guard let userId = networkService.userId else { return }
        networkService.becomeExecutor(userId: userId)
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case .finished:
                    self.status = .loaded
                case .failure(let error):
                    self.status = .error(message: error.errorDescription ?? "")
                }
            } receiveValue: { [weak self] response in
                self?.didBecomeExecutor()
            }.store(in: &cancellables)
    }
}

// MARK: - Setup methods
private extension ProfileViewModel {
    func setupSubscription() {
        didUpdateProfile.sink { [weak self] model in
            guard let self else { return }
            self.profileModel?.firstName = model.firstName
            self.profileModel?.lastName = model.lastName
            self.profileModel?.location = model.location
            self.status = .loaded
        }.store(in: &cancellables)
    }
    
    func map(profile: Profile) -> ProfileModel {
        return .init(
            id: profile.id,
            firstName: profile.firstName,
            lastName: profile.lastName,
            phone: profile.phone ?? "",
            email: profile.email ?? "",
            photoUrl: profile.photoUrl ?? "",
            birthday: "",
            location: profile.location ?? "",
            hasExecutorProfile: profile.hasExecutorProfile ?? false)
    }
}

struct ProfileModel {
    let id: String
    var firstName: String
    var lastName: String
    let phone: String
    let email: String
    let photoUrl: String
    let birthday: String
    var location: String
    let hasExecutorProfile: Bool
}
