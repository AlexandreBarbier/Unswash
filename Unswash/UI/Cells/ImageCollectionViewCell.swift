//
//  ImageCollectionViewCell.swift
//  unsplash_finder
//
//  Created by Alexandre Barbier on 17/11/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//

import UIKit

protocol ImageCollectionViewCellDelegate {
    func authorSelected(index: Int)
}

class ImageCollectionViewCell: UICollectionViewCell {
    static let identifier = "ImageCollectionViewCell"
    var dataTask: URLSessionDataTask!
    var delegate: ImageCollectionViewCellDelegate?
    var index = 0

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var authorButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        authorButton.isHidden = true
    }

    @IBAction func authorTouch(_ sender: Any) {
        delegate?.authorSelected(index: index)
    }
}
