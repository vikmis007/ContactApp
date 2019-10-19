//
//  ListViewController+TableViewDatasource.swift
//  ContactApp
//
//  Created by Vikas Mishra on 20/10/19.
//  Copyright © 2019 Vikas Mishra. All rights reserved.
//

import UIKit
import Foundation

extension ListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            if sections.count > 0 {
                return sections.count
            }
        }
        return 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultsController.sections![section].indexTitle
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ListTableViewCell = listTableView.dequeueReusableCell(withIdentifier: listContactCellIdentifier) as! ListTableViewCell

        let person = fetchedResultsController.object(at: indexPath)
        cell.updateCell(person: person)
        return cell
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return fetchedResultsController.sectionIndexTitles
    }

    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return fetchedResultsController.section(forSectionIndexTitle: title, at: index) ?? 0
    }
}
