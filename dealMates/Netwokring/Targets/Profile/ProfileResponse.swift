//
//  ProfileResponse.swift
//  dealMates
//
//  Created by Stanislav on 13.06.2023.
//

import Foundation

struct ProfileResponse: Decodable {
    let result: Profile
}

struct Profile: Decodable {
    let id: String
    let firstName: String
    let lastName: String
    let phone: String?
    let photoUrl: String?
    let email: String?
    let location: String?
    let hasExecutorProfile: Bool?
   }
