//
//  User.swift
//  Unswash
//
//  Created by Alexandre Barbier on 21/11/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//

import UIKit
/*
 "id": "pXhwzz1JtQU",
 "username": "poorkane",
 "name": "Gilbert Kane",
 "portfolio_url": "https://theylooklikeeggsorsomething.com/",
 "bio": "XO",
 "location": "Way out there",
 "total_likes": 5,
 "total_photos": 74,
 "total_collections": 52,
 "profile_image": {
 "small": "https://images.unsplash.com/face-springmorning.jpg?q=80&fm=jpg&crop=faces&fit=crop&h=32&w=32",
 "medium": "https://images.unsplash.com/face-springmorning.jpg?q=80&fm=jpg&crop=faces&fit=crop&h=64&w=64",
 "large": "https://images.unsplash.com/face-springmorning.jpg?q=80&fm=jpg&crop=faces&fit=crop&h=128&w=128"
 },
 "links": {
 "self": "https://api.unsplash.com/users/poorkane",
 "html": "https://unsplash.com/poorkane",
 "photos": "https://api.unsplash.com/users/poorkane/photos",
 "likes": "https://api.unsplash.com/users/poorkane/likes",
 "portfolio": "https://api.unsplash.com/users/poorkane/portfolio"
 }
 */
struct UserLinks: Codable {
    var me: String?
    var html: String?
    var photos : String?
    var likes : String?
    var portfolio : String?
}

class User: Codable {
    var id: String!
    var username: String?
    var name: String?
    var bio: String?
    var links: UserLinks?
}
