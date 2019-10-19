//
//  WebService.swift
//  Contact
//
//  Created by vikas mishra on 19/10/19.
//  Copyright © 2019 vikas mishra. All rights reserved.
//

import Foundation
import UIKit

enum APIErrorEnum {
    case NoInternet
    case APIError(String)
}

class WebServiceManager {
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    func get(url:String, params:[String:Any]?, httpMethod: String ,completionHandler:@escaping (_ data: Data?, _ error: APIErrorEnum?) -> ()) {
        
        if(!Reachability.isConnectedToNetwork()) {
            completionHandler(nil, .NoInternet)
        } else {
            let url = URL(string: "\(APIConstants.BASE_URL)\(url)")
            var urlRequest = URLRequest(url: url!)
            urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            urlRequest.httpMethod = httpMethod;
            if let _ = params {
                do {
                    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params!, options: [])
                } catch {
                    completionHandler(nil, .APIError(MessageConstant.PARSER_ERROR))
                }
            }
            LoadingIndicator.shared.showLoadingIndicator()
            DispatchQueue.global(qos: .default).async {
                self.dataTask = self.defaultSession.dataTask(with: urlRequest) { data, response, error in
                    defer { self.dataTask = nil }
                    if let error = error {
                        DispatchQueue.main.async {
                            LoadingIndicator.shared.hideLoadingIndicator()
                            completionHandler(nil, .APIError(error.localizedDescription))
                        }
                    }
                    let response = response as? HTTPURLResponse
                    if response?.statusCode == 404 {
                        DispatchQueue.main.async {
                            LoadingIndicator.shared.hideLoadingIndicator()
                            completionHandler(nil, .APIError("Not Found"))
                        }
                    } else if response?.statusCode == 422 {
                        DispatchQueue.main.async {
                            LoadingIndicator.shared.hideLoadingIndicator()
                            completionHandler(nil, .APIError("Validation Errors"))
                        }
                    } else if response?.statusCode == 500 {
                        DispatchQueue.main.async {
                            LoadingIndicator.shared.hideLoadingIndicator()
                            completionHandler(nil, .APIError("Internal Server Error"))
                        }
                    }
                    
                    if let data = data,
                        let response = response,
                        response.statusCode == 200 || response.statusCode == 201 {
                        DispatchQueue.main.async {
                            LoadingIndicator.shared.hideLoadingIndicator()
                            completionHandler(data, nil)
                        }
                    }
                }
                self.dataTask?.resume()
            }
        }
    }
}

