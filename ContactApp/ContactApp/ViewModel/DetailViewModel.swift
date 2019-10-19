//
//  DetailViewModel.swift
//  Contact
//
//  Created by vikas mishra on 19/10/19.
//  Copyright © 2019 vikas mishra. All rights reserved.
//

import Foundation

protocol DetailViewModelProtocol: class {
    func updateUI()
}

class DetailViewModel {
    internal var person: Person?
    internal var apiErrorMessage: APIErrorEnum?
    
    weak var delegate: DetailViewModelProtocol?
    private let detailService = DetailContactService()
    private let updateService = UpdateContactService()
    
    func getContactDetail(userId: Int32) {
        detailService.getContactDetail(userId: userId) { (person, errorEnum) in
            if let msg = errorEnum {
                self.apiErrorMessage = msg
            } else {
                self.person = person
            }
            self.delegate?.updateUI()
        }
    }
    
    func toggleFavorite(userId: Int, isFavorite: Bool) {
        let param:[String:Bool] = ["favorite": isFavorite]
        updateService.updateContact(userId: userId, params: param) { (person, errorEnum) in
            if let msg = errorEnum {
                self.apiErrorMessage = msg
            } else {
                self.person = person
                CoreDataManager.shared.updateObject(person: self.person!)
            }
            self.delegate?.updateUI()
        }
    }
}
