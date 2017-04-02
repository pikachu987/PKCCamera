//
//  ViewController.swift
//  PKCCamera
//
//  Created by pikachu987 on 04/01/2017.
//  Copyright (c) 2017 pikachu987. All rights reserved.
//

import UIKit
import PKCCamera

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let pkcCamera = PKCCamera()
        pkcCamera.delegate = self
        pkcCamera.open()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: PKCCameraDelegate{
    func pkcCameraVisibleViewController() -> UIViewController {
        return self
    }
    func pkcCameraImage(_ image: UIImage, navigationController: UINavigationController, visibleViewController: UIViewController) {
        
    }
}
