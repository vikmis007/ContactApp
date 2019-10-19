//
//  ListViewModel.swift
//  Contact
//
//  Created by vikas mishra on 19/10/19.
//  Copyright © 2019 vikas mishra. All rights reserved.
//

import Foundation
import CoreData

protocol ListViewModelProtocol: class {
    func reloadUI()
}

class ListViewModel {
    internal var apiErrorMessage: APIErrorEnum?
    weak var delegate: ListViewModelProtocol?
    private let listService = ListContactService()

    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Person> = {
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "first_name", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.persistentContainer.viewContext, sectionNameKeyPath: "first_name", cacheName: nil)
        return fetchedResultsController
    }()

    
    func getContactList() {
        apiErrorMessage = nil

        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Unable to perform fetch: \(error.localizedDescription)")
        }

        if let sections = fetchedResultsController.sections, !sections.isEmpty {
            self.delegate?.reloadUI()
        } else {
            listService.getContactList { (persons, errorEnum) in
                if let msg = errorEnum {
                    self.apiErrorMessage = msg
                    self.delegate?.reloadUI()
                } else {
                    CoreDataManager.shared.insertObjects(persons: persons!)
                    self.persons = persons
                    self.organiseDataToSortedDict()
                }
            }
        }
    }
}
