//
//  PKCNavigationController.swift
//  Pods
//
//  Created by guanho on 2017. 4. 3..
//
//

import UIKit


protocol PKCNavigationDelegate {
    func pkcNavigationImage(_ image: UIImage, viewController: UIViewController?, navigationViewController: UINavigationController?)
    func pkcNavigationCancel()
}

class PKCNavigationController: UINavigationController {
    var pkcDelegate: PKCNavigationDelegate?
}
