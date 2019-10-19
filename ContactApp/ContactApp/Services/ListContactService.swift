//
//  ListContactService.swift
//  Contact
//
//  Created by vikas mishra on 19/10/19.
//  Copyright © 2019 vikas mishra. All rights reserved.
//

import Foundation

/// Service class to handle API operations related to List Contact module
class ListContactService {

    private let webService = WebServiceManager()

    /// This method will bring all the contact availble in the database
    ///
    /// - Parameter completion: completion handler to return contact list
    func getContactList(completion: @escaping (_ contacts:[Person]?, _ errorMessage: APIErrorEnum?) -> ()) {
        webService.get(url: APIConstants.GET_CONTACTS, params: nil, httpMethod: APIConstants.GET_CONTACTS) { (data, error) in
            if let error = error {
                completion(nil, error)
            } else {
                if let data = data {
                    do {
                        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.context else {
                            fatalError(MessageConstant.FATAL_ERROR_OCCURED)
                        }
                        let managedObjectContext = CoreDataStack.shared.persistentContainer.viewContext
                        let decoder = JSONDecoder()
                        decoder.userInfo[codingUserInfoKeyManagedObjectContext] = managedObjectContext
                        _ = try decoder.decode([Person].self, from: data)
                        try managedObjectContext.save()
                        completion(nil, nil)
                    } catch {
                        completion(nil, .APIError(MessageConstant.ERROR_MESSAGE))
                    }
                }
            }
        }
    }
}
