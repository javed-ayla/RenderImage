//
//  UserCollectionViewCell.swift
//  RenderingImaged
//
//  Created by Maktumhusen on 08/03/24.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    /// Setup Cell Data
    func setupData(userData: User) {
        idLabel.text = String(userData.id)
        emailLabel.text = userData.email
        firstNameLabel.text = userData.first_name.appending(" \(userData.last_name)")
        lastNameLabel.text = "" //userData.last_name
        
        if let url = URL(string: userData.avatar_url) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.avatarImageView.image = image
                    }
                }
            }
            task.resume()
        }
    }
}
