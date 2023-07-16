//
//  AuthResponses.swift
//  dealMates
//
//  Created by Stanislav on 03.06.2023.
//

import Foundation

struct SignInResponse: Decodable {
    struct Result: Decodable {
        let token: String
    }
    
    let result: Result
}

struct SignUpResponse: Decodable {
    let result: String
}
