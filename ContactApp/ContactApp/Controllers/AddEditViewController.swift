//
//  AddEditViewController.swift
//  Contact
//
//  Created by vikas mishra on 19/10/19.
//  Copyright © 2019 vikas mishra. All rights reserved.
//

import UIKit

let FIRST_NAME_FIELD_TAG = 101
let LAST_NAME_FIELD_TAG = 102
let MOBILE_FIELD_TAG = 103
let EMAIL_FIELD_TAG = 104


class AddEditViewController: UIViewController {

    var viewModel: AddEditViewModel?
    internal var isNavigatedForEdit: Bool = false
    var personOrig: Person?
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var uploadProfilePicBtn: UIButton!
    
    @IBOutlet weak var firstNameTextfield: UITextField!
    @IBOutlet weak var lastNameTextfield: UITextField!
    @IBOutlet weak var mobileTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    
    @IBOutlet weak var firstNameErrorLabel: UILabel!
    @IBOutlet weak var lastNameErrorLabel: UILabel!
    @IBOutlet weak var mobileErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    
    
    @IBAction func viewTapped(_ sender: Any) {
        view.endEditing(true)
    }
    
    
    @IBAction func doneBtnTapped(_ sender: Any) {
        let validityStatus: PersonDataValidation =  (viewModel?.validate())!
        switch(validityStatus) {
            case .Valid:
                viewModel?.addUpdateContactData(navigatedFromEdit: isNavigatedForEdit)
        case .Invalid(let errorMesg):
            showAlert(title: "", message: errorMesg)
        }
    }
    
    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        viewModel = AddEditViewModel()
        viewModel?.delegate = self
        
        if(isNavigatedForEdit) {
            viewModel?.person = personOrig
            viewModel?.personNew = personOrig!
            
            firstNameTextfield.text = personOrig?.firstName
            lastNameTextfield.text = personOrig?.lastName
            mobileTextfield.text = personOrig?.phone
            emailTextfield.text = personOrig?.email
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupUI() {
        headerView.backgroundColor = UIColor.clear
        let backgroundLayer = Colors.shared.gl
        backgroundLayer.frame = headerView.frame
        headerView.layer.insertSublayer(backgroundLayer, at: 0)
        
        profilePicImageView.layer.cornerRadius = profilePicImageView.frame.size.width/2
        profilePicImageView.clipsToBounds = true;
        profilePicImageView.layer.borderWidth = 3.0
        profilePicImageView.layer.borderColor = UIColor.white.cgColor
        
        uploadProfilePicBtn.layer.cornerRadius = 15.0
        uploadProfilePicBtn.titleLabel!.font = UIFont(name:"Font Awesome 5 Free", size: 20.0)
        uploadProfilePicBtn.setTitle("\u{f030}", for: .normal)
        uploadProfilePicBtn.setTitleColor(Colors.getPrimaryColor(opacity: 1.0), for: .normal)
        uploadProfilePicBtn.backgroundColor = UIColor.white
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.show(alert, sender: nil)
    }
    
}

extension AddEditViewController: AddEditViewModelProtocol {
    func reloadUI() {
        if let msg = viewModel?.apiErrorMessage {
            switch(msg) {
            case .NoInternet:
                showAlert(title: "", message: "No internet !!")
            case .APIError(let errorMsg):
                showAlert(title: "", message: errorMsg)
            }
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension AddEditViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("test")
    }
    
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
            viewModel?.personNew.firstName = textField.text ?? "test"
        } else if textField.tag == LAST_NAME_FIELD_TAG {
            viewModel?.personNew.lastName = textField.text ?? ""
        } else if textField.tag == MOBILE_FIELD_TAG {
            viewModel?.personNew.phone = textField.text ?? ""
        } else if textField.tag == EMAIL_FIELD_TAG {
            viewModel?.personNew.email = textField.text ?? ""
        }
    }
}

extension AddEditViewController {
    //KeyPad related methods
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
