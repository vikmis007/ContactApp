//
//  UpdateContactService.swift
//  Contact
//
//  Created by vikas mishra on 19/10/19.
//  Copyright © 2019 vikas mishra. All rights reserved.
//

import Foundation

/// Service class to handle API operations related to Update in the contact data
class UpdateContactService {
    private let webService = WebServiceManager()


    /// This method will update data in server as well as in local database
    ///
    /// - Parameters:
    ///   - userId: userId for which data has to be saved
    ///   - params: data payload in key value pairs
    ///   - completion: completion handler
    func updateContact(userId: Int32, params: [String:Any], completion: @escaping (_ contact:User?, _ errorMessage: APIErrorEnum?) -> ()) {
        let url = APIConstants.UPDATE_CONTACT_URL.replacingOccurrences(of: "{id}", with: String(userId))
        webService.get(url: url, params: params, httpMethod: APIConstants.HTTP_PUT) { (data, error) in
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
