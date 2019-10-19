//
//  AddEditViewController+UITextFieldDelegate.swift
//  ContactApp
//
//  Created by Vikas Mishra on 20/10/19.
//  Copyright © 2019 Vikas Mishra. All rights reserved.
//

import Foundation
import UIKit

extension AddEditViewController: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        updateUserData(textField: textField)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        updateUserData(textField: textField)
        return false
    }

    func updateUserData(textField: UITextField) {
        if textField.tag == FIRST_NAME_FIELD_TAG {
            viewModel?.newUser.firstName = textField.text
        } else if textField.tag == LAST_NAME_FIELD_TAG {
            viewModel?.newUser.lastName = textField.text
        } else if textField.tag == MOBILE_FIELD_TAG {
            viewModel?.newUser.phoneNumber = textField.text
        } else if textField.tag == EMAIL_FIELD_TAG {
            viewModel?.newUser.email = textField.text
        }
    }
}
