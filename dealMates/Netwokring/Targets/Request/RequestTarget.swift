//
//  RequestTarget.swift
//  dealMates
//
//  Created by Stanislav on 09.06.2023.
//

import Moya

enum RequestTarget {
    case requests(page: Int, paginationSize: Int)
    case favouriteRequests(userId: String, page: Int, paginationSize: Int)
}

extension RequestTarget: TargetType {
    var baseURL: URL {
        return URL(string: "")!
    }
    
    var path: String {
        switch self {
        case .requests: return "/request/search"
        case .favouriteRequests(let userId, _, _): return "/user/\(userId)/request/favorite"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .requests, .favouriteRequests: return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .requests(let page, let paginationSize),
             .favouriteRequests(_, let page, let paginationSize):
            return .requestParameters(
                parameters: ["PaginationSize": paginationSize, "PageNumber": page],
                encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return nil
    }
}

// MARK: - AccessTokenAuthorizable
extension RequestTarget: AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? {
        switch self {
        case .requests, .favouriteRequests: return .bearer
        }
    }
}
