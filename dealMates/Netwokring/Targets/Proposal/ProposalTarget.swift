//
//  ProposalTarget.swift
//  dealMates
//
//  Created by Stanislav on 07.06.2023.
//

import Foundation
import Moya

enum ProposalTarget {
    case proposals(page: Int, paginationSize: Int)
    case favouriteProposals(userId: String, page: Int, paginationSize: Int)
    case like(proposalId: String)
    case unlike(likeId: String)
}

extension ProposalTarget: TargetType {
    var baseURL: URL {
        return URL(string: "")!
    }
    
    var path: String {
        switch self {
        case .proposals: return "/proposal/search"
        case .favouriteProposals(let userId, _, _): return "/user/\(userId)/proposal/favorite"
        case .like(let proposalId): return "/proposal/\(proposalId)/favorite"
        case .unlike(let likeId): return "/proposal/favorite/\(likeId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .proposals, .favouriteProposals: return .get
        case .like: return .post
        case .unlike: return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .proposals(let page, let paginationSize),
             .favouriteProposals(_, let page, let paginationSize):
            return .requestParameters(
                parameters: ["PaginationSize": paginationSize, "PageNumber": page],
                encoding: URLEncoding.default)
            
        case .like, .unlike:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return nil
    }
}


// MARK: - AccessTokenAuthorizable
extension ProposalTarget: AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? {
        switch self {
        case .proposals, .favouriteProposals, .like, .unlike: return .bearer
        }
    }
}
