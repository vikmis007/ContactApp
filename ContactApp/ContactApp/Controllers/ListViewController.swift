//
//  ViewController.swift
//  Contact
//
//  Created by vikas mishra on 19/10/19.
//  Copyright © 2019 vikas mishra. All rights reserved.
//

import UIKit
import Foundation
import CoreData

let listContactCellIdentifier = "ListTableViewCell";
let listTableCell = "ListTableViewCell"
let ADD_EDIT_IDENTIFIER = "addUserIdentifier"

class ListViewController: UIViewController {

    lazy var fetchedResultsController: NSFetchedResultsController<Person> = {
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "initial", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.persistentContainer.viewContext, sectionNameKeyPath: "initial", cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()

    /// To be injected in API call
    var urlSesssion: CAURLSession?

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

        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        getContactList()
    }
    
    private func registerCell() {
        listTableView.register(UINib(nibName: listTableCell, bundle: nil), forCellReuseIdentifier: listContactCellIdentifier)
    }

    /// This method will be used for configuring the controller everytimes it reappears in the memory
    func initialSetup() {
        refreshBtn.setTitle("\u{f01e} Refresh", for: .normal)
        refreshBtn.setTitleColor(Colors.getPrimaryColor(opacity: 1.0), for: .normal)
        refreshBtn.layer.borderWidth = 1.0
        refreshBtn.layer.borderColor = Colors.getPrimaryColor(opacity: 1.0).cgColor

        registerCell()

        viewModel = ListViewModel(urlSession: urlSesssion)
        viewModel?.delegate = self
    }

    func getContactList() {
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Unable to perform fetch: \(error.localizedDescription)")
        }

        if fetchedResultsController.sections?.count ?? 0 <= 0 {
            viewModel?.getContactList()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ADD_EDIT_IDENTIFIER {
            let addEditVC: AddEditViewController = segue.destination as! AddEditViewController
            addEditVC.isNavigatedForEdit = false
        }
    }
}

extension ListViewController: ListViewModelProtocol {
    func reloadUI() {
        if let msg = viewModel?.apiErrorMessage {
            switch(msg) {
                case .NoInternet:
                    errorLabel.text = MessageConstant.NO_INTERNET_MESSAGE
                case .APIError(let errorMsg):
                    errorLabel.text = errorMsg
            }
            errorView.isHidden = false
        }
    }
}

