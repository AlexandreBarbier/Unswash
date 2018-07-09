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
    var gl : CAGradientLayer = {
        $0.colors = [UIColor.white.cgColor, UIColor.black.cgColor]
        $0.startPoint = CGPoint(x: 0.0, y: 0.0)
        $0.endPoint = CGPoint(x: 1.0, y: 0.0)
        return $0
    }(CAGradientLayer())

    let animation : CABasicAnimation = {
        $0.fromValue = [UIColor.white.cgColor, UIColor.black.cgColor]
        $0.toValue = [UIColor.black.cgColor, UIColor.white.cgColor]
        $0.duration = 3.00

        $0.isRemovedOnCompletion = true
        $0.fillMode = kCAFilterLinear
        $0.repeatCount = Float(INT_MAX)
        $0.autoreverses = true
        $0.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        return $0
    }(CABasicAnimation(keyPath: "colors"))

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var authorButton: UIButton!

    @IBAction func authorTouch(_ sender: Any) {
        delegate?.authorSelected(index: index)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        gl.add(animation, forKey: "animateGradient")
    }



    func startAnimation() {
        imageView.layer.insertSublayer(gl, at: 0)
    }

    func stopAnimation() {
        gl.removeFromSuperlayer()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gl.frame = imageView.bounds
    }

    override func prepareForReuse() {
        imageView.image = nil
    }
}
