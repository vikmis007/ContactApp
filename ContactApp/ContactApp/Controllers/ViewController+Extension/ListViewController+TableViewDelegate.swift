//
//  ListViewController+TableViewDelegate.swift
//  ContactApp
//
//  Created by Vikas Mishra on 20/10/19.
//  Copyright © 2019 Vikas Mishra. All rights reserved.
//

import Foundation
import UIKit

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = fetchedResultsController.object(at: indexPath)
        let detailVC: DetailViewController? = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        detailVC?.personId = person.id
        self.navigationController?.pushViewController(detailVC!, animated: true)
    }
}
