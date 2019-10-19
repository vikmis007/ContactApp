//
//  Person+CoreDataProperties.swift
//  ContactApp
//
//  Created by Vikas Mishra on 19/10/19.
//  Copyright © 2019 Vikas Mishra. All rights reserved.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var id: Int32
    @NSManaged public var first_name: String?
    @NSManaged public var last_name: String?
    @NSManaged public var profile_pic: String?
    @NSManaged public var favorite: Bool
    @NSManaged public var url: String?
    
}
