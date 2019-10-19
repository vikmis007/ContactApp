//
//  AddContactService.swift
//  Contact
//
//  Created by vikas mishra on 19/10/19.
//  Copyright © 2019 vikas mishra. All rights reserved.
//

import Foundation
let ADD_CONTACT_URL = "/contacts.json"

class AddContactService {
    private let webService = WebService()
    
    func addContact(params: [String:Any], completion: @escaping (_ contact:Person?, _ errorMessage: APIErrorEnum?) -> ()) {
        webService.get(url: ADD_CONTACT_URL, params: params, httpMethod: "POST") { (data, error) in
            if let error = error {
                completion(nil, error)
            } else {
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                        if let jsonObj = json as? Any {
                            let person = Person(jsonObj: jsonObj as! [String : Any])
                            completion(person, nil)
                        }
                    } catch {
                        completion(nil, .APIError("Some error occurred"))
                    }
                }
            }
        }
    }
}
