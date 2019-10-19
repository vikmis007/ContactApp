//
//  CoreDataManager.swift
//  Contact
//
//  Created by vikas mishra on 19/10/19.
//  Copyright © 2019 vikas mishra. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

    /// Inserts array of object into Core Data
    ///
    /// - Parameter persons: array of object
    func insertObjects(persons: [Person]) {
        LoadingIndicator.shared.showLoadingIndicator()
        for person in persons {
            insertObject(person: person)
        }
        LoadingIndicator.shared.hideLoadingIndicator()
    }
    
    /// Insert/Update single object to core data
    ///
    /// - Parameter person: object to be inserted
    func insertObject(person: Person) {
        let managedContext = CoreDataStack.shared.persistentContainer.viewContext
        let personObj = Person()
        personObj.id = Int32(person.id)
        personObj.first_name = person.first_name
        personObj.last_name = person.last_name
        personObj.favorite = person.favorite
        personObj.profile_pic = person.profile_pic
        personObj.url = person.url

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    
    /// This mmethod will update a single core data entity
    ///
    /// - Parameter person: Object to be modified
    func updateObject(person: Person) {
    }
}
