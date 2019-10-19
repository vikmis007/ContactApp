//
//  ListViewController+NSFetchResultDelegate.swift
//  ContactApp
//
//  Created by Vikas Mishra on 20/10/19.
//  Copyright © 2019 Vikas Mishra. All rights reserved.
//

import Foundation
import CoreData

extension ListViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        do {
            try fetchedResultsController.performFetch()
            listTableView.reloadData()
        } catch {
            print(error)
        }
    }
}
