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
    var startBtn : UIButton!
    var img: UIImageView!
    var segmented: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.segmented = UISegmentedControl()
        self.segmented.frame = CGRect(x: 10, y: 30, width: UIScreen.main.bounds.width-20, height: 40)
        self.view.addSubview(self.segmented)
        self.segmented.insertSegment(withTitle: "onlyCheck", at: 0, animated: false)
        self.segmented.insertSegment(withTitle: "DeniedAlert", at: 0, animated: false)
        self.segmented.insertSegment(withTitle: "AlertMsg", at: 0, animated: false)
        self.segmented.insertSegment(withTitle: "Default", at: 0, animated: false)
        self.segmented.selectedSegmentIndex = 0
        
        
        self.startBtn = UIButton()
        self.startBtn.setTitle("Start", for: .normal)
        self.startBtn.setTitleColor(.blue, for: .normal)
        self.startBtn.frame = CGRect(x: UIScreen.main.bounds.width/2-40, y: 90, width: 80, height: 40)
        self.view.addSubview(self.startBtn)
        self.startBtn.addTarget(self, action: #selector(self.startAction(_:)), for: .touchUpInside)
        
        self.img = UIImageView()
        self.img.frame = CGRect(x: 0, y: 150, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-150)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startAction(_ sender: UIButton) {
        if segmented.selectedSegmentIndex == 0{//Default
            let pkcCamera = PKCCamera()
            pkcCamera.delegate = self
            pkcCamera.open()
        }else if segmented.selectedSegmentIndex == 1{//AlertMsg
            let pkcCamera = PKCCamera()
            pkcCamera.delegate = self
            pkcCamera.deniedAlertMessage("Alert", message: "Denied", confirm: "SettingMove", cancel: "Cancel")
            pkcCamera.open()
        }else if segmented.selectedSegmentIndex == 2{//DeniedAlert
            let pkcCamera = PKCCamera(isDeniedAlert: false)
            pkcCamera.delegate = self
            pkcCamera.open()
        }else if segmented.selectedSegmentIndex == 3{//onlyCheck
            let pkcCamera = PKCCamera()
            pkcCamera.delegate = self
            pkcCamera.open(.onlyCheck)
        }
    }
    
}


extension ViewController: PKCCameraDelegate{
    func pkcCameraVisibleViewController() -> UIViewController {
        return self
    }
    func pkcCameraImage(_ image: UIImage, viewController: UIViewController?, navigationViewController: UINavigationController?) {
        self.img.image = image
        viewController?.dismiss(animated: true, completion: nil)
    }
    func pkcCameraOpen() {
        print("pkcCameraOpen")
    }
    func pkcCameraCancel() {
        print("pkcCameraCancel")
    }
    
    func pkcCameraUndentermined() {
        print("pkcCameraUndentermined")
    }
    func pkcCameraGranted() {
        print("pkcCameraGranted")
    }
    func pkcCameraDenied() {
        print("pkcCameraDenied")
    }
}
