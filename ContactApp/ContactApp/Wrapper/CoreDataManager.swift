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
    
    /// Insert/Update single object to core data
    ///
    /// - Parameter person: object to be inserted
    func insertObject(user: User) {
        let managedContext = CoreDataStack.shared.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        let personObj: Person = NSManagedObject(entity: entity, insertInto: managedContext) as! Person
        personObj.id = user.id!
        personObj.first_name = user.firstName ?? ""
        personObj.last_name = user.lastName ?? ""
        personObj.favorite = user.favorite ?? false
        personObj.profile_pic = user.profilePic ?? ""
        if let firstName = personObj.first_name {
            let firstChar = firstName[firstName.startIndex]
            if let _ = Int(String(firstChar)) {
                personObj.initial = "#"
            } else {
                personObj.initial = String(firstChar).uppercased()
            }
        } else {
            personObj.initial = "#"
        }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    
    /// This mmethod will update a single core data entity
    ///
    /// - Parameter person: Object to be modified
    func updateObject(user: User) {
        LoadingIndicator.shared.showLoadingIndicator()
        let managedContext = CoreDataStack.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Person>(entityName: "Person")
        fetchRequest.predicate = NSPredicate(format: "id == %d", user.id!)
        var person: Person?
        do {
            person = try managedContext.fetch(fetchRequest).first
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        person?.first_name = user.firstName
        person?.last_name = user.lastName
        person?.favorite = user.favorite ?? false

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }

        LoadingIndicator.shared.hideLoadingIndicator()
    }
}
