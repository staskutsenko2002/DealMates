//
//  ProposalRequestCreation.swift
//  dealMates
//
//  Created by Stanislav on 15.06.2023.
//

import Foundation

struct ProposalCreation: Encodable {
    let title: String
    let description: String
    let categoryId: Int
    let minPrice: Float
    let yearOfExperience: Int?
}

struct RequestCreation: Encodable {
    let title: String
    let body: String
    let categoryId: Int
    let proposedPrice: Float
}

struct CategoriesResponse: Decodable {
    let result: [Category]
}
