//
//  ProfileTarget.swift
//  dealMates
//
//  Created by Stanislav on 13.06.2023.
//

import Foundation
import Moya

struct BecomeExecutorParams: Encodable {
    let executorWorkType: Int
    let executorStatus: Int
    let selfPresentation: String
    let cv: String
}

enum ProfileTarget {
    case getProfile(userId: String)
    case becomeExecutor(userId: String, params: BecomeExecutorParams)
    case updateProfile(userId: String, params: UpdateProfileParams)
}

extension ProfileTarget: TargetType {
    var baseURL: URL {
        return URL(string: "")!
    }
    
    var path: String {
        switch self {
        case .getProfile(let userId): return "/user/\(userId)"
        case .becomeExecutor(let userId, _): return "/user/\(userId)/executor"
        case .updateProfile(let userId, _): return "/user/\(userId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getProfile: return .get
        case .becomeExecutor: return .post
        case .updateProfile: return .put
        }
    }
    
    var task: Moya.Task {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        switch self {
        case .getProfile: return .requestPlain
        case .becomeExecutor(_, let params): return .requestCustomJSONEncodable(params, encoder: encoder)
        case .updateProfile(_, let params): return .requestCustomJSONEncodable(params, encoder: encoder)
        }
    }
    
    var headers: [String: String]? {
        return nil
    }
}

// MARK: - AccessTokenAuthorizable
extension ProfileTarget: AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? {
        switch self {
        case .getProfile, .becomeExecutor, .updateProfile: return .bearer
        }
    }
}
