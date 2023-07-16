//
//  DealMatesTests.swift
//  DealMatesTests
//
//  Created by Stanislav on 11.06.2023.
//

@testable import dealMates
import XCTest

final class DealMatesTests: XCTestCase {

    func testProposalMappingToPrposalCellModel() {
        let proposal = Proposal(id: UUID().uuidString,
                                title: "Moan the grass",
                                minPrice: "30",
                                description: "Hello! My name is Ben. I can moan your grass, cut your bushes and trees",
                                dateCreated: "06-10-2023",
                                isLiked: false,
                                executor: .init(firstName: "Ben", lastName: "Johnson", nickName: "ben1506", photoUrl: ""),
                                category: .init(id: "0", name: "House-keeping"),
                                photos: [])
        
        
        let receivedCellModel = ProposalMapper.map(proposal: proposal)
        let expectedCellModel = ProposalCellModel(title: "Moan the grass",
                                                  description: "Hello! My name is Ben. I can moan your grass, cut your bushes and trees",
                                                  avatarURL: nil,
                                                  imageURL: nil,
                                                  publishDate: "10 June 2023",
                                                  location: nil,
                                                  price: "30$",
                                                  isLiked: false)
        
        
        XCTAssert(receivedCellModel.price == expectedCellModel.price)
        XCTAssert(receivedCellModel.publishDate == expectedCellModel.publishDate)
    }

}
