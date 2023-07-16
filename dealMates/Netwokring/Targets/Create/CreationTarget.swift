//
//  CreationTarget.swift
//  dealMates
//
//  Created by Stanislav on 15.06.2023.
//

import Foundation
import Moya

enum CreationTarget {
    case createProposal(ProposalCreation)
    case createRequest(RequestCreation)
    case getCategories
}

extension CreationTarget: TargetType {
    var baseURL: URL {
        return URL(string: "")!
    }
    
    var path: String {
        switch self {
        case .createProposal: return "/proposal"
        case .createRequest: return "/request"
        case .getCategories: return "/category"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createProposal, .createRequest: return .post
        case .getCategories: return .get
        }
    }
    
    var task: Moya.Task {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        switch self {
        case .createProposal(let params):
            return .requestCustomJSONEncodable(params, encoder: encoder)
            
        case .createRequest(let params):
            return .requestCustomJSONEncodable(params, encoder: encoder)

        case .getCategories:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return nil
    }
}

// MARK: - AccessTokenAuthorizable
extension CreationTarget: AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? {
        switch self {
        case .createRequest, .createProposal, .getCategories: return .bearer
        }
    }
}
