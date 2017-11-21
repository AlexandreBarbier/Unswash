//
//  ViewController.swift
//  UnswashSample
//
//  Created by Alexandre Barbier on 20/11/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//

import UIKit
import Unswash

class ViewController: UIViewController {
    @IBOutlet var imageV: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonTouch(_ sender: Any) {
        UnswashPhotoViewController.picker().present(in: self, quality: .regular) { image, url in
            DispatchQueue.main.async {
                self.imageV.image = image
            }
        }
    }

}

