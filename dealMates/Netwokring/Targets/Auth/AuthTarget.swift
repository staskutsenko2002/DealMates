//
//  AuthTarget.swift
//  TheAllInApp
//
//  Created by Kutsenko Stanislav on 12.01.2022.
//

import Foundation
import Moya

enum AuthTarget {
    case login(LoginParams)
    case register(RegisterParams)
}

extension AuthTarget: TargetType {
    
    var baseURL: URL {
        return URL(string: "")!
    }

    var path: String {
        switch self {
        case .login: return "/account/login"
        case .register: return "/user"
            
        }
    }

    var method: Moya.Method {
        switch self {
        case .login, .register: return .post
        }
    }

    var task: Task {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        switch self {
        case .login(let params): return .requestCustomJSONEncodable(params, encoder: encoder)
        case .register(let params): return .requestCustomJSONEncodable(params, encoder: encoder)
        }
    }

    var sampleData: Data {
        switch self {
        case .login, .register: return Data()
        }
    }

    var headers: [String: String]? {
        switch self {
        case .login, .register:
            return nil
        }
    }
}

// MARK: - AccessTokenAuthorizable
extension AuthTarget: AccessTokenAuthorizable {
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .login, .register: return nil
        }
    }
}
