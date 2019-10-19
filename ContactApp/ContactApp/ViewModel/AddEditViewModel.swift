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
    internal var user: User?
    internal var newUser: User = User()
    internal var apiErrorMessage: APIErrorEnum?
    
    private let updateService = UpdateContactService()
    private let addService = AddContactService()
    
    func validate() ->PersonDataValidation {
        if newUser.firstName == nil {
            return .Invalid("First Name is empty")
        }
        if newUser.lastName == nil {
            return .Invalid("Last Name is empty")
        }
        if newUser.phoneNumber == nil {
            return .Invalid("Mobile number is empty")
        }
        if newUser.email == nil {
            return .Invalid("Email is empty")
        }
        if !Utils.isValidEmail(testStr: newUser.email!) {
            return .Invalid("Email is invalid")
        }
        return .Valid
    }
    
    func addUpdateContactData(navigatedFromEdit: Bool) {
        apiErrorMessage = nil

        let params:[String:Any] = [
            "first_name": newUser.firstName!,
            "last_name": newUser.lastName!,
            "email": newUser.email!,
            "phone_number": newUser.phoneNumber!,
            "favorite": false
        ]
        
        if navigatedFromEdit {
            if user == newUser {
                self.delegate?.reloadUI()
            } else {
                updateService.updateContact(userId: newUser.id!, params: params) { (user, errorEnum) in
                    if let msg = errorEnum {
                        self.apiErrorMessage = msg
                    } else {
                        self.user = user
                        CoreDataManager.shared.updateObject(user: user!)
                    }
                    self.delegate?.reloadUI()
                }
            }
        } else {
            addService.addContact(params: params) { (user, errorEnum) in
                if let msg = errorEnum {
                    self.apiErrorMessage = msg
                } else {
                    CoreDataManager.shared.insertObject(user: user!)
                }
                self.delegate?.reloadUI()
            }
        }
    }
}
