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
        favoriteBtn.titleLabel!.font = UIFont(name:"Font Awesome 5 Free", size: 14.0)
        favoriteBtn.setTitle("\u{f005}", for: .normal)
        favoriteBtn.setTitleColor(Colors.getPrimaryColor(opacity: 1.0), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension ListTableViewCell {
    func updateCell(person: Person) {
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
        self.profileImage.cacheImage(urlString: "\(BASE_URL)\(person.profile_pic)")
        fullName.text = person.fullName
        favoriteBtn.isHidden = !person.favorite
    }
}
