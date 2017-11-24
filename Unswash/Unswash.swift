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

    public struct Photos {

        static func search(query: String, page: Int = 1, per_page: Int = 10, completion: @escaping ([Photo], Errors?) -> Void) {
            Request.GETRequest(path: "search/photos?query=\(query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")&page=\(page)&per_page=\(per_page)", params: nil) { (data) in
                guard let data = data else {
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let k = try decoder.decode(Photo.SearchResult.self, from: data)
                    completion(k.results!, nil)
                } catch {
                    do {
                        let k = try decoder.decode(Errors.self, from: data)
                        completion([], k)
                    } catch {
                        let dataString = String(data: data, encoding: .utf8)
                        let err = Errors()
                        err.errors = [dataString!]
                        completion([], err)
                    }

                }

            }
        }

        static func get(page: Int = 1, per_page: Int = 10, order_by: Order = Order.latest, completion: @escaping ([Photo], Errors?) -> Void) {
            Request.GETRequest(path: "photos?page=\(page)&per_page=\(per_page)&order_by=\(order_by.rawValue)", params: nil) { (data) in
                guard let data = data else {
                    return
                }
                let decoder = JSONDecoder()
                
                do {
                    let k  = try decoder.decode([Photo].self, from: data)
                    completion(k, nil)
                } catch {
                    do {
                        let k = try decoder.decode(Errors.self, from: data)
                        completion([], k)
                    } catch {
                        let dataString = String(data: data, encoding: .utf8)
                        let err = Errors()
                        err.errors = [dataString!]
                        completion([], err)
                    }

                }

            }
        }
    }

}
