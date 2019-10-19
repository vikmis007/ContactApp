//
//  DetailViewController.swift
//  Contact
//
//  Created by vikas mishra on 19/10/19.
//  Copyright © 2019 vikas mishra. All rights reserved.
//

import UIKit
import MessageUI

class DetailViewController: UIViewController {

    var personId: Int32?
    private var viewModel: DetailViewModel?
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var messageBtn: UIButton!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var emailBtn: UIButton!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullName: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    
    
    @IBOutlet weak var errorView: UIView!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var refreshBtn: UIButton!
    
    @IBAction func refreshBtnTapped(_ sender: UIButton) {
        errorView.isHidden = true
        viewModel?.getContactDetail(userId: personId ?? 0)
    }
    @IBAction func messageBtnTapped(_ sender: UIButton) {
        sendTextMessage(phoneNumber: (viewModel?.user?.phoneNumber)!)
    }
    
    @IBAction func callBtnTapped(_ sender: UIButton) {
        let phoneNumber = "tel://\((viewModel?.user?.phoneNumber)!)"
        UIApplication.shared.open(URL(string: phoneNumber)!, options: [:], completionHandler: nil)
    }
    
    @IBAction func emailBtnTapped(_ sender: UIButton) {
        sendEmail(recipient: (viewModel?.user?.email)!)
    }
    
    @IBAction func favoriteBtnTapped(_ sender: UIButton) {
        let isFavorite = viewModel?.user?.favorite
        viewModel?.toggleFavorite(userId: personId ?? 0, isFavorite: !(isFavorite!))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        viewModel = DetailViewModel()
        viewModel?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.getContactDetail(userId: personId ?? 0)
    }
    
    func setupUI() {
        //To remove border from navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = Colors.getPrimaryColor(opacity: 1.0)
        
        headerView.backgroundColor = UIColor.clear
        let backgroundLayer = Colors.shared.gl
        backgroundLayer.frame = headerView.frame
        headerView.layer.insertSublayer(backgroundLayer, at: 0)
        
        messageBtn.layer.cornerRadius = 18.0
        messageBtn.titleLabel!.font = UIFont(name:"Font Awesome 5 Free", size: 20.0)
        messageBtn.setTitle("\u{f075}", for: .normal)
        messageBtn.setTitleColor(UIColor.white, for: .normal)
        messageBtn.backgroundColor = Colors.getPrimaryColor(opacity: 1.0)
        
        callBtn.layer.cornerRadius = 18.0
        callBtn.titleLabel!.font = UIFont(name:"Font Awesome 5 Free", size: 20.0)
        callBtn.setTitle("\u{f095}", for: .normal)
        callBtn.setTitleColor(UIColor.white, for: .normal)
        callBtn.backgroundColor = Colors.getPrimaryColor(opacity: 1.0)
        
        emailBtn.layer.cornerRadius = 18.0
        emailBtn.titleLabel!.font = UIFont(name:"Font Awesome 5 Free", size: 20.0)
        emailBtn.setTitle("\u{f0e0}", for: .normal)
        emailBtn.setTitleColor(UIColor.white, for: .normal)
        emailBtn.backgroundColor = Colors.getPrimaryColor(opacity: 1.0)
        
        favoriteBtn.layer.cornerRadius = 18.0
        favoriteBtn.titleLabel!.font = UIFont(name:"Font Awesome 5 Free", size: 20.0)
        favoriteBtn.setTitle("\u{f005}", for: .normal)
        favoriteBtn.setTitleColor(UIColor.white, for: .normal)
        favoriteBtn.backgroundColor = Colors.backgroundColor()
     
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true;
        profileImage.layer.borderWidth = 3.0
        profileImage.layer.borderColor = UIColor.white.cgColor
    }
    
    @objc func editBtnTapped() {
//        let addEditVC: AddEditViewController? = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddEditViewController") as? AddEditViewController
//        addEditVC?.personOrig = viewModel?.person
//        addEditVC?.isNavigatedForEdit = true
//        self.present(addEditVC!, animated: true, completion: nil)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension DetailViewController: DetailViewModelProtocol {
    func updateUI() {
        if let msg = viewModel?.apiErrorMessage {
            switch(msg) {
            case .NoInternet:
                errorLabel.text = "No internet !!"
            case .APIError(let errorMsg):
                errorLabel.text = errorMsg
            }
            errorView.isHidden = false
        } else {
            self.profileImage.cacheImage(urlString: viewModel?.user?.profilePic ?? "")
            self.fullName.text = viewModel?.user?.fullName
            self.emailLabel.text = viewModel?.user?.email
            self.mobileLabel.text =  viewModel?.user?.phoneNumber
            if viewModel?.user?.favorite ?? false {
                favoriteBtn.backgroundColor = Colors.getPrimaryColor(opacity: 1.0)
            } else {
                favoriteBtn.backgroundColor = Colors.backgroundColor()
            }
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editBtnTapped))
        }
    }
}

extension DetailViewController: MFMessageComposeViewControllerDelegate {
    func sendTextMessage(phoneNumber: String) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = ""
            controller.recipients = [phoneNumber]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension DetailViewController: MFMailComposeViewControllerDelegate {
    func sendEmail(recipient: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([recipient])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            showAlert(title: "", message: "Can not send mails.")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
