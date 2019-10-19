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

    /// This variable will track navigation source if this view-contrller (optionally => `Add` OR `Edit`)
    internal var isNavigatedForEdit: Bool = false

    /// This will hold original data when source navigation is edit
    var userOrig: User?
    
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

    //MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        viewModel = AddEditViewModel()
        viewModel?.delegate = self

        if(isNavigatedForEdit) {
            viewModel?.user = userOrig
            viewModel?.newUser = userOrig!

            firstNameTextfield.text = userOrig?.firstName
            lastNameTextfield.text = userOrig?.lastName
            mobileTextfield.text = userOrig?.phoneNumber
            emailTextfield.text = userOrig?.email
        }

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    //MARK: - IBActions
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
    
    private func setupUI() {
        headerView.backgroundColor = UIColor.clear
        let colorTop = UIColor.white.cgColor
        let colorBottom = Colors.getPrimaryColor(opacity: 0.28).cgColor
        let colorGradient: CAGradientLayer =  CAGradientLayer()
        colorGradient.colors = [ colorTop, colorBottom]
        colorGradient.locations = [ 0.0, 1.0]
        colorGradient.frame = headerView.frame
        headerView.layer.insertSublayer(colorGradient, at: 0)
        colorGradient.frame = headerView.frame
        headerView.layer.insertSublayer(colorGradient, at: 0)
        
        profilePicImageView.layer.cornerRadius = profilePicImageView.frame.size.width/2
        profilePicImageView.clipsToBounds = true;
        profilePicImageView.layer.borderWidth = 3.0
        profilePicImageView.layer.borderColor = UIColor.white.cgColor
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: MessageConstant.OK_TITLE, style: .default, handler: nil)
        alert.addAction(okAction)
        self.show(alert, sender: nil)
    }
    
}

extension AddEditViewController: AddEditViewModelProtocol {
    func reloadUI() {
        if let msg = viewModel?.apiErrorMessage {
            switch(msg) {
            case .NoInternet:
                showAlert(title: MessageConstant.EMPTY_STRING, message: MessageConstant.NO_INTERNET_MESSAGE)
            case .APIError(let errorMsg):
                showAlert(title: MessageConstant.EMPTY_STRING, message: errorMsg)
            }
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
