//
//  RequestHelpers.swift
//  unsplash_finder
//
//  Created by Alexandre Barbier on 16/11/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//

import UIKit

class Request: NSObject {
    let requestQueue = OperationQueue()
    private static let _client = Request()
    let session: URLSession!

    private static let baseURL = "https://api.unsplash.com/"


    private override init() {
        guard let clientId = Unswash.client.client_id else {
            fatalError("You must set your unsplash app Id")
        }
        requestQueue.name = "Request Queue"
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Authorization" : "Client-ID \(clientId)"]
        session = URLSession(configuration: config, delegate: nil, delegateQueue: requestQueue)
    }

    class func GETRequest(path: String, params: [String: AnyObject]?, completion:@escaping (_ data: Data?)-> Void) {
        let request = URLRequest(url: URL(string: "\(baseURL + path)")!)
        _client.session.dataTask(with: request) { (data, response, error) in
            completion(data)
            }.resume()
    }
}
