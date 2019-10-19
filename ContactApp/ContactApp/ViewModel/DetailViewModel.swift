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
    internal var user: User?
    internal var apiErrorMessage: APIErrorEnum?
    
    weak var delegate: DetailViewModelProtocol?
    private let detailService = DetailContactService()
    private let updateService = UpdateContactService()
    
    func getContactDetail(userId: Int32) {
        detailService.getContactDetail(userId: userId) { (user, errorEnum) in
            if let msg = errorEnum {
                self.apiErrorMessage = msg
            } else {
                self.user = user
            }
            self.delegate?.updateUI()
        }
    }
    
    func toggleFavorite(userId: Int32, isFavorite: Bool) {
        let param:[String:Bool] = ["favorite": isFavorite]
        updateService.updateContact(userId: userId, params: param) { (user, errorEnum) in
            if let msg = errorEnum {
                self.apiErrorMessage = msg
            } else {
                self.user = user
                //TODO: - Update in local DB
            }
            self.delegate?.updateUI()
        }
    }
}
