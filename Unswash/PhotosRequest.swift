//
//  PhotosRequest.swift
//  Unswash
//
//  Created by Alexandre Barbier on 29/11/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//

import UIKit

extension Unswash {
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

        // https://unsplash.com/documentation#list-photos
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

        // https://unsplash.com/documentation#get-a-photo
        static func getPhoto(id: String, w: Int = Int(UIScreen.main.bounds.width), h: Int = Int(UIScreen.main.bounds.height), completion: @escaping (Photo?, Errors?) -> Void) {
            Request.GETRequest(path: "photos/\(id)?w=\(w)&h=\(h)", params: nil) { (data) in
                guard let data = data else {
                    return
                }
                let decoder = JSONDecoder()

                do {
                    let k  = try decoder.decode(Photo.self, from: data)
                    if k.id == nil {
                        let err = try decoder.decode(Errors.self, from: data)
                        completion(nil, err)
                    }
                    completion(k, nil)
                } catch {
                    do {
                        let k = try decoder.decode(Errors.self, from: data)
                        completion(nil, k)
                    } catch {
                        let dataString = String(data: data, encoding: .utf8)
                        let err = Errors()
                        err.errors = [dataString!]
                        completion(nil, err)
                    }

                }
            }
        }
    }
}

