//
//  NetworkService.swift
//  TheAllInApp
//
//  Created by Kutsenko Stanislav on 11.01.2022.
//

import Foundation
import JWTDecode

class NetworkService: NetworkServiceToken {
    static let shared = NetworkService()
    
    var apiClient: ApiClient!
    
    private var id: String?
    private var executor: Bool?
    
    var accessToken: String? {
        didSet {
            if let accessToken {
                StorageService.save(accessToken, for: .accessToken, storage: .keychain)
            } else {
                StorageService.removeValue(for: .accessToken, storage: .keychain)
            }
            
            initApiClient()
        }
    }
    
    private(set) var networkBaseURL: URL!
    
    private init() {
        initApiClient()
        networkBaseURL = URL(string: "https://dealmates.net/api")
    }
    
    func update(token: String) {
        accessToken = token
        decode(token: token)
    }
}

// MARK: - NetworkServiceUserInfo
extension NetworkService: NetworkServiceUserInfo {
    var userId: String? {
        return id
    }
    
    var isExecutor: Bool? {
        return executor
    }
}

// MARK: - Helping functions
private extension NetworkService {
    func initApiClient() {
        apiClient = ApiClient(accessToken: "Bearer \(accessToken ?? "")")
    }
    
    func decode(token: String?) {
        guard let token, let jwt = try? JWTDecode.decode(jwt: token) else { return }
        
        if let type = jwt["account_type"].string {
            self.executor = type != "user"
        }
        
        if let userId = jwt["nameid"].string {
            self.id = userId
        }
    }
}
