//
//  UpdateContactService.swift
//  Contact
//
//  Created by vikas mishra on 19/10/19.
//  Copyright © 2019 vikas mishra. All rights reserved.
//

import Foundation


class UpdateContactService {
    private let webService = WebServiceManager()
    
    func updateContact(userId: Int32, params: [String:Any], completion: @escaping (_ contact:User?, _ errorMessage: APIErrorEnum?) -> ()) {
        let url = APIConstants.UPDATE_CONTACT_URL.replacingOccurrences(of: "{id}", with: String(userId))
        webService.get(url: url, params: params, httpMethod: "PUT") { (data, error) in
            if let error = error {
                completion(nil, error)
            } else {
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let user = try decoder.decode(User.self, from: data)
                        completion(user, nil)
                    } catch {
                        completion(nil, .APIError("Some error occurred"))
                    }
                }
            }
        }
    }
}
