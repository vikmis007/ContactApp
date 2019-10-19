//
//  AddEditViewController+KeyboardLookup.swift
//  ContactApp
//
//  Created by Vikas Mishra on 20/10/19.
//  Copyright © 2019 Vikas Mishra. All rights reserved.
//

import Foundation
import UIKit

extension AddEditViewController {

    @objc func keyboardWillShow(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 100
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
