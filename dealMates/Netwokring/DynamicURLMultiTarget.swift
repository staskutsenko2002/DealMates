//
//  DynamicURLMultiTarget.swift
//  TheAllInApp
//
//  Created by Kutsenko Stanislav on 12.01.2022.
//

import Foundation
import Moya

struct DynamicURLMultiTarget: TargetType {

    let dynamicBaseURL: URL
    let target: TargetType

    init(baseURL: URL, target: TargetType) {
        self.dynamicBaseURL = baseURL
        self.target = target
    }

    var baseURL: URL {
        return dynamicBaseURL
    }

    var path: String {
        return target.path
    }

    var method: Moya.Method {
        return target.method
    }
    
    var sampleData: Data {
        return target.sampleData
    }

    var task: Task {
        return target.task
    }

    var validationType: ValidationType {
        return target.validationType
    }

    var headers: [String: String]? {
        return target.headers
    }
}

// MARK: - AccessTokenAuthorizable
extension DynamicURLMultiTarget: AccessTokenAuthorizable {
    
    var authorizationType: AuthorizationType? {
        guard let authorizable = target as? AccessTokenAuthorizable else { return nil }
        return authorizable.authorizationType
    }
}
