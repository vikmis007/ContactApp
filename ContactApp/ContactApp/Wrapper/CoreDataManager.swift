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
    var people: [Person] = [Person]()
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    /// Inserts array of object into Core Data
    ///
    /// - Parameter persons: array of object
    func insertObjects(persons: [Person]) {
    }
    
    /// Insert/Update single object to core data
    ///
    /// - Parameter person: object to be inserted
    func insertObject(person: Person) {
    }
    
    /// This method will fetch all the objects from core data
    ///
    /// - Returns: array of user objects
    func fetchObjectList() -> [Person] {
        LoadingIndicator.shared.showLoadingIndicator()
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Person>(entityName: "User")
        
        do {
            people = try managedContext.fetch(fetchRequest)
        } catch {
            print("Could not fetch. \(error), \((error as NSError).userInfo)")
        }
        LoadingIndicator.shared.hideLoadingIndicator()
        return people
    }
    
    /// This mmethod will update a single core data entity
    ///
    /// - Parameter person: Object to be modified
    func updateObject(person: Person) {
    }
}
