//
//  ListTableViewCell.swift
//  Contact
//
//  Created by vikas mishra on 19/10/19.
//  Copyright © 2019 vikas mishra. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        profileImage.layer.cornerRadius = profileImage.frame.size.height/2
    }
    
}

extension ListTableViewCell {
    func updateCell(person: Person?) {
        //TODO: check null for image
        
//        DispatchQueue.global(qos: .userInitiated).async {
//            do {
//                let data = try Data(contentsOf: URL(string: "\(BASE_URL)\(person.profilePic)")!)
//                DispatchQueue.main.async {
//                    self.profileImage.cacheImage(urlString: "\(BASE_URL)\(person.profilePic)")
//                }
//            } catch {
//                print("error while loading profile pic")
//            }
//        }
        guard let person = person else {
            return
        }
        if let profilePicUrl = person.profile_pic {
            profileImage.cacheImage(urlString: "\(BASE_URL)\(profilePicUrl)")
        } else {
            profileImage.image = UIImage(named: AssetsConstant.PHOTO_PLACEHOLDER)
        }
        if person.favorite {
            favoriteBtn.isSelected = true
        } else {
            favoriteBtn.isSelected = false
        }
        fullName.text = person.fullName
        favoriteBtn.isHidden = !person.favorite
    }
}
