//
//  User.swift
//  Unswash
//
//  Created by Alexandre Barbier on 21/11/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//

import UIKit
struct UserLinks: Codable {
    var me: String?
    var html: String?
    var photos : String?
    var likes : String?
    var portfolio : String?
}

class User: Codable {
    var id: String?
    var username: String?
    var name: String?
    var bio: String?
    var links: UserLinks?
}
