//
//  DetailContactService.swift
//  Contact
//
//  Created by vikas mishra on 19/10/19.
//  Copyright © 2019 vikas mishra. All rights reserved.
//

import Foundation
let DETAIL_CONTACT_URL = "/contacts/{id}.json"

class DetailContactService{
    private let webService = WebService()
    
    func getContactDetail(userId: Int, completion: @escaping (_ contact:Person?, _ errorMessage: APIErrorEnum?) -> ()) {
        let url = DETAIL_CONTACT_URL.replacingOccurrences(of: "{id}", with: String(userId))
        webService.get(url: url, params: nil, httpMethod: "GET") { (data, error) in
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
