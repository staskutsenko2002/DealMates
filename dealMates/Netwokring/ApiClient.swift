//
//  ApiClient.swift
//  dealMates
//
//  Created by Stanislav Kutsenko on 03.01.2023.
//

import Moya
import Alamofire
import Combine

struct EmptyResponse: Decodable { }

private let callbackQueue = DispatchQueue(
    label: "ApiClient.callbackQueue",
    qos: .utility,
    attributes: .concurrent
)

class ApiClient {
    
    var accessToken: String?
    var provider = MoyaProvider<DynamicURLMultiTarget>()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(accessToken: String?) {
        self.accessToken = accessToken
        provider = MoyaProvider<DynamicURLMultiTarget>(plugins: [authAccessTokenPlagin, networkLoggerPlugin])
    }

    func request<Result: Decodable>(target: DynamicURLMultiTarget) -> Future<Result, ApiClientError> {

        return Future { [weak self] promise in
            guard let self else {
                promise(.failure(ApiClientError.unknown))
                return
            }
            
            self.validateToken(for: target).sink(receiveCompletion: { error in
                if case let .failure(apiClientError) = error {
                    promise(.failure(apiClientError))
                }
                
            }, receiveValue: { [weak self] in
                
                guard let self else {
                    promise(.failure(ApiClientError.unknown))
                    return
                }
                
                let cancellable = provider.request(target, callbackQueue: callbackQueue) { [weak self] result in
                    guard let self else { return }
                    
                    switch result {
                    case let .success(response):
                        do {
                            if let apiError = try self.apiError(response)?.errors.first {
                                promise(.failure(ApiClientError(apiError: apiError)))
                            }
                            promise(.success(try self.handleSuccess(response: response, for: target)))
                        } catch {
                            var rejectedError = (ApiClientError.underlying(error: error))

                            if let moyaError = error as? MoyaError {
                                rejectedError = ApiClientError.init(moyaError: moyaError)
                            }
                            
                            promise(.failure(rejectedError))
                        }
                        
                    case let .failure(moyaError):
                        let error = ApiClientError(moyaError: moyaError)
                        promise(.failure(error))
                    }
                }
            }).store(in: &cancellables)
        }
    }
    
    private func handleSuccess<Result: Decodable>(response: Response, for target: DynamicURLMultiTarget) throws -> Result {
        
        let filteredResponse = try response.filterSuccessfulStatusAndRedirectCodes()
        let mapResponse = try filteredResponse.map(Result.self,
                                                   using: JSONDecoder(),
                                                   failsOnEmptyData: false)
        
        return mapResponse
    }

    private func apiError(_ response: Response) throws -> ErrorReponse? {
        if let apiError = try? response.map(ErrorReponse.self, using: JSONDecoder(), failsOnEmptyData: false),
           apiError.errors.first?.code.isEmpty == false {
            return apiError
        }

        return nil
    }

    private var authAccessTokenPlagin: AccessTokenPlugin {
        let plugin = AccessTokenPlugin { [weak self] (_) -> String in
            guard let token = self?.accessToken?.replacingOccurrences(of: "Bearer ", with: "") else { return "" }
            return token
        }

        return plugin
    }
    
    private var networkLoggerPlugin: NetworkLoggerPlugin {
        return NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
    }
    
    private func validateToken(for target: DynamicURLMultiTarget) -> Future<Void, ApiClientError> {
        return Future { [weak self] promise in
            guard let self else {
                promise(.failure(ApiClientError.unknown))
                return
            }
            
            if target.authorizationType != nil, accessToken != nil {
                promise(.success(Void()))
                return
            } else if target.authorizationType == nil {
                promise(.success(Void()))
                return
            }
            
            promise(.failure(ApiClientError.unauthorized))
        }
    }
}
