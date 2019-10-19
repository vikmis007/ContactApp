//
//  Person+CoreDataClass.swift
//  ContactApp
//
//  Created by Vikas Mishra on 19/10/19.
//  Copyright © 2019 Vikas Mishra. All rights reserved.
//
//

import Foundation
import CoreData

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}

@objc(Person)
class Person: NSManagedObject, Decodable {

    var initialLetter: String {
        willAccessValue(forKey: "first_name")
        let initial = (first_name! as NSString).substring(to: 1)
        didAccessValue(forKey: "first_name")
        return initial
    }

    var fullName: String {
        return "\(first_name ?? "") \(last_name ?? ""   )"
    }
    
    /// Init method to decode into model object
    required convenience init(from decoder: Decoder) throws {
        guard let managedContext = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext, let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext) else {
            fatalError(MessageConstant.FATAL_ERROR_OCCURED)
        }
        self.init(entity: entity, insertInto: managedContext)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            id = try container.decodeIfPresent(Int32.self, forKey: .id)!
            first_name = try container.decodeIfPresent(String.self, forKey: .first_name)
            last_name = try container.decodeIfPresent(String.self, forKey: .last_name)
            profile_pic = try container.decodeIfPresent(String.self, forKey: .profile_pic)
            url = try container.decodeIfPresent(String.self, forKey: .url)
            favorite = try container.decodeIfPresent(Bool.self, forKey: .favorite) ?? false
        } catch {

        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(first_name, forKey: .first_name)
        try container.encode(last_name, forKey: .last_name)
        try container.encode(profile_pic, forKey: .profile_pic)
        try container.encode(favorite, forKey: .favorite)
        try container.encode(url, forKey: .url)

    }

    enum CodingKeys: String, CodingKey {
        case id
        case first_name
        case last_name
        case profile_pic
        case favorite
        case url
    }
}
