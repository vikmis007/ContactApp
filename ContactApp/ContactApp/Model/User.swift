//
//  User.swift
//  ContactApp
//
//  Created by Vikas Mishra on 19/10/19.
//  Copyright © 2019 Vikas Mishra. All rights reserved.
//

import Foundation

struct User: Codable {
    var id: Int32?
    var firstName: String?
    var lastName: String?
    var email: String?
    var phoneNumber: String?
    var profilePic: String?
    var favorite: Bool?
    var createdAt: String?
    var updatedAt: String?
    var fullName: String? {
        return "\(firstName ?? "") \(lastName ?? "")"
    }

    enum CodingKeys: String, CodingKey {
        case id
        case favorite
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case profilePic = "profile_pic"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case phoneNumber = "phone_number"
    }
}

extension User: Equatable {
    public static func == (lhs: User, rhs: User) -> Bool{
        return lhs.id == rhs.id && lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.phoneNumber == rhs.phoneNumber && lhs.email == rhs.email
    }
}
