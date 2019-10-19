//
//  ViewController.swift
//  Contact
//
//  Created by vikas mishra on 19/10/19.
//  Copyright © 2019 vikas mishra. All rights reserved.
//

import UIKit
import Foundation

let listContactCellIdentifier = "ListTableViewCell";
let ADD_EDIT_IDENTIFIER = "addUserIdentifier"

class ListViewController: UIViewController {
    private var viewModel: ListViewModel?
    
    
    @IBOutlet weak var errorView: UIView!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var refreshBtn: UIButton!
    @IBOutlet weak var listTableView: UITableView!
    
    @IBAction func refreshBtnTapped(_ sender: UIButton) {
        errorView.isHidden = true
        viewModel?.getContactList()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshBtn.titleLabel!.font = UIFont(name:"Font Awesome 5 Free", size: 14.0)
        refreshBtn.setTitle("\u{f01e} Refresh", for: .normal)
        refreshBtn.setTitleColor(Colors.getPrimaryColor(opacity: 1.0), for: .normal)
        refreshBtn.layer.borderWidth = 1.0
        refreshBtn.layer.borderColor = Colors.getPrimaryColor(opacity: 1.0).cgColor
        
        registerCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel = ListViewModel()
        viewModel?.delegate = self
        viewModel?.getContactList()
    }
    
    func registerCell() {
        listTableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: listContactCellIdentifier)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //TODO: - Fix this
//        if segue.identifier == ADD_EDIT_IDENTIFIER {
//            let addEditVC: AddEditViewController = segue.destination as! AddEditViewController
//            addEditVC.isNavigatedForEdit = false
//        }
    }
}

extension ListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = viewModel?.fetchedResultsController.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel?.fetchedResultsController.sections![section].indexTitle
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = viewModel?.fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ListTableViewCell = listTableView.dequeueReusableCell(withIdentifier: listContactCellIdentifier) as! ListTableViewCell

        let person = viewModel?.fetchedResultsController.object(at: indexPath)
        cell.updateCell(person: person)
        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return viewModel?.fetchedResultsController.sectionIndexTitles
    }

    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return viewModel?.fetchedResultsController.section(forSectionIndexTitle: title, at: index) ?? 0
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = viewModel?.fetchedResultsController.object(at: indexPath)
        let detailVC: DetailViewController? = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        detailVC?.personId = person.id
        self.navigationController?.pushViewController(detailVC!, animated: true)
    }
}

extension ListViewController: ListViewModelProtocol {
    func reloadUI() {
        if let msg = viewModel?.apiErrorMessage {
            switch(msg) {
                case .NoInternet:
                    errorLabel.text = "No internet !!"
                case .APIError(let errorMsg):
                    errorLabel.text = errorMsg
            }
            errorView.isHidden = false
        }
        listTableView.reloadData()
    }
}

