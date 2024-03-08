//
//  User.swift
//  RenderingImaged
//
//  Created by Maktumhusen on 08/03/24.
//

import Foundation

class User {
    let id: Int
    let email: String
    let first_name: String
    let last_name: String
    let avatar_url: String
    
    init(id: Int, email: String, first_name: String, last_name: String, avatar_url: String) {
        self.id = id
        self.email = email
        self.first_name = first_name
        self.last_name = last_name
        self.avatar_url = avatar_url
    }
}
