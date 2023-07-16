//
//  ProposalResponse.swift
//  dealMates
//
//  Created by Stanislav on 07.06.2023.
//

import Foundation

struct ProposalResponse: Decodable {
    let result: [Proposal]
}

struct Proposal: Decodable {
    let id: String
    let title: String
    let minPrice: Float
    let description: String
    let dateCreated: String
    let dateUpdated: String?
    var isLiked: Bool
    let yearOfExperience: Int?
    let executor: ProposalExecutor
    let category: Category
    let photos: [Photo]
}

struct ProposalExecutor: Decodable {
    let firstName: String
    let lastName: String
    let nickName: String?
    let photoUrl: String?
}

struct Category: Decodable {
    let id: Int
    let name: String
}

struct Photo: Decodable {
    let id: String
    let fileName: String
    let fileUrl: String
}
