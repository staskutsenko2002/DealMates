//
//  RequestResponse.swift
//  dealMates
//
//  Created by Stanislav on 09.06.2023.
//

import Foundation

struct RequestResponse: Decodable {
    let result: [Request]
}

struct Request: Decodable {
    let id: String
    let title: String
    let body: String
    let proposedPrice: Float
    let category: Category
    let client: RequestClient
    let attachments: [String]
}

struct RequestClient: Decodable {
    let id: String
    let firstName: String
    let lastName: String
    let photoUrl: String?
}
