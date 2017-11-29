//
//  Unswash.swift
//  Unswash
//
//  Created by Alexandre Barbier on 20/11/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//


import UIKit

enum Order: String {
    case latest, oldest, popular
}

open class Unswash: NSObject {
    
    public static let client = Unswash()
    var client_id: String!
    var client_name: String!
    private override init(){}

    open func configure(clientId: String, clientName: String) {
        client_id = clientId
        client_name = clientName
    }
}
