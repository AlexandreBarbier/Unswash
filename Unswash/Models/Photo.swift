//
//  Photo.swift
//  unsplash_finder
//
//  Created by Alexandre Barbier on 16/11/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//

import UIKit

public enum UnswashImageQuality: String {
    case full, small, thumb, regular, raw
}

struct PhotoUrls: Codable {
    var full: String
    var small: String
    var thumb: String
    var regular: String
    var raw: String
}

struct PhotoLinks:Codable {
    var download_location: String
    var html: String
    var download: String
}

class Photo: Codable {
    var id: String?
    var urls: PhotoUrls?
    var links: PhotoLinks?
    var user: User?
    
    class SearchResult: Codable {
        var results: [Photo]?
    }


    func getURLForQuality(quality: UnswashImageQuality) -> String {
        var url = ""
        switch quality {
        case .full:
            url = self.urls!.full
            break
        case .raw:
            url = self.urls!.raw
            break
        case .regular:
            url = self.urls!.regular
            break
        case .small:
            url = self.urls!.small
            break
        case .thumb:
            url = self.urls!.thumb
            break
        }
        return url
    }
}



