//
//  ListContactService.swift
//  Contact
//
//  Created by vikas mishra on 19/10/19.
//  Copyright © 2019 vikas mishra. All rights reserved.
//

import Foundation
let LIST_CONTACT_URL = "/contacts.json"

class ListContactService {
    private let webService = WebServiceManager()
    
    func getContactList(completion: @escaping (_ contacts:[Person]?, _ errorMessage: APIErrorEnum?) -> ()) {
        webService.get(url: LIST_CONTACT_URL, params: nil, httpMethod: "GET") { (data, error) in
            if let error = error {
                completion(nil, error)
            } else {
                if let data = data {
                    do {
                        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.context else {
                            fatalError("Failed to retrieve context")
                        }
                        let managedObjectContext = CoreDataStack.shared.persistentContainer.viewContext
                        let decoder = JSONDecoder()
                        decoder.userInfo[codingUserInfoKeyManagedObjectContext] = managedObjectContext
                        _ = try decoder.decode([Person].self, from: data)
                        try managedObjectContext.save()
                        completion(nil, nil)
                    } catch {
                        completion(nil, .APIError("Some error occurred"))
                    }
                }
            }
        }
    }
}
