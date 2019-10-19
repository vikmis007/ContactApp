//
//  AddEditViewModel.swift
//  Contact
//
//  Created by vikas mishra on 19/10/19.
//  Copyright © 2019 vikas mishra. All rights reserved.
//

import Foundation

protocol AddEditViewModelProtocol: class {
    func reloadUI()
}

enum PersonDataValidation {
    case Valid
    case Invalid(String)
}

class AddEditViewModel {
    weak var delegate: AddEditViewModelProtocol?
    internal var person: Person?
    internal var personNew: Person = Person()!
    internal var apiErrorMessage: APIErrorEnum?
    
    private let updateService = UpdateContactService()
    private let addService = AddContactService()
    
    func validate() ->PersonDataValidation {
        if personNew.firstName.isEmpty {
            return .Invalid("First Name is empty")
        }
        if personNew.lastName.isEmpty {
            return .Invalid("Last Name is empty")
        }
        if personNew.phone.isEmpty {
            return .Invalid("Mobile number is empty")
        }
        if personNew.email.isEmpty {
            return .Invalid("Email is empty")
        }
        if !Utils.isValidEmail(testStr: personNew.email) {
            return .Invalid("Email is invalid")
        }
        return .Valid
    }
    
    func addUpdateContactData(navigatedFromEdit: Bool) {
        apiErrorMessage = nil
        
        let params:[String:Any] = [
            "first_name": personNew.firstName,
            "last_name": personNew.lastName,
            "email": personNew.email,
            "phone_number": personNew.phone,
            "favorite": false
        ]
        
        if navigatedFromEdit {
            if person == personNew {
                self.delegate?.reloadUI()
            } else {
                updateService.updateContact(userId: personNew.id, params: params) { (person, errorEnum) in
                    if let msg = errorEnum {
                        self.apiErrorMessage = msg
                    } else {
                        self.person = person
                        CoreDataManager.shared.updateObject(person: person!)
                    }
                    self.delegate?.reloadUI()
                }
            }
        } else {
            addService.addContact(params: params) { (person, errorEnum) in
                if let msg = errorEnum {
                    self.apiErrorMessage = msg
                } else {
                    self.person = person
                    CoreDataManager.shared.insertObject(person: person!)
                }
                self.delegate?.reloadUI()
            }
        }
    }
}
