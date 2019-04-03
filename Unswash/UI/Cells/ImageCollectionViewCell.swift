//
//  ImageCollectionViewCell.swift
//  unsplash_finder
//
//  Created by Alexandre Barbier on 17/11/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//

import UIKit

protocol ImageCollectionViewCellDelegate: class {
    func authorSelected(index: Int)
}

class ImageCollectionViewCell: UICollectionViewCell {
    static let identifier = "ImageCollectionViewCell"
    var dataTask: URLSessionDataTask?
    weak var delegate: ImageCollectionViewCellDelegate?
    var index = 0
    private var gradientLayer : CAGradientLayer = {
        $0.colors = [UIColor.lightGray.withAlphaComponent(0.2).cgColor, UIColor.lightGray.withAlphaComponent(0.4).cgColor, UIColor.lightGray.withAlphaComponent(0.2).cgColor]
        $0.startPoint = CGPoint(x: 0, y: 0)
        $0.endPoint = CGPoint(x: 0.0, y: 0)
        return $0
    }(CAGradientLayer())

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var authorButton: UIButton!



    override func awakeFromNib() {
        super.awakeFromNib()
        let animationStart : CABasicAnimation = {
            $0.fromValue = CGPoint(x: 0, y: 0.0)
            $0.toValue = CGPoint(x: 1.6, y: 0.0)
            $0.duration = 2.4
            $0.fillMode = CAMediaTimingFillMode.both
            $0.repeatCount = MAXFLOAT
            $0.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            return $0
        }(CABasicAnimation(keyPath: "startPoint"))

        let animationEnd : CABasicAnimation = {
            $0.fromValue = CGPoint(x: -0.5, y: 0.0)
            $0.toValue = CGPoint(x: 1.1, y: 0.0)
            $0.duration = 2.4
            $0.fillMode = CAMediaTimingFillMode.both
            $0.repeatCount = MAXFLOAT
            $0.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            return $0
        }(CABasicAnimation(keyPath: "endPoint"))
        gradientLayer.add(animationStart, forKey: "animateGradientStart")
        gradientLayer.add(animationEnd, forKey: "animateGradient")
    }

    func startAnimation() {
        OperationQueue.main.addOperation {
            self.gradientLayer.removeFromSuperlayer()
            self.imageView.layer.insertSublayer(self.gradientLayer, at: 0)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = imageView.bounds
    }

    func stopAnimation() {
        OperationQueue.main.addOperation {
            self.gradientLayer.removeFromSuperlayer()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dataTask?.cancel()
        imageView.image = nil
    }

    @IBAction func authorTouch(_ sender: Any) {
        delegate?.authorSelected(index: index)
    }
}
