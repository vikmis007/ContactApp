//
//  UpdateContactService.swift
//  Contact
//
//  Created by vikas mishra on 19/10/19.
//  Copyright © 2019 vikas mishra. All rights reserved.
//

import Foundation
let UPDATE_CONTACT_URL = "/contacts/{id}.json"

class UpdateContactService {
    private let webService = WebServiceManager()
    
    func updateContact(userId: Int, params: [String:Any], completion: @escaping (_ contact:Person?, _ errorMessage: APIErrorEnum?) -> ()) {
        let url = UPDATE_CONTACT_URL.replacingOccurrences(of: "{id}", with: String(userId))
        webService.get(url: url, params: params, httpMethod: "PUT") { (data, error) in
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
