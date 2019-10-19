//
//  DetailContactService.swift
//  Contact
//
//  Created by vikas mishra on 19/10/19.
//  Copyright © 2019 vikas mishra. All rights reserved.
//

import Foundation

/// Service class to handle API operations related to Contact detail Module
class DetailContactService{

    private let webService = WebServiceManager()

    /// This method will fetch contact detail related to contact id from API
    ///
    /// - Parameters:
    ///   - userId: userid for which contact detail is needed
    ///   - completion: completion handler
    func getContactDetail(userId: Int32, completion: @escaping (_ contact:User?, _ errorMessage: APIErrorEnum?) -> ()) {
        let url = APIConstants.DETAIL_CONTACT_URL.replacingOccurrences(of: "{id}", with: String(userId))
        webService.get(url: url, params: nil, httpMethod: APIConstants.HTTP_GET) { (data, error) in
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
