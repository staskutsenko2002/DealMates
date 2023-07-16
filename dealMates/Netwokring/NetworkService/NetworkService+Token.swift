//
//  NetworkService+Token.swift
//  dealMates
//
//  Created by Stanislav on 03.06.2023.
//

import Foundation

protocol NetworkServiceToken {
    var accessToken: String? { get set }
    
    func update(token: String)
}

protocol NetworkServiceUserInfo {
    var userId: String? { get }
    var isExecutor: Bool? { get }
}
