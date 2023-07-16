//
//  AuthTargetParams.swift
//  TheAllInApp
//
//  Created by Kutsenko Stanislav on 12.01.2022.
//

import Foundation

// MARK: - LoginParams
struct LoginParams: Encodable {
    let email: String
    let password: String
}

// MARK: - FindUserParams
struct RegisterParams: Encodable {
    let firstname: String
    let lastname: String
    let email: String
    let password: String
    let phone: String?
    let birthday: String?
}
