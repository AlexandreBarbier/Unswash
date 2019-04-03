//
//  Errors.swift
//  Unswash
//
//  Created by Alexandre Barbier on 24/11/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//

import UIKit
/*
 {
 "errors": ["Username is missing", "Password cannot be blank"]
 }
 */
struct Errors: Codable {
    var errors: [String]?
}
