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
                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                        var list:[Person] = [Person]()
                        if let jsonArray = json as? [Any] {
                            for object in jsonArray {
                                let person = Person(jsonObj: object as! [String : Any])
                                list.append(person!)
                            }
                        }
                        completion(list, nil)
                    } catch {
                        completion(nil, .APIError("Some error occurred"))
                    }
                }
            }
        }
    }
}
