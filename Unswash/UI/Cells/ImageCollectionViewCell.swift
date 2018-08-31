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
    var dataTask: URLSessionDataTask?
    var delegate: ImageCollectionViewCellDelegate?
    var index = 0
    var gradientLayer : CAGradientLayer = {
        $0.colors = [UIColor.lightGray.cgColor, UIColor.lightGray.withAlphaComponent(0.7).cgColor, UIColor.white.cgColor]
        $0.startPoint = CGPoint(x: 0.0, y: 0.2)
        $0.endPoint = CGPoint(x: 0.2, y: 0.2)
        return $0
    }(CAGradientLayer())

    let animationEnd : CABasicAnimation = {
        $0.fromValue = CGPoint(x: 0, y: 0.0)
        $0.toValue = CGPoint(x: 1.2, y: 0.0)
        $0.duration = 2.4
        $0.isRemovedOnCompletion = true
        $0.fillMode = CAMediaTimingFillMode.both
        $0.autoreverses = true
        $0.repeatCount = MAXFLOAT
        $0.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        return $0
    }(CABasicAnimation(keyPath: "endPoint"))

    let animationStart : CABasicAnimation = {
        $0.fromValue = CGPoint(x: -0.2, y: 0.0)
        $0.toValue = CGPoint(x: 1, y: 0.0)
        $0.duration = 2.4
        $0.isRemovedOnCompletion = true
        $0.fillMode = CAMediaTimingFillMode.both
        $0.repeatCount = MAXFLOAT
        $0.autoreverses = true
        $0.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        return $0
    }(CABasicAnimation(keyPath: "startPoint"))


    @IBOutlet var imageView: UIImageView!
    @IBOutlet var authorButton: UIButton!

    @IBAction func authorTouch(_ sender: Any) {
        delegate?.authorSelected(index: index)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        gradientLayer.add(animationStart, forKey: "animateGradientStart")
        gradientLayer.add(animationEnd, forKey: "animateGradient")
    }



    func startAnimation() {
        gradientLayer.removeFromSuperlayer()
        imageView.layer.insertSublayer(gradientLayer, at: 0)
    }

    func stopAnimation() {
        gradientLayer.removeFromSuperlayer()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = imageView.bounds
    }

    override func prepareForReuse() {
        imageView.image = nil
    }
}
