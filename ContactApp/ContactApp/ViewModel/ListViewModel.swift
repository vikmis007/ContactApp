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

    
    func getContactList() {
        apiErrorMessage = nil
        listService.getContactList { (persons, errorEnum) in
            if let msg = errorEnum {
                self.apiErrorMessage = msg
                self.delegate?.reloadUI()
            }
        }
    }
}
