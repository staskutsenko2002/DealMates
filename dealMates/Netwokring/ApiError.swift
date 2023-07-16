//
//  ApiError.swift
//  TheAllInApp
//
//  Created by Oleh Ionochkin on 21.03.2022.
//

import Foundation
import Alamofire
import Moya

enum ApiClientError: Error {

    case cancelled
    case timedOut
    case unauthorized
    case offline
    case underlying(error: Error)
    case unknown
    case mapping
    case apiError(_ error: ApiError)

    init(moyaError: MoyaError) {

        switch moyaError {
        case .underlying(let error as AFError, let response):

            guard case let .responseValidationFailed(reason) = error,
                  case let .unacceptableStatusCode(statusCode) = reason
            else {
                self = .underlying(error: moyaError)
                if let underlyingError = error.underlyingError as NSError? {
                    self = errorFrom(nsError: underlyingError, moyaError: moyaError)
                    return
                }
                return
            }
            self = .underlying(error: moyaError)
        case .objectMapping:
            self = .mapping
        case .statusCode(let response):
            self = .unknown
            self = errorFrom(response: response)
        default:
            self = .underlying(error: moyaError)
        }
    }

    init(apiError: ApiError) {
        self = .apiError(apiError)
    }
    
    func errorFrom(response: Response) -> ApiClientError {
        switch response.statusCode {
        case 401: return .unauthorized
        default:  return .unknown
        }
    }

    func errorFrom(nsError: NSError, moyaError: MoyaError) -> ApiClientError {
        switch nsError.code {
        case -999:           return .cancelled
        case -1_001:         return .timedOut
        case -1_009, -1_020: return .offline
        default:             return .underlying(error: moyaError)
        }
    }

    var errorDescription: String? {
        switch self {
        case .cancelled:              return "Cancelled"
        case .timedOut:               return "Request is timed out"
        case .offline:                return "No Internet Connection. Please try again later"
        case .unauthorized:           return "User is unauthorized"
        case .mapping:                return "Something went wrong"
        case .unknown:                return "Oops. Something went wrong"
        case .underlying(let error):  return error.localizedDescription
        case .apiError(let error):    return error.message
        }
    }
}

struct ErrorReponse: Decodable {
    let errors: [ApiError]
}

struct ApiError: Error, Decodable {
    let code: String
    let message: String
    let fieldName: String

    var errorDescription: String? {
        return message
    }

   
}
