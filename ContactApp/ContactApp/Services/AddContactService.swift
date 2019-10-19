//
//  AddContactService.swift
//  Contact
//
//  Created by vikas mishra on 19/10/19.
//  Copyright © 2019 vikas mishra. All rights reserved.
//

import Foundation

class AddContactService {
    private let webService = WebServiceManager()
    
    func addContact(params: [String:Any], completion: @escaping (_ contact:User?, _ errorMessage: APIErrorEnum?) -> ()) {
        webService.get(url: APIConstants.SAVE_CONTACT_URL, params: params, httpMethod: APIConstants.HTTP_POST) { (data, error) in
            if let error = error {
                completion(nil, error)
            } else {
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let user = try decoder.decode(User.self, from: data)
                        completion(user, nil)
                    } catch {
                        completion(nil, .APIError(MessageConstant.ERROR_MESSAGE))
                    }
                }
            }
        }
    }
}
