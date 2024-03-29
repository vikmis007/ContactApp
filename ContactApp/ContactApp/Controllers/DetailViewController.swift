//
//  DetailViewController.swift
//  Contact
//
//  Created by vikas mishra on 19/10/19.
//  Copyright © 2019 vikas mishra. All rights reserved.
//

import UIKit
import MessageUI

let ADD_EDIT_VIEWCONTROLLER_IDENTIFIER = "AddEditViewController"

class DetailViewController: UIViewController {

    var personId: Int32?
    var viewModel: DetailViewModel?
    
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

    /// To be injected in API call
    var urlSesssion: CAURLSession?

    //MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.getContactDetail(userId: personId ?? 0)
    }

    //MARK: - IBActions
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

    @objc func editBtnTapped() {
        let addEditVC: AddEditViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ADD_EDIT_VIEWCONTROLLER_IDENTIFIER) as! AddEditViewController
        addEditVC.userOrig = viewModel?.user
        addEditVC.isNavigatedForEdit = true
        self.present(addEditVC, animated: true, completion: nil)
    }

    func getPrimaryColor(opacity: CGFloat) -> UIColor {
        return UIColor(red: 80.0/255.0, green: 227.0/255.0, blue: 194.0/255.0, alpha: opacity);
    }

    func initialSetup() {
        setupUI()
        setupViewModel()
    }

    private func setupViewModel() {
        viewModel = DetailViewModel(urlSession: urlSesssion)
        viewModel?.delegate = self
    }

    private func setupUI() {
        //To remove border from navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = Colors.getPrimaryColor(opacity: 1.0)
        
        headerView.backgroundColor = UIColor.clear

        let colorTop = UIColor.white.cgColor
        let colorBottom = getPrimaryColor(opacity: 0.28).cgColor
        let colorGradient: CAGradientLayer =  CAGradientLayer()
        colorGradient.colors = [ colorTop, colorBottom]
        colorGradient.locations = [ 0.0, 1.0]
        colorGradient.frame = headerView.frame
        headerView.layer.insertSublayer(colorGradient, at: 0)
        
        messageBtn.layer.cornerRadius = 18.0
        callBtn.layer.cornerRadius = 18.0
        emailBtn.layer.cornerRadius = 18.0
        favoriteBtn.layer.cornerRadius = 18.0
     
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true;
        profileImage.layer.borderWidth = 3.0
        profileImage.layer.borderColor = UIColor.white.cgColor
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
                errorLabel.text = MessageConstant.NO_INTERNET_MESSAGE
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
                favoriteBtn.isSelected = true
            } else {
                favoriteBtn.isSelected = false
            }
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: MessageConstant.EDIT_TITLE, style: .plain, target: self, action: #selector(editBtnTapped))
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

//MARK: - EXtensions to avail device services
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
