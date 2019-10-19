//
//  APIConstants.swift
//  ContactApp
//
//  Created by Vikas Mishra on 19/10/19.
//  Copyright © 2019 Vikas Mishra. All rights reserved.
//

import Foundation

struct APIConstants {

    /// URL HOST
    static let BASE_URL = "http://gojek-contacts-app.herokuapp.com"

    ///URL Endpoints
    static let GET_CONTACTS = "/contacts.json"
    static let DETAIL_CONTACT_URL = "/contacts/{id}.json"
    static let UPDATE_CONTACT_URL = "/contacts/{id}.json"
    static let SAVE_CONTACT = "/contacts.json"

    /// HTTP Methods:
    static  let GET = "GET"
    static  let POST = "POST"
    static  let PUT = "PUT"
}
