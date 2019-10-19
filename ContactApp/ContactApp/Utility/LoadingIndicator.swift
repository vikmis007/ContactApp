//
//  LoadingIndicator.swift
//  Contact
//
//  Created by vikas mishra on 19/10/19.
//  Copyright © 2019 vikas mishra. All rights reserved.
//

import Foundation
import UIKit

class LoadingIndicator {
    
    static let shared = LoadingIndicator()
    
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var activityIndicator: UIActivityIndicatorView?
    
    private init() {
        activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator?.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator?.center = (appDelegate.window?.rootViewController?.view.center)!
        activityIndicator?.hidesWhenStopped = true
        appDelegate.window?.rootViewController?.view.addSubview(activityIndicator!)
        appDelegate.window?.rootViewController?.view.bringSubviewToFront(activityIndicator!)
        
    }
    
    func showLoadingIndicator() {
        activityIndicator?.startAnimating()
    }
    func hideLoadingIndicator() {
        activityIndicator?.stopAnimating()
    }
}
